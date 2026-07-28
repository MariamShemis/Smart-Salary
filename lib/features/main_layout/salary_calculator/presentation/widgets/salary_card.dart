import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/features/firebase/salary_firestore_services.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/formula_row.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/row_text_field.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/salary_total_section.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/summary_item.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class SalaryCard extends StatelessWidget {
  const SalaryCard({
    super.key,
    required this.basicSalaryController,
    required this.dailyCountDivisorController,
    required this.overtimeDaysController,
    required this.overtimeMultiplierController,
    required this.bonusDaysController,
    required this.bonusValueController,
    required this.vacationTotal,
    required this.absentDaysController,
    required this.dailyCountResult,
    required this.overtimeMonthResult,
    required this.bonusMonthResult,
    required this.annualVacationResult,
    required this.onChanged,
    required this.totalsStream,
  });

  final TextEditingController basicSalaryController;
  final Stream<Map<String, double>>? totalsStream;
  final TextEditingController dailyCountDivisorController;
  final TextEditingController overtimeDaysController;
  final TextEditingController overtimeMultiplierController;
  final TextEditingController bonusDaysController;
  final TextEditingController bonusValueController;
  final TextEditingController absentDaysController;

  final String vacationTotal;

  final double dailyCountResult;
  final double overtimeMonthResult;
  final double bonusMonthResult;
  final double annualVacationResult;

  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 18.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        children: [
          RowTextField(
            label: appLocalizations.basicSalary,
            hint: appLocalizations.enter_basic_salary,
            controller: basicSalaryController,
            onChanged: onChanged,
          ),
          SizedBox(height: 16.h),
          Divider(thickness: 1, height: 1.h),
          SizedBox(height: 16.h),
          FormulaRow(
            label: appLocalizations.dailyCount,
            prefixText: "${appLocalizations.basic} /",
            controller: dailyCountDivisorController,
            hint: "30",
            resultValue: dailyCountResult,
            onChanged: onChanged,
          ),
          SizedBox(height: 16.h),
          SalaryTotalsSection(
            totalsStream: totalsStream,
            overtimeMultiplierController: overtimeMultiplierController,
            bonusValueController: bonusValueController,
            overtimeMonthResult: overtimeMonthResult,
            bonusMonthResult: bonusMonthResult,
            onChanged: onChanged,
          ),
          // StreamBuilder<Map<String, double>>(
          //   stream: totalsStream,
          //   builder: (context, snapshot) {
          //     final overtime = snapshot.data?["overtime"] ?? 0;
          //
          //     return SummaryItem(
          //       title: appLocalizations.overtimeDays,
          //       value: overtime.toString(),
          //     );
          //   },
          // ),
          // SizedBox(height: 16.h),
          // FormulaRow(
          //   label: appLocalizations.overtimeMonth,
          //   prefixText: "${appLocalizations.oT_Days} +",
          //   controller: overtimeMultiplierController,
          //   hint: "0",
          //   resultValue: overtimeMonthResult,
          //   onChanged: onChanged,
          // ),
          // SizedBox(height: 16.h),
          // Divider(thickness: 1, height: 1.h),
          // SizedBox(height: 16.h),
          // StreamBuilder<Map<String, double>>(
          //   stream: totalsStream,
          //   builder: (context, snapshot) {
          //     final bonus = snapshot.data?["bonus"] ?? 0;
          //
          //     return SummaryItem(
          //       title: appLocalizations.bonusDays,
          //       value: bonus.toString(),
          //     );
          //   },
          // ),
          // SizedBox(height: 16.h),
          // FormulaRow(
          //   label: appLocalizations.bonusMonth,
          //   prefixText: "${appLocalizations.days} ×",
          //   controller: bonusValueController,
          //   hint: "20",
          //   resultValue: bonusMonthResult,
          //   onChanged: onChanged,
          // ),
          // SizedBox(height: 16.h),
          // Divider(thickness: 1, height: 1.h),
          // SizedBox(height: 16.h),
          // StreamBuilder<Map<String, double>>(
          //   stream: totalsStream,
          //   builder: (context, snapshot) {
          //     final absent = snapshot.data?["absent"] ?? 0;
          //
          //     return SummaryItem(
          //       title: appLocalizations.absentDays,
          //       value: absent.toString(),
          //     );
          //   },
          // ),
          SizedBox(height: 16.h),
          FormulaRow(
            label: appLocalizations.vacation,
            prefixText: appLocalizations.total,
            fixedValue: vacationTotal,
            suffixText: "- ${appLocalizations.absent}",
            hint: "",
            resultValue: annualVacationResult,
            onChanged: onChanged,
            isVacation: true,
          ),
        ],
      ),
    );
  }
}
