abstract class SalaryState {}

class SalaryInitial extends SalaryState {}

class SalaryLoading extends SalaryState {}

class SalarySuccess extends SalaryState {
  final double dailyCount;
  final double overtimeMonth;
  final double bonusMonth;
  final double deduction;
  final double reward;
  final double vacation;
  final double totalSalary;
  final double totalSalaryWithReward;
  final double annualOvertime;
  final double annualBonus;

  SalarySuccess({
    required this.dailyCount,
    required this.overtimeMonth,
    required this.bonusMonth,
    required this.deduction,
    required this.reward,
    required this.vacation,
    required this.totalSalary,
    required this.totalSalaryWithReward, required this.annualOvertime, required this.annualBonus,
  });
}

class SalaryError extends SalaryState {
  final String message;

  SalaryError(this.message);
}