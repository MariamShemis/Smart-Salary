import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/utils/ui_utils.dart';
import 'package:smart_salary/features/firebase/salary_firestore_services.dart';
import 'package:smart_salary/features/main_layout/daily_reports/data/cubit/daily_reports_cubit.dart';
import 'package:smart_salary/features/main_layout/daily_reports/data/cubit/daily_reports_state.dart';
import 'package:smart_salary/features/main_layout/daily_reports/presentation/widgets/add_daily_input.dart';
import 'package:smart_salary/features/main_layout/daily_reports/presentation/widgets/attendance_card.dart';
import 'package:smart_salary/features/main_layout/home/data/cubit/home_cubit.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class DailyReports extends StatefulWidget {
  const DailyReports({super.key});

  @override
  State<DailyReports> createState() => _DailyReportsState();
}

class _DailyReportsState extends State<DailyReports> {
  DateTime _selectedDay = DateTime.now();
  final TextEditingController _overtimeController = TextEditingController();
  final TextEditingController _bonusController = TextEditingController();
  final TextEditingController _absentController = TextEditingController();
  final TextEditingController _reportController = TextEditingController();
  int refresh = 0;

  @override
  void dispose() {
    _overtimeController.dispose();
    _bonusController.dispose();
    _absentController.dispose();
    _reportController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final selectedMonth = await SalaryFirestoreServices.loadSelectedMonth(
      FirebaseAuth.instance.currentUser!.uid,
    );
    _selectedDay = DateTime(
      selectedMonth.year,
      selectedMonth.month,
      DateTime.now().day,
    );
    final lastDay = DateTime(
      selectedMonth.year,
      selectedMonth.month + 1,
      0,
    ).day;
    if (_selectedDay.day > lastDay) {
      _selectedDay = DateTime(selectedMonth.year, selectedMonth.month, lastDay);
    }
    context.read<DailyReportsCubit>().loadDaily(_selectedDay);
    setState(() {
      refresh++;
    });
  }

  Future<void> _saveDailyReport() async {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    UiUtils.showLoading(context);

    try {
      await context.read<DailyReportsCubit>().saveDaily(
        day: _selectedDay,
        overtime: _overtimeController.text,
        bonus: _bonusController.text,
        absent: _absentController.text,
        report: _reportController.text,
      );
      await context.read<HomeCubit>().loadHome();
      if (mounted) {
        UiUtils.hideLoading(context);
        UiUtils.showToast(appLocalizations.saved_Successfully);
      }
      setState(() {
        refresh++;
      });
    } catch (e) {
      if (mounted) {
        UiUtils.hideLoading(context);
        UiUtils.showToast("Something went wrong", backgroundColor: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyReportsCubit, DailyReportsState>(
      listener: (context, state) {
        if (state is DailyReportsLoaded) {
          _overtimeController.text = state.overtime;
          _bonusController.text = state.bonus;
          _absentController.text = state.absent;
          _reportController.text = state.report;
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AttendanceCard(
                    selectedDay: _selectedDay,
                    refresh: refresh,
                    onDayChanged: (newDay) async {
                      setState(() {
                        _selectedDay = newDay;
                      });
                      context.read<DailyReportsCubit>().loadDaily(newDay);
                    },
                  ),
                  SizedBox(height: 20.h),
                  AddDailyInput(
                    selectedDay: _selectedDay,
                    overtimeController: _overtimeController,
                    bonusController: _bonusController,
                    absentController: _absentController,
                    reportController: _reportController,
                    onSave: _saveDailyReport,
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
