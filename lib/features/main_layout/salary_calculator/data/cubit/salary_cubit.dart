import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/core/session_service/session_service.dart';

import 'salary_state.dart';

class SalaryCubit extends Cubit<SalaryState> {
  SalaryCubit() : super(SalaryInitial());

  Future<void> loadSalary(DateTime month) async {
    final salary = await SessionService.loadSalaryInputs();
    final totals = await SessionService.loadMonthlyTotals(month);
    final monthData = await SessionService.loadMonthlySalaryData(month);
    final yearlyAbsent = await SessionService.loadYearlyAbsent(month);

    await calculateSalary(
      month: month,
      basic: double.tryParse(salary["basic"] ?? "0") ?? 0,
      divisor: double.tryParse(salary["divisor"] ?? "30") ?? 30,
      overtimeMultiplier:
      double.tryParse(monthData["overtimeMultiplier"] ?? "0") ?? 0,
      bonusValue:
      double.tryParse(monthData["bonusValue"] ?? "20") ?? 20,
      overtimeDays: totals["overtime"] ?? 0,
      bonusDays: totals["bonus"] ?? 0,
      deductionAbsent:
      double.tryParse(monthData["deductAbsent"] ?? "0") ?? 0,
      deductionCustom:
      double.tryParse(monthData["deductCustom"] ?? "0") ?? 0,
      rewardValue:
      double.tryParse(monthData["rewardValue"] ?? "0") ?? 0,
      rewardMultiplier:
      double.tryParse(monthData["rewardMultiplier"] ?? "0") ?? 0,
      vacation: 30 - yearlyAbsent,
    );
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
  }) async {
    final double dailyCount = divisor == 0 ? 0 : basic / divisor;

    final overtimeMonth =
        (overtimeDays * dailyCount) +
            (overtimeMultiplier * dailyCount);

    final bonusMonth = bonusDays * bonusValue;

    final deduction =
        deductionAbsent + (deductionCustom * dailyCount);

    final reward =
        rewardValue + (basic * rewardMultiplier);

    final totalSalary =
        basic + overtimeMonth + bonusMonth - deduction;

    final totalSalaryWithReward =
        totalSalary + reward;

    await SessionService.saveSalaryResults(
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
      ),
    );
  }
}