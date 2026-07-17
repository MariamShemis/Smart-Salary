import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/features/auth/data/model/user_model.dart';
import 'package:smart_salary/features/firebase/firebase_services.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  StreamSubscription? _subscription;

  void listenProfile() {
    _subscription?.cancel();

    _subscription = FirebaseServices.profileStream().listen(
          (user) {
        emit(ProfileSuccess(user));
      },
      onError: (e) {
        emit(ProfileError(e.toString()));
      },
    );
  }

  Future<void> logout() async {
    try {
      await _subscription?.cancel();
      await FirebaseServices.logout();
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}