import 'package:smart_salary/features/auth/data/model/user_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserModel user;

  ProfileSuccess(this.user);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class LogoutLoading extends ProfileState {}

class LogoutSuccess extends ProfileState {}

class LogoutError extends ProfileState {
  final String message;

  LogoutError(this.message);
}