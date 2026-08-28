import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/features/firebase/firebase_services.dart';

import 'verify_email_state.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  VerifyEmailCubit() : super(VerifyEmailInitial());

  Future<void> sendEmailVerification() async {
    try {
      emit(VerifyEmailLoading());

      await FirebaseServices.sendEmailVerification();

      emit(VerifyEmailSent());
    } on FirebaseAuthException catch (e) {
      emit(VerifyEmailError(_getFirebaseErrorMessage(e.code)));
    } catch (_) {
      emit(
        VerifyEmailError(
          "Something went wrong. Please try again.",
        ),
      );
    }
  }

  Future<void> checkEmailVerificationManually() async {
    try {
      emit(VerifyEmailChecking());

      final verified = await FirebaseServices.checkEmailVerified();

      if (verified) {
        emit(VerifyEmailVerified());
      } else {
        emit(VerifyEmailError("Your email is not verified yet."));
      }
    } catch (_) {
      emit(VerifyEmailError("Unable to check email verification."));
    }
  }

  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case "too-many-requests":
        return "Too many requests. Please try again later.";
      case "user-not-found":
        return "User not found.";
      case "network-request-failed":
        return "Check your internet connection.";
      case "already-verified":
        return "Your email is already verified.";
      default:
        return "Unable to send verification email.";
    }
  }
}