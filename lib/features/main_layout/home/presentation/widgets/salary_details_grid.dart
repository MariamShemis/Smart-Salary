import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class SalaryDetailsGrid extends StatelessWidget {
  const SalaryDetailsGrid({
    super.key,
    required this.basicSalary,
    required this.overtimeDays,
    required this.overtimeMonth,
    required this.bonusDays,
    required this.bonusMonth,
    required this.deduction,
    required this.annualOvertime,
    required this.annualBonus,
  });

  final double basicSalary;
  final double overtimeDays;
  final double overtimeMonth;
  final double bonusDays;
  final double bonusMonth;
  final double deduction;
  final double annualOvertime;
  final double annualBonus;

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);
    final double cardAspectRatio = size.height < 650 ? 1.15 : 1.3;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: cardAspectRatio,
      children: [
        _SalaryItemCard(
          title: appLocalizations.basicSalary,
          amount: "${basicSalary.toStringAsFixed(2)} ${appLocalizations.lE}",
          icon: Icons.account_balance_rounded,
          iconColor: const Color(0xFF006064),
        ),
        _SalaryItemCard(
          title: appLocalizations.overtime,
          amount: "${overtimeMonth.toStringAsFixed(2)} ${appLocalizations.lE}",
          isDays: true,
          amountDays: "${overtimeDays.toDouble()} ${appLocalizations.days}",
          icon: Icons.more_time_rounded,
          iconColor: const Color(0xFF006064),
        ),
        _SalaryItemCard(
          title: appLocalizations.bonus,
          amount: "${bonusMonth.toStringAsFixed(2)} ${appLocalizations.lE}",
          isDays: true,
          amountDays: "${bonusDays.toDouble()} ${appLocalizations.unit}",
          icon: Icons.emoji_events_outlined,
          iconColor: ColorManager.lightBrown,
        ),
        _SalaryItemCard(
          title: appLocalizations.annualOvertime,
          amount: "${annualOvertime.toStringAsFixed(2)} ${appLocalizations.lE}",
          icon: Icons.schedule,
          iconColor: const Color(0xFFF59E0B),
        ),

        _SalaryItemCard(
          title: appLocalizations.annualBonus,
          amount: "${annualBonus.toStringAsFixed(2)} ${appLocalizations.lE}",
          icon: Icons.workspace_premium_outlined,
          iconColor: Colors.amber,
        ),
        _SalaryItemCard(
          title: appLocalizations.deductions,
          amount: "${deduction.toStringAsFixed(2)} ${appLocalizations.lE}",
          icon: Icons.remove_circle_outline_rounded,
          iconColor: ColorManager.red,
          isDeduction: true,
        ),
      ],
    );
  }
}

class _SalaryItemCard extends StatelessWidget {
  const _SalaryItemCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconColor,
    this.isDeduction = false,
    this.isDays = false,
    this.amountDays,
  });

  final String title;
  final String amount;
  final IconData icon;
  final Color iconColor;
  final bool isDeduction;
  final bool isDays;
  final String? amountDays;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: iconColor, size: 26.sp),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.greyDark.withOpacity(.7),
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),
          isDays
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          amount,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: isDeduction
                                ? ColorManager.red
                                : const Color(0xff1A1A1A),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      amountDays ?? "",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.greyText,
                      ),
                    ),
                  ],
                )
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    amount,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isDeduction
                          ? ColorManager.red
                          : const Color(0xff1A1A1A),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
