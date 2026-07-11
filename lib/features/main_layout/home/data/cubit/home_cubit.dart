import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/core/session_service/session_service.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> loadHome() async {
    emit(HomeLoading());

    final month = await SessionService.loadSelectedMonth();
    final data = await SessionService.loadSalaryResults(month);

    emit(
      HomeLoaded(
        month: month,
        homeData: data,
      ),
    );
  }
}