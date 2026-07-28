import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/features/auth/data/model/user_model.dart';
import 'package:smart_salary/features/firebase/firebase_services.dart';
import 'package:smart_salary/features/firebase/salary_firestore_services.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  StreamSubscription<UserModel>? _userSubscription;

  void listenUser() {
    emit(HomeLoading());

    _userSubscription?.cancel();

    _userSubscription = FirebaseServices.profileStream().listen(
      (user) async {
        final uid = FirebaseAuth.instance.currentUser!.uid;

        final month = await SalaryFirestoreServices.loadSelectedMonth(uid);

        final result = await SalaryFirestoreServices.loadSalaryResult(
          uid: uid,
          month: month,
        );

        final yearlyResult =
            await SalaryFirestoreServices.loadYearlySalaryResults(
              uid: uid,
              year: month.year,
            );

        final salaryInputs = await SalaryFirestoreServices.loadSalaryInputs(
          uid: uid,
          month: month,
        );

        final totals = await SalaryFirestoreServices.loadMonthlyTotals(
          uid: uid,
          month: month,
        );

        emit(
          HomeLoaded(
            month: month,
            user: user,
            homeData: {
              "basicSalary": double.tryParse(salaryInputs["basic"] ?? "0") ?? 0,

              "overtimeDays": totals["overtime"]?.toDouble() ?? 0,

              "bonusDays": totals["bonus"]?.toDouble() ?? 0,

              "totalSalary": result["totalSalary"] ?? 0,

              "totalSalaryWithReward": result["totalSalaryWithReward"] ?? 0,

              "overtimeMonth": result["overtimeMonth"] ?? 0,

              "bonusMonth": result["bonusMonth"] ?? 0,

              "deduction": result["deduction"] ?? 0,

              "vacationDays": result["vacationDays"] ?? 30,

              "annualOvertime": yearlyResult["annualOvertime"] ?? 0,

              "annualBonus": yearlyResult["annualBonus"] ?? 0,
            },
          ),
        );
      },
      onError: (e) {
        emit(HomeError(e.toString()));
      },
    );
  }

  Future<void> loadHome() async {
    listenUser();
  }

  @override
  Future<void> close() async {
    await _userSubscription?.cancel();
    return super.close();
  }
}
