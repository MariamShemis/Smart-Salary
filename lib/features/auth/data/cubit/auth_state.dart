import 'package:smart_salary/features/auth/data/model/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {}

class RegisterError extends AuthState {
  final String message;

  RegisterError(this.message);
}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final UserModel user;

  LoginSuccess(this.user);
}

class LoginError extends AuthState {
  final String message;

  LoginError(this.message);
}

class ResetPasswordLoading extends AuthState {}

class ResetPasswordSuccess extends AuthState {}

class ResetPasswordError extends AuthState {
  final String message;

  ResetPasswordError(this.message);
}