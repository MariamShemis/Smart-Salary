import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/session_service/session_service.dart';
import 'package:smart_salary/features/main_layout/daily_reports/presentation/widgets/add_daily_input.dart';
import 'package:smart_salary/features/main_layout/daily_reports/presentation/widgets/attendance_card.dart';

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
    _loadDailyReport();
  }

  Future<void> _loadDailyReport() async {
    final data = await SessionService.loadDailyInput(_selectedDay);

    _overtimeController.text = data["overtime"]!;
    _bonusController.text = data["bonus"]!;
    _absentController.text = data["absent"]!;
    _reportController.text = data["report"]!;
  }

  Future<void> _saveDailyReport() async {
    await SessionService.saveDailyInput(
      date: _selectedDay,
      overtime: _overtimeController.text,
      bonus: _bonusController.text,
      absent: _absentController.text,
      report: _reportController.text,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Saved Successfully"),
        backgroundColor: Color(0xff004D40),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AttendanceCard(
                selectedDay: _selectedDay,
                onDayChanged: (newDay) async {
                  setState(() {
                    _selectedDay = newDay;
                  });

                  await _loadDailyReport();
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
  }
}