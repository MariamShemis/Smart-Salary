import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/features/onboarding/data/cubit/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState(0));

  void updatePageIndex(int index) {
    emit(OnboardingState(index));
  }

  void nextPage(int totalPages) {
    if (state.currentPageIndex < totalPages - 1) {
      emit(OnboardingState(state.currentPageIndex + 1));
    }
  }
}