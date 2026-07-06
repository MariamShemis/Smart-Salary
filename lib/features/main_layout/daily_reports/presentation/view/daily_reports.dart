import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/features/main_layout/daily_reports/presentation/widgets/add_daily_input.dart';
import 'package:smart_salary/features/main_layout/daily_reports/presentation/widgets/attendance_card.dart';

class DailyReports extends StatefulWidget {
  const DailyReports({super.key});

  @override
  State<DailyReports> createState() => _DailyReportsState();
}

class _DailyReportsState extends State<DailyReports> {
  DateTime _selectedDay = DateTime.now();

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
                onDayChanged: (newDay) {
                  setState(() {
                    _selectedDay = newDay;
                  });
                },
              ),
              SizedBox(height: 20.h),
              AddDailyInput(selectedDay: _selectedDay),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}