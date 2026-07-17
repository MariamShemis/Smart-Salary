import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/features/firebase/firebase_services.dart';
import 'package:smart_salary/features/firebase/salary_firestore_services.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> loadHome() async {
    emit(HomeLoading());

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final month = await SalaryFirestoreServices.loadSelectedMonth(uid);

    final result = await SalaryFirestoreServices.loadSalaryResult(
      uid: uid,
      month: month,
    );

    final yearlyResult = await SalaryFirestoreServices.loadYearlySalaryResults(
      uid: uid,
      year: month.year,
    );

    final salaryInputs = await SalaryFirestoreServices.loadSalaryInputs(uid: uid , month: month);

    final totals = await SalaryFirestoreServices.loadMonthlyTotals(
      uid: uid,
      month: month,
    );

    final user = await FirebaseServices.getCurrentUser();

    emit(
      HomeLoaded(
        month: month,
        user: user,
        homeData: {
          "basicSalary":
          double.tryParse(salaryInputs["basic"] ?? "0") ?? 0,
          "overtimeDays": totals["overtime"] ?? 0,
          "bonusDays": totals["bonus"] ?? 0,

          "totalSalary": result["totalSalary"] ?? 0,
          "totalSalaryWithReward":
          result["totalSalaryWithReward"] ?? 0,
          "overtimeMonth": result["overtimeMonth"] ?? 0,
          "bonusMonth": result["bonusMonth"] ?? 0,
          "deduction": result["deduction"] ?? 0,
          "vacationDays": result["vacationDays"] ?? 30,

          "annualOvertime": yearlyResult["annualOvertime"] ?? 0,
          "annualBonus": yearlyResult["annualBonus"] ?? 0,
        },
      ),
    );
  }
}
