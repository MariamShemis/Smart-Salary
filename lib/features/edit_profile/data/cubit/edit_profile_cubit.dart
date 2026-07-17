import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/features/edit_profile/data/model/edit_profile_model.dart';
import 'package:smart_salary/features/edit_profile/data/cubit/edit_profile_state.dart';
import 'package:smart_salary/features/firebase/firebase_services.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  EditProfileModel? profile;

  static EditProfileCubit get(context) => BlocProvider.of(context);

  Future<void> loadProfile() async {
    emit(EditProfileLoading());

    try {
      final user = await FirebaseServices.getCurrentUser();

      profile = EditProfileModel(
        name: user.name,
        email: user.email,
        phone: user.phone,
        jobTitle: user.jobTitle,
        birthday: user.birthday,
        gender: user.gender,
        image: user.image,
      );

      emit(EditProfileLoaded(profile!));
    } catch (e) {
      emit(EditProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String jobTitle,
    required String birthday,
    required String gender,
    File? image,
  }) async {
    emit(EditProfileSaving());

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseServices.updateProfile(
        uid: uid,
        name: name,
        email: email,
        phone: phone,
        jobTitle: jobTitle,
        birthday: birthday,
        gender: gender,
        image: image,
      );

      await loadProfile();

      emit(EditProfileSuccess());
    } catch (e) {
      emit(EditProfileError(e.toString()));
    }
  }
}