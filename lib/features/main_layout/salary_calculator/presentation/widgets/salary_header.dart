import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class SalaryHeader extends StatelessWidget {
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onMonthChanged;

  const SalaryHeader({
    super.key,
    required this.selectedMonth,
    required this.onMonthChanged,
  });

  Future<void> _pickMonthYear(BuildContext context) async {
    final date = await showMonthYearPicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(0.93),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ColorManager.primaryColor,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black87,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: ColorManager.primaryColor,
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (date != null) {
      onMonthChanged(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appLocalizations.salaryCalculator,
          style: TextStyle(
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
            color: ColorManager.primaryColor,
          ),
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: () => _pickMonthYear(context),
          child: Container(
            padding: REdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_month,
                  color: ColorManager.primaryColor,
                ),
                SizedBox(width: 8.w),
                Text(
                  DateFormat("MMM yyyy").format(selectedMonth),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.primaryColor,
                  ),
                ),
                SizedBox(width: 6.w),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: ColorManager.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}