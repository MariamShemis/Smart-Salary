import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/features/auth/data/model/user_model.dart';
import 'package:smart_salary/features/firebase/firebase_services.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());

    try {
      UserModel user = await FirebaseServices.getCurrentUser();

      emit(ProfileSuccess(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(LogoutLoading());

    try {
      await FirebaseServices.logout();

      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutError("Failed to logout"));
    }
  }
}