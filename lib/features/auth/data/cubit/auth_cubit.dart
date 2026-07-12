import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/features/auth/data/model/login_request.dart';
import 'package:smart_salary/features/auth/data/model/register_request.dart';
import 'package:smart_salary/features/firebase/firebase_services.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> register(RegisterRequest request) async {
    emit(RegisterLoading());

    try {
      await FirebaseServices.register(request);
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      emit(RegisterError(_firebaseErrorMessage(e)));
    } catch (_) {
      emit(RegisterError("Something went wrong. Please try again."));
    }
  }

  Future<void> login(LoginRequest request) async {
    emit(LoginLoading());

    try {
      await FirebaseServices.login(request);
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginError(_firebaseErrorMessage(e)));
    } catch (_) {
      emit(LoginError("Something went wrong. Please try again."));
    }
  }

  Future<void> logout() async {
    await FirebaseServices.logout();
    emit(AuthInitial());
  }

  Future<void> resetPassword(String email) async {
    emit(ResetPasswordLoading());

    try {
      await FirebaseServices.resetPassword(email);
      emit(ResetPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      emit(ResetPasswordError(_firebaseErrorMessage(e)));
    } catch (_) {
      emit(
        ResetPasswordError(
          "Something went wrong. Please try again.",
        ),
      );
    }
  }

  String _firebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already in use.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'weak-password':
        return 'Password is too weak.';

      case 'user-not-found':
        return 'No account found with this email.';

      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      default:
        return 'Something went wrong. Please try again.';
    }
  }
}