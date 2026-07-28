import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/utils/ui_utils.dart';
import 'package:smart_salary/features/firebase/salary_firestore_services.dart';
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
  Stream<Map<String, double>>? _totalsStream;
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
    final uid = FirebaseAuth.instance.currentUser!.uid;

    _selectedMonth = await SalaryFirestoreServices.loadSelectedMonth(uid);

    final salary = await SalaryFirestoreServices.loadSalaryInputs(
      uid: uid,
      month: _selectedMonth,
    );

    _basicSalaryController.text = salary["basic"].toString();

    _dailyCountDivisorController.text = salary["divisor"].toString();

    await _loadMonthData(_selectedMonth);
  }

  Future<void> _saveData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    UiUtils.showLoading(context);
    try {
      await SalaryFirestoreServices.saveSalaryHistory(
        uid: uid,
        month: _selectedMonth,
        basic: _basicSalaryController.text,
        divisor: _dailyCountDivisorController.text,
      );
      await SalaryFirestoreServices.saveMonthlySalaryData(
        uid: uid,
        month: _selectedMonth,
        deductAbsent: _deductionAbsentController.text,
        deductCustom: _deductionCustomController.text,
        rewardValue: _rewardValueController.text,
        rewardMultiplier: _rewardMultiplierController.text,
        overtimeMultiplier: _overtimeMultiplierController.text,
        bonusValue: _bonusValueController.text,
      );
      await context.read<SalaryCubit>().loadSalary(_selectedMonth);
      await context.read<HomeCubit>().loadHome();
      context.read<DailyReportsCubit>().loadDaily(
        DateTime(_selectedMonth.year, _selectedMonth.month, 1),
      );
      if (!mounted) return;
      UiUtils.hideLoading(context);
      UiUtils.showToast(
        appLocalizations.salary_calculations_saved_successfully,
      );
    } catch (e) {
      if (!mounted) return;
      UiUtils.hideLoading(context);
      UiUtils.showToast("Something went wrong", backgroundColor: Colors.red);
    }
  }

  Future<void> _loadMonthData(DateTime month) async {
    _selectedMonth = month;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    setState(() {
      _totalsStream = SalaryFirestoreServices.monthlyTotalsStream(
        uid: uid,
        month: month,
      );
    });

    final results = await Future.wait([
      SalaryFirestoreServices.loadMonthlyTotals(uid: uid, month: month),
      SalaryFirestoreServices.loadSalaryInputs(uid: uid, month: month),
      SalaryFirestoreServices.loadMonthlySalaryData(uid: uid, month: month),
    ]);

    final totals = results[0] as Map<String, double>;
    final salary = results[1];
    final monthData = results[2];

    setState(() {
      _basicSalaryController.text = salary["basic"].toString();

      _dailyCountDivisorController.text = salary["divisor"].toString();

      _overtimeDaysController.text = (totals["overtime"] ?? 0).toString();

      _bonusDaysController.text = (totals["bonus"] ?? 0).toString();

      _absentDaysController.text = (totals["absent"] ?? 0).toString();

      _deductionAbsentController.text = monthData["deductAbsent"] ?? "";

      _deductionCustomController.text = monthData["deductCustom"] ?? "";

      _rewardValueController.text = monthData["rewardValue"] ?? "";

      _rewardMultiplierController.text = monthData["rewardMultiplier"] ?? "";

      _overtimeMultiplierController.text =
          monthData["overtimeMultiplier"] ?? "";

      _bonusValueController.text = monthData["bonusValue"]?.toString() ?? "20";
    });

    context.read<SalaryCubit>().loadSalary(month);
  }

  // Future<void> _saveWithoutMessage() async {
  //   final uid = FirebaseAuth.instance.currentUser!.uid;
  //
  //   await SalaryFirestoreServices.saveSalaryHistory(
  //     uid: uid,
  //     basic: _basicSalaryController.text,
  //     divisor: _dailyCountDivisorController.text,
  //     month: _selectedMonth,
  //   );
  //
  //   await SalaryFirestoreServices.saveMonthlySalaryData(
  //     uid: uid,
  //     month: _selectedMonth,
  //     deductAbsent: _deductionAbsentController.text,
  //     deductCustom: _deductionCustomController.text,
  //     rewardValue: _rewardValueController.text,
  //     rewardMultiplier: _rewardMultiplierController.text,
  //     overtimeMultiplier: _overtimeMultiplierController.text,
  //     bonusValue: _bonusValueController.text,
  //   );
  // }

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
            child: CircularProgressIndicator(color: ColorManager.primaryColor),
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
                    UiUtils.showLoading(context);

                    try {
                      await SalaryFirestoreServices.saveSelectedMonth(
                        uid: FirebaseAuth.instance.currentUser!.uid,
                        month: month,
                      );
                      await _loadMonthData(month);
                      await context.read<HomeCubit>().loadHome();
                      if (mounted) {
                        UiUtils.hideLoading(context);
                      }
                    } catch (e) {
                      if (mounted) {
                        UiUtils.hideLoading(context);
                        UiUtils.showToast(
                          "Something went wrong",
                          backgroundColor: Colors.red,
                        );
                      }
                    }
                  },
                ),
                SizedBox(height: 20.h),
                SalaryCard(
                  totalsStream: _totalsStream,
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
                      divisor:
                          double.tryParse(_dailyCountDivisorController.text) ??
                          30,
                      overtimeDays:
                          double.tryParse(_overtimeDaysController.text) ?? 0,
                      overtimeMultiplier:
                          double.tryParse(_overtimeMultiplierController.text) ??
                          1,
                      bonusDays:
                          double.tryParse(_bonusDaysController.text) ?? 0,
                      bonusValue:
                          double.tryParse(_bonusValueController.text) ?? 20,
                      deductionAbsent:
                          double.tryParse(_deductionAbsentController.text) ?? 0,
                      deductionCustom:
                          double.tryParse(_deductionCustomController.text) ?? 0,
                      rewardValue:
                          double.tryParse(_rewardValueController.text) ?? 0,
                      rewardMultiplier:
                          double.tryParse(_rewardMultiplierController.text) ??
                          0,
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
                      divisor:
                          double.tryParse(_dailyCountDivisorController.text) ??
                          30,
                      overtimeDays:
                          double.tryParse(_overtimeDaysController.text) ?? 0,
                      overtimeMultiplier:
                          double.tryParse(_overtimeMultiplierController.text) ??
                          1,
                      bonusDays:
                          double.tryParse(_bonusDaysController.text) ?? 0,
                      bonusValue:
                          double.tryParse(_bonusValueController.text) ?? 20,
                      deductionAbsent:
                          double.tryParse(_deductionAbsentController.text) ?? 0,
                      deductionCustom:
                          double.tryParse(_deductionCustomController.text) ?? 0,
                      rewardValue:
                          double.tryParse(_rewardValueController.text) ?? 0,
                      rewardMultiplier:
                          double.tryParse(_rewardMultiplierController.text) ??
                          0,
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
