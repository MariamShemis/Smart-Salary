import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/session_service/session_service.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/deduction_reward_card.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/salary_card.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/salary_header.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/salary_save_button.dart';

class SalaryCalculator extends StatefulWidget {
  const SalaryCalculator({super.key});

  @override
  State<SalaryCalculator> createState() => _SalaryCalculatorState();
}

class _SalaryCalculatorState extends State<SalaryCalculator> {
  DateTime _selectedMonth = DateTime.now();
  final TextEditingController _basicSalaryController = TextEditingController();

  final TextEditingController _dailyCountDivisorController =
      TextEditingController(text: "30");

  final TextEditingController _overtimeDaysController = TextEditingController();

  final TextEditingController _overtimeMultiplierController =
      TextEditingController();

  final TextEditingController _bonusDaysController = TextEditingController();

  final TextEditingController _bonusValueController = TextEditingController(
    text: "20",
  );

  final TextEditingController _absentDaysController = TextEditingController();

  final TextEditingController _deductionAbsentController =
      TextEditingController();

  final TextEditingController _deductionCustomController =
      TextEditingController();

  final TextEditingController _rewardValueController = TextEditingController();

  final TextEditingController _rewardMultiplierController =
      TextEditingController();

  double _dailyCountResult = 0;
  double _overtimeMonthResult = 0;
  double _bonusMonthResult = 0;
  double _annualVacationResult = 0;
  double _deductionResult = 0;
  double _rewardResult = 0;
  double _totalSalaryResult = 0;
  double _totalSalaryWithRewardResult = 0;

  @override
  void initState() {
    super.initState();

    _initialize();
  }
  Future<void> _initialize() async {
    await _loadSavedData();
    await _loadMonthData(_selectedMonth);
  }

  Future<void> _loadSavedData() async {
    final savedData = await SessionService.loadSalaryInputs();

    setState(() {
      _basicSalaryController.text = savedData['basic']!;
      _dailyCountDivisorController.text = savedData['divisor']!;
      _overtimeDaysController.text = savedData['otDays']!;
      _overtimeMultiplierController.text = savedData['otMultiplier']!;
      _bonusDaysController.text = savedData['bonusDays']!;
      _bonusValueController.text = savedData['bonusValue']!;
      _absentDaysController.text = savedData['absentDays']!;
      _deductionAbsentController.text = savedData['deductAbsent']!;
      _deductionCustomController.text = savedData['deductCustom']!;
      _rewardValueController.text = savedData['rewardValue']!;
      _rewardMultiplierController.text = savedData['rewardMultiplier']!;

      _calculateSalary();
    });
  }

  Future<void> _saveData() async {
    await SessionService.saveSalaryInputs(
      basic: _basicSalaryController.text,
      divisor: _dailyCountDivisorController.text,
      otDays: _overtimeDaysController.text,
      otMultiplier: _overtimeMultiplierController.text,
      bonusDays: _bonusDaysController.text,
      bonusValue: _bonusValueController.text,
      absentDays: _absentDaysController.text,
      deductAbsent: _deductionAbsentController.text,
      deductCustom: _deductionCustomController.text,
      rewardValue: _rewardValueController.text,
      rewardMultiplier: _rewardMultiplierController.text,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Salary calculations saved successfully!"),
          backgroundColor: Color(0xff004D40),
        ),
      );
    }
  }

  void _calculateSalary() {
    setState(() {
      double basic = double.tryParse(_basicSalaryController.text) ?? 0.0;

      double divisor =
          double.tryParse(_dailyCountDivisorController.text) ?? 30.0;

      _dailyCountResult = divisor == 0 ? 0 : basic / divisor;

      double otDays = double.tryParse(_overtimeDaysController.text) ?? 0.0;

      double otMultiplier =
          double.tryParse(_overtimeMultiplierController.text) ?? 1.0;

      _overtimeMonthResult =
          (otDays * _dailyCountResult) + (otMultiplier * _dailyCountResult);

      double bonusDays = double.tryParse(_bonusDaysController.text) ?? 0.0;

      double bonusValue = double.tryParse(_bonusValueController.text) ?? 20.0;

      _bonusMonthResult = bonusDays * bonusValue;

      double deductAbsent =
          double.tryParse(_deductionAbsentController.text) ?? 0.0;

      double deductCustom =
          double.tryParse(_deductionCustomController.text) ?? 0.0;

      _deductionResult = deductAbsent + (deductCustom * _dailyCountResult);

      _totalSalaryResult =
          basic + _overtimeMonthResult + _bonusMonthResult - _deductionResult;

      double rewardValue = double.tryParse(_rewardValueController.text) ?? 0.0;

      double rewardMultiplier =
          double.tryParse(_rewardMultiplierController.text) ?? 0.0;

      _rewardResult = rewardValue + (basic * rewardMultiplier);

      _totalSalaryWithRewardResult = _totalSalaryResult + _rewardResult;
    });
  }
  Future<void> _loadMonthData(DateTime month) async {
    _selectedMonth = month;

    final totals = await SessionService.loadMonthlyTotals(month);

    _overtimeDaysController.text =
        totals["overtime"]!.toInt().toString();

    _bonusDaysController.text =
        totals["bonus"]!.toInt().toString();

    _absentDaysController.text =
        totals["absent"]!.toInt().toString();

    final yearlyAbsent =
    await SessionService.loadYearlyAbsent(month);

    _annualVacationResult = 30 - yearlyAbsent;

    _calculateSalary();

    setState(() {});
  }

  @override
  void dispose() {
    _basicSalaryController.dispose();
    _dailyCountDivisorController.dispose();
    _overtimeDaysController.dispose();
    _overtimeMultiplierController.dispose();
    _bonusDaysController.dispose();
    _bonusValueController.dispose();
    _absentDaysController.dispose();
    _deductionAbsentController.dispose();
    _deductionCustomController.dispose();
    _rewardValueController.dispose();
    _rewardMultiplierController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SalaryHeader(
              selectedMonth: _selectedMonth,
              onMonthChanged: _loadMonthData,
            ),
            SizedBox(height: 20.h),
            SalaryCard(
              basicSalaryController: _basicSalaryController,
              dailyCountDivisorController: _dailyCountDivisorController,
              overtimeDaysController: _overtimeDaysController,
              overtimeMultiplierController: _overtimeMultiplierController,
              bonusDaysController: _bonusDaysController,
              bonusValueController: _bonusValueController,
              vacationTotal: "30",
              absentDaysController: _absentDaysController,
              dailyCountResult: _dailyCountResult,
              overtimeMonthResult: _overtimeMonthResult,
              bonusMonthResult: _bonusMonthResult,
              annualVacationResult: _annualVacationResult,
              onChanged: _calculateSalary,
            ),

            SizedBox(height: 20.h),

            DeductionRewardCard(
              deductionAbsentController: _deductionAbsentController,
              deductionCustomController: _deductionCustomController,
              rewardValueController: _rewardValueController,
              rewardMultiplierController: _rewardMultiplierController,
              deductionResult: _deductionResult,
              rewardResult: _rewardResult,
              totalSalary: _totalSalaryResult,
              totalSalaryWithReward: _totalSalaryWithRewardResult,
              onChanged: _calculateSalary,
            ),

            SizedBox(height: 30.h),

            SalarySaveButton(onPressed: _saveData),
          ],
        ),
      ),
    );
  }
}
