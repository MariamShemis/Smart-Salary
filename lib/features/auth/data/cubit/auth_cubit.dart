import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/features/auth/data/model/login_request.dart';
import 'package:smart_salary/features/auth/data/model/register_request.dart';
import 'package:smart_salary/features/firebase/firebase_services.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> register(RegisterRequest request , BuildContext context) async {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    emit(RegisterLoading());

    try {
      await FirebaseServices.register(request);
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      emit(RegisterError(_firebaseErrorMessage(e , context)));
    } catch (_) {
      emit(RegisterError(appLocalizations.something_went_wrong_Please_try_again));
    }
  }

  Future<void> login(LoginRequest request , BuildContext context) async {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    emit(LoginLoading());

    try {
      await FirebaseServices.login(request);
      final user = await FirebaseServices.getCurrentUser();
      emit(LoginSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(LoginError(_firebaseErrorMessage(e , context)));
    } catch (_) {
      emit(LoginError(appLocalizations.something_went_wrong_Please_try_again));
    }
  }

  Future<void> logout() async {
    await FirebaseServices.logout();
    emit(AuthInitial());
  }

  Future<void> resetPassword(String email , BuildContext context) async {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    emit(ResetPasswordLoading());

    try {
      await FirebaseServices.resetPassword(email);
      emit(ResetPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      emit(ResetPasswordError(_firebaseErrorMessage(e , context)));
    } catch (_) {
      emit(ResetPasswordError(appLocalizations.something_went_wrong_Please_try_again));
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    emit(LoginLoading());

    try {
      final user = await FirebaseServices.signInWithGoogle();
      emit(LoginSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(LoginError(_firebaseErrorMessage(e , context)));
    } catch (_) {
      emit(LoginError(appLocalizations.something_went_wrong_Please_try_again));
    }
  }

  String _firebaseErrorMessage(FirebaseAuthException e , BuildContext context) {
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
