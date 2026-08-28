import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_salary/core/session_service/secure_storage_service.dart';
import 'package:smart_salary/features/account_security/data/cubit/account_security_state.dart';
import 'package:smart_salary/features/firebase/firebase_services.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class AccountSecurityCubit extends Cubit<AccountSecurityState> {
  AccountSecurityCubit() : super(AccountSecurityInitial());

  User? get currentUser => FirebaseServices.currentFirebaseUser();

  String get email => currentUser?.email ?? "";

  bool get isEmailVerified {
    return currentUser?.emailVerified ?? false;
  }

  bool get isEmailAccount {
    return currentUser?.providerData.any(
          (provider) => provider.providerId == "password",
        ) ??
        false;
  }

  Future<void> reloadUser() async {
    try {
      await FirebaseServices.currentFirebaseUser()?.reload();
      emit(EmailVerificationUpdated(isEmailVerified));
    } catch (e) {
      debugPrint("Error reloading user: $e");
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required BuildContext context,
  }) async {
    final appLocalizations = AppLocalizations.of(context)!;

    emit(ChangePasswordLoading());

    try {
      await FirebaseServices.reauthenticate(currentPassword);

      await currentUser!.updatePassword(newPassword);

      await SecureStorageService.saveLogin(
        email: currentUser!.email!,
        password: newPassword,
      );

      emit(ChangePasswordSuccess());
    } on FirebaseAuthException catch (e) {
      emit(
        ChangePasswordError(e.message ?? appLocalizations.something_went_wrong),
      );
    } catch (_) {
      emit(ChangePasswordError(appLocalizations.something_went_wrong));
    }
  }

  Future<void> deleteAccount({
    String? currentPassword,
    required BuildContext context,
  }) async {
    final appLocalizations = AppLocalizations.of(context)!;

    emit(DeleteAccountLoading());

    try {
      final user = currentUser;
      final uid = FirebaseServices.currentUserId();

      if (uid == null || user == null) {
        emit(DeleteAccountError(appLocalizations.user_not_found));
        return;
      }
      if (isEmailAccount) {
        if (currentPassword == null || currentPassword.trim().isEmpty) {
          emit(DeleteAccountError(appLocalizations.password_is_required));
          return;
        }

        await FirebaseServices.reauthenticate(currentPassword.trim());
      }
      await FirebaseServices.deleteUser(uid);
      await user.delete();
      await FirebaseServices.logout();

      emit(DeleteAccountSuccess());
    } on FirebaseAuthException catch (e) {
      emit(
        DeleteAccountError(e.message ?? appLocalizations.authentication_failed),
      );
    } catch (e) {
      emit(
        DeleteAccountError(
          "${appLocalizations.something_went_wrong}: ${e.toString()}",
        ),
      );
    }
  }

  Future<bool> isBiometricEnabled() {
    return FirebaseServices.getBiometricEnabled();
  }

  Future<void> enableBiometric() async {
    await FirebaseServices.setBiometricEnabled(true);

    emit(BiometricStatusChanged(true));
  }

  Future<void> disableBiometric() async {
    await FirebaseServices.setBiometricEnabled(false);

    emit(BiometricStatusChanged(false));
  }
}
