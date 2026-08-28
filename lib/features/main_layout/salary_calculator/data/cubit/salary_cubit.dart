import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/features/firebase/salary_firestore_services.dart';

import 'salary_state.dart';

class SalaryCubit extends Cubit<SalaryState> {
  SalaryCubit() : super(SalaryInitial());

  Future<void> loadSalary(DateTime month) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // final results = await Future.wait([
      //   SalaryFirestoreServices.loadSalaryInputs(
      //     uid: uid,
      //     month: month,
      //   ),
      //   SalaryFirestoreServices.loadYearlySalaryResults(
      //     uid: uid,
      //     year: month.year,
      //   ),
      //   SalaryFirestoreServices.loadMonthlySalaryData(
      //     uid: uid,
      //     month: month,
      //   ),
      //   SalaryFirestoreServices.loadYearlyAbsent(
      //     uid: uid,
      //     year: month.year,
      //   ),
      // ]);

      final results = await Future.wait([
        SalaryFirestoreServices.loadSalaryInputs(uid: uid, month: month),
        SalaryFirestoreServices.loadMonthlyTotals(uid: uid, month: month),
        SalaryFirestoreServices.loadYearlySalaryResults(
          uid: uid,
          year: month.year,
        ),
        SalaryFirestoreServices.loadMonthlySalaryData(uid: uid, month: month),
        SalaryFirestoreServices.loadYearlyAbsent(uid: uid, year: month.year),
      ]);

      final salary = results[0] as Map<String, dynamic>;
      final totals = results[1] as Map<String, double>;
      final yearlySalary = results[2] as Map<String, double>;
      final monthData = results[3] as Map<String, dynamic>;
      final yearlyAbsent = results[4] as double;

      await calculateSalary(
        month: month,
        basic: double.tryParse(salary["basic"] ?? "0") ?? 0,
        divisor: double.tryParse(salary["divisor"] ?? "30") ?? 30,
        overtimeMultiplier:
            double.tryParse(monthData["overtimeMultiplier"] ?? "0") ?? 0,
        bonusValue: double.tryParse(monthData["bonusValue"] ?? "20") ?? 20,
        overtimeDays: totals["overtime"] ?? 0,
        bonusDays: totals["bonus"] ?? 0,
        annualOvertime: yearlySalary["annualOvertime"] ?? 0,
        annualBonus: yearlySalary["annualBonus"] ?? 0,
        deductionAbsent: double.tryParse(monthData["deductAbsent"] ?? "0") ?? 0,
        deductionCustom: double.tryParse(monthData["deductCustom"] ?? "0") ?? 0,
        rewardValue: double.tryParse(monthData["rewardValue"] ?? "0") ?? 0,
        rewardMultiplier:
            double.tryParse(monthData["rewardMultiplier"] ?? "0") ?? 0,
        vacation: 30 - yearlyAbsent,
      );
    } catch (e, s) {
      print("The error : $e");
      print(s);
    }
  }

  Future<void> calculateSalary({
    required DateTime month,
    required double basic,
    required double divisor,
    required double overtimeDays,
    required double overtimeMultiplier,
    required double bonusDays,
    required double bonusValue,
    required double deductionAbsent,
    required double deductionCustom,
    required double rewardValue,
    required double rewardMultiplier,
    required double vacation,
    double annualOvertime = 0,
    double annualBonus = 0,
  }) async {
    final double dailyCount = divisor == 0 ? 0 : basic / divisor;

    final double overtimeMonth =
        (overtimeDays * dailyCount) + (overtimeMultiplier * dailyCount);

    final double bonusMonth = bonusDays * bonusValue;

    final double deduction = deductionAbsent + (deductionCustom * dailyCount);

    final double reward = rewardValue + (basic * rewardMultiplier);

    final double totalSalary = basic + overtimeMonth + bonusMonth - deduction;

    final double totalSalaryWithReward = totalSalary + reward;

    await SalaryFirestoreServices.saveSalaryResult(
      uid: FirebaseAuth.instance.currentUser!.uid,
      month: month,
      totalSalary: totalSalary,
      totalSalaryWithReward: totalSalaryWithReward,
      overtimeMonth: overtimeMonth,
      bonusMonth: bonusMonth,
      deduction: deduction,
      vacationDays: vacation,
    );

    emit(
      SalarySuccess(
        dailyCount: dailyCount,
        overtimeMonth: overtimeMonth,
        bonusMonth: bonusMonth,
        deduction: deduction,
        reward: reward,
        vacation: vacation,
        totalSalary: totalSalary,
        totalSalaryWithReward: totalSalaryWithReward,
        annualOvertime: annualOvertime,
        annualBonus: annualBonus,
      ),
    );
  }
}
