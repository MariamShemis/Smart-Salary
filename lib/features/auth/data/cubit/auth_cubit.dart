import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/core/session_service/biometric_service.dart';
import 'package:smart_salary/core/session_service/secure_storage_service.dart';
import 'package:smart_salary/features/auth/data/model/login_request.dart';
import 'package:smart_salary/features/auth/data/model/register_request.dart';
import 'package:smart_salary/features/firebase/firebase_services.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> register(RegisterRequest request, BuildContext context) async {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    emit(RegisterLoading());

    try {
      await FirebaseServices.register(request);
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      emit(RegisterError(_firebaseErrorMessage(e, context)));
    } catch (_) {
      emit(
        RegisterError(appLocalizations.something_went_wrong_Please_try_again),
      );
    }
  }

  Future<void> login(LoginRequest request, BuildContext context) async {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    emit(LoginLoading());

    try {
      await FirebaseServices.login(request);

      await SecureStorageService.saveLogin(
        email: request.email,
        password: request.password,
      );

      final biometricEnabled = await FirebaseServices.shouldUseBiometric();

      if (biometricEnabled) {
        final success = await BiometricService().authenticate();

        if (!success) {
          emit(LoginSuccess(await FirebaseServices.getCurrentUser()));
          return;
        }
      }

      final user = await FirebaseServices.getCurrentUser();
      emit(LoginSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(LoginError(_firebaseErrorMessage(e, context)));
    } catch (_) {
      emit(LoginError(appLocalizations.something_went_wrong_Please_try_again));
    }
  }

  Future<void> logout() async {
    await FirebaseServices.logout();
    await SecureStorageService.clear();
    emit(AuthInitial());
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    emit(ResetPasswordLoading());

    try {
      await FirebaseServices.resetPassword(email);
      print("SUCCESS");
      emit(ResetPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message);
      emit(ResetPasswordError(_firebaseErrorMessage(e, context)));
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    emit(LoginLoading());

    try {
      final user = await FirebaseServices.signInWithGoogle();
      if (user.email != null) {
        await SecureStorageService.saveGoogleLogin(email: user.email!);
      }

      emit(LoginSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(LoginError(_firebaseErrorMessage(e, context)));
    } catch (_) {
      emit(LoginError(appLocalizations.something_went_wrong_Please_try_again));
    }
  }

  Future<void> loginWithBiometric(BuildContext context) async {
    emit(LoginLoading());

    try {
      final success = await BiometricService().authenticate();

      if (!success) {
        emit(LoginError("Authentication failed"));
        return;
      }
      final isGoogleUser = await SecureStorageService.isGoogleUser();

      if (isGoogleUser) {
        final user = await FirebaseServices.signInWithGoogle();
        emit(LoginSuccess(user));
      } else {
        final email = await SecureStorageService.getEmail();
        final password = await SecureStorageService.getPassword();

        if (email == null || password == null) {
          emit(LoginError("Please login once using email."));
          return;
        }

        await FirebaseServices.login(
          LoginRequest(email: email, password: password),
        );

        final user = await FirebaseServices.getCurrentUser();
        emit(LoginSuccess(user));
      }
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  String _firebaseErrorMessage(FirebaseAuthException e, BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    switch (e.code) {
      case 'email-already-in-use':
        return appLocalizations.this_email_is_already_in_use;

      case 'invalid-email':
        return appLocalizations.please_enter_a_valid_email_address;

      case 'weak-password':
        return appLocalizations.password_is_too_weak;

      case 'user-not-found':
        return appLocalizations.no_account_found_with_this_email;

      case 'wrong-password':
      case 'invalid-credential':
        return appLocalizations.incorrect_email_or_password;

      case 'network-request-failed':
        return appLocalizations.please_check_your_internet_connection;

      case 'too-many-requests':
        return appLocalizations.too_many_attempts_Please_try_again_later;

      case 'google-sign-in-cancelled':
        return appLocalizations.google_sign_in_was_cancelled;

      default:
        return appLocalizations.something_went_wrong_Please_try_again;
    }
  }
}
