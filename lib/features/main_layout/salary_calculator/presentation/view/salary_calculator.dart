import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/session_service/session_service.dart';
import 'package:smart_salary/features/main_layout/daily_reports/data/cubit/daily_reports_cubit.dart';
import 'package:smart_salary/features/main_layout/home/data/cubit/home_cubit.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/data/cubit/salary_cubit.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/data/cubit/salary_state.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/deduction_reward_card.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/salary_card.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/salary_header.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/salary_save_button.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

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

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {
    _selectedMonth = await SessionService.loadSelectedMonth();

    final savedData = await SessionService.loadSalaryInputs();

    _basicSalaryController.text = savedData['basic']!;
    _dailyCountDivisorController.text = savedData['divisor']!;
    _bonusValueController.text = savedData['bonusValue']!;
    _overtimeMultiplierController.text = savedData['otMultiplier']!;

    await _loadMonthData(_selectedMonth);
  }

  Future<void> _saveData() async {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    await SessionService.saveSalaryInputs(
      basic: _basicSalaryController.text,
      divisor: _dailyCountDivisorController.text,
    );
    await SessionService.saveMonthlySalaryData(
      month: _selectedMonth,
      deductAbsent: _deductionAbsentController.text,
      deductCustom: _deductionCustomController.text,
      rewardValue: _rewardValueController.text,
      rewardMultiplier: _rewardMultiplierController.text,
      overtimeMultiplier: _overtimeMultiplierController.text,
      bonusValue: _bonusValueController.text,
    );
    await context.read<HomeCubit>().loadHome();
    context.read<DailyReportsCubit>().loadDaily(
      DateTime(_selectedMonth.year, _selectedMonth.month, 1),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${appLocalizations.salary_calculations_saved_successfully}!",
          ),
          backgroundColor: Color(0xff004D40),
        ),
      );
    }
  }

  Future<void> _loadMonthData(DateTime month) async {
    _selectedMonth = month;
    final totals = await SessionService.loadMonthlyTotals(month);
    final monthData = await SessionService.loadMonthlySalaryData(month);
    _overtimeDaysController.text = totals["overtime"]!.toInt().toString();
    _bonusDaysController.text = totals["bonus"]!.toInt().toString();
    _absentDaysController.text = totals["absent"]!.toInt().toString();
    _deductionAbsentController.text = monthData["deductAbsent"]!;
    _deductionCustomController.text = monthData["deductCustom"]!;
    _rewardValueController.text = monthData["rewardValue"]!;
    _rewardMultiplierController.text = monthData["rewardMultiplier"]!;
    _overtimeMultiplierController.text =
    monthData["overtimeMultiplier"]!;

    _bonusValueController.text =
    monthData["bonusValue"]!;
    final yearlyAbsent = await SessionService.loadYearlyAbsent(month);
    context.read<SalaryCubit>().loadSalary(month);
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
    return BlocBuilder<SalaryCubit, SalaryState>(
      builder: (context, state) {
        if (state is! SalarySuccess) {
          return Center(
            child: CircularProgressIndicator(color: ColorManager.primaryColor,),
          );
        }
        return SafeArea(
          child: SingleChildScrollView(
            padding: REdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SalaryHeader(
                  selectedMonth: _selectedMonth,
                    onMonthChanged: (month) async {
                      await SessionService.saveSelectedMonth(month);
                      await _saveData();
                      await _loadMonthData(month);
                      await context.read<HomeCubit>().loadHome();
                    }
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
                  dailyCountResult: state.dailyCount,
                  overtimeMonthResult: state.overtimeMonth,
                  bonusMonthResult: state.bonusMonth,
                  annualVacationResult: state.vacation,
                  onChanged: () {
                    context.read<SalaryCubit>().calculateSalary(
                      month: _selectedMonth,
                      basic: double.tryParse(_basicSalaryController.text) ?? 0,
                      divisor: double.tryParse(_dailyCountDivisorController.text) ?? 30,
                      overtimeDays: double.tryParse(_overtimeDaysController.text) ?? 0,
                      overtimeMultiplier:
                      double.tryParse(_overtimeMultiplierController.text) ?? 1,
                      bonusDays: double.tryParse(_bonusDaysController.text) ?? 0,
                      bonusValue: double.tryParse(_bonusValueController.text) ?? 20,
                      deductionAbsent:
                      double.tryParse(_deductionAbsentController.text) ?? 0,
                      deductionCustom:
                      double.tryParse(_deductionCustomController.text) ?? 0,
                      rewardValue:
                      double.tryParse(_rewardValueController.text) ?? 0,
                      rewardMultiplier:
                      double.tryParse(_rewardMultiplierController.text) ?? 0,
                      vacation: state.vacation,
                    );
                  },
                ),

                SizedBox(height: 20.h),

                DeductionRewardCard(
                  deductionAbsentController: _deductionAbsentController,
                  deductionCustomController: _deductionCustomController,
                  rewardValueController: _rewardValueController,
                  rewardMultiplierController: _rewardMultiplierController,
                  deductionResult: state.deduction,
                  rewardResult: state.reward,
                  totalSalary: state.totalSalary,
                  totalSalaryWithReward: state.totalSalaryWithReward,
                  onChanged: () {
                    context.read<SalaryCubit>().calculateSalary(
                      month: _selectedMonth,
                      basic: double.tryParse(_basicSalaryController.text) ?? 0,
                      divisor: double.tryParse(_dailyCountDivisorController.text) ?? 30,
                      overtimeDays: double.tryParse(_overtimeDaysController.text) ?? 0,
                      overtimeMultiplier:
                      double.tryParse(_overtimeMultiplierController.text) ?? 1,
                      bonusDays: double.tryParse(_bonusDaysController.text) ?? 0,
                      bonusValue: double.tryParse(_bonusValueController.text) ?? 20,
                      deductionAbsent:
                      double.tryParse(_deductionAbsentController.text) ?? 0,
                      deductionCustom:
                      double.tryParse(_deductionCustomController.text) ?? 0,
                      rewardValue:
                      double.tryParse(_rewardValueController.text) ?? 0,
                      rewardMultiplier:
                      double.tryParse(_rewardMultiplierController.text) ?? 0,
                      vacation: state.vacation,
                    );
                  },
                ),

                SizedBox(height: 30.h),

                SalarySaveButton(onPressed: _saveData),
              ],
            ),
          ),
        );
      },
    );
  }
}
