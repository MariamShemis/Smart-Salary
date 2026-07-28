import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_salary/features/account_security/data/cubit/account_security_state.dart';
import 'package:smart_salary/features/firebase/firebase_services.dart';

class AccountSecurityCubit extends Cubit<AccountSecurityState> {
  AccountSecurityCubit() : super(AccountSecurityInitial());

  User? get currentUser => FirebaseServices.currentFirebaseUser();

  String get email => currentUser?.email ?? "";

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoading());

    try {
      await FirebaseServices.reauthenticate(currentPassword);

      await currentUser!.updatePassword(newPassword);

      emit(ChangePasswordSuccess());
    } on FirebaseAuthException catch (e) {
      emit(ChangePasswordError(e.message ?? "Something went wrong"));
    } catch (_) {
      emit(ChangePasswordError("Something went wrong"));
    }
  }

  Future<void> deleteAccount({required String currentPassword}) async {
    emit(DeleteAccountLoading());

    try {
      await FirebaseServices.reauthenticate(currentPassword);

      final uid = FirebaseServices.currentUserId();

      if (uid == null) {
        emit(DeleteAccountError("User not found"));
        return;
      }

      await FirebaseServices.deleteUser(uid);

      await currentUser!.delete();

      emit(DeleteAccountSuccess());
    } on FirebaseAuthException catch (e) {
      emit(DeleteAccountError(e.message ?? "Something went wrong"));
    } catch (_) {
      emit(DeleteAccountError("Something went wrong"));
    }
  }

  Future<void> sendVerificationEmail() async {
    await FirebaseServices.sendVerificationEmail();
  }

  Future<void> reloadUser() async {
    await currentUser?.reload();

    emit(
      EmailVerificationUpdated(
        currentUser?.emailVerified ?? false,
      ),
    );
  }

  bool get isGoogleAccount {
    if (currentUser == null) return false;

    return currentUser!.providerData.any((e) => e.providerId == "google.com");
  }

  bool get isEmailAccount {
    if (currentUser == null) return false;

    return currentUser!.providerData.any((e) => e.providerId == "password");
  }
}
