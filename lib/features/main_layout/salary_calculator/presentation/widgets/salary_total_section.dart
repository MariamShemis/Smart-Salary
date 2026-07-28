import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/formula_row.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/summary_item.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class SalaryTotalsSection extends StatelessWidget {
  const SalaryTotalsSection({
    super.key,
    required this.totalsStream,
    required this.overtimeMultiplierController,
    required this.bonusValueController,
    required this.overtimeMonthResult,
    required this.bonusMonthResult,
    required this.onChanged,
  });

  final Stream<Map<String, double>>? totalsStream;

  final TextEditingController overtimeMultiplierController;
  final TextEditingController bonusValueController;

  final double overtimeMonthResult;
  final double bonusMonthResult;

  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return StreamBuilder<Map<String, double>>(
      stream: totalsStream,
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return Center(
        //     child: CircularProgressIndicator(color: ColorManager.primaryColor,),
        //   );
        // }

        if (!snapshot.hasData) {
          return const SizedBox(
            height: 50,
          );
        }

        final data = snapshot.data!;

        final overtime = data["overtime"] ?? 0;
        final bonus = data["bonus"] ?? 0;
        final absent = data["absent"] ?? 0;

        return Column(
          children: [
            SummaryItem(
              title: appLocalizations.overtimeDays,
              value: overtime.toString(),
            ),
            SizedBox(height: 16.h),

            FormulaRow(
              label: appLocalizations.overtimeMonth,
              prefixText: "${appLocalizations.oT_Days} +",
              controller: overtimeMultiplierController,
              hint: "0",
              resultValue: overtimeMonthResult,
              onChanged: onChanged,
            ),

            SizedBox(height: 16.h),
            Divider(),
            SizedBox(height: 16.h),

            SummaryItem(
              title: appLocalizations.bonusDays,
              value: bonus.toString(),
            ),
            SizedBox(height: 16.h),

            FormulaRow(
              label: appLocalizations.bonusMonth,
              prefixText: "${appLocalizations.days} ×",
              controller: bonusValueController,
              hint: "20",
              resultValue: bonusMonthResult,
              onChanged: onChanged,
            ),

            SizedBox(height: 16.h),
            Divider(),
            SizedBox(height: 16.h),

            SummaryItem(
              title: appLocalizations.absentDays,
              value: absent.toString(),
            ),
          ],
        );
      },
    );
  }
}