import 'package:smart_salary/features/edit_profile/data/model/edit_profile_model.dart';

abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileLoaded extends EditProfileState {
  final EditProfileModel profile;

  EditProfileLoaded(this.profile);
}

class EditProfileSaving extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {}

class EditProfileError extends EditProfileState {
  final String message;

  EditProfileError(this.message);
}