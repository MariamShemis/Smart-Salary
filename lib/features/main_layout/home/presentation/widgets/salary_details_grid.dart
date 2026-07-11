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
  });

  final double basicSalary;
  final double overtimeDays;
  final double overtimeMonth;
  final double bonusDays;
  final double bonusMonth;
  final double deduction;

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final height = MediaQuery.sizeOf(context).height;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      mainAxisExtent: height * .14,
      children: [
        _SalaryItemCard(
          title: appLocalizations.basicSalary,
          amount: "${basicSalary.toStringAsFixed(2)} ${appLocalizations.lE}",
          icon: Icons.account_balance_rounded,
          iconColor: const Color(0xFF006064),
        ),

        _SalaryItemCard(
          title: appLocalizations.overtime,
          amount:
          "${overtimeMonth.toStringAsFixed(2)} ${appLocalizations.lE}",
          isDays: true,
          amountDays: "${overtimeDays.toInt()} ${appLocalizations.days}",
          icon: Icons.more_time_rounded,
          iconColor: const Color(0xFF006064),
        ),

        _SalaryItemCard(
          title: appLocalizations.bonus,
          amount:
          "${bonusMonth.toStringAsFixed(2)} ${appLocalizations.lE}",
          isDays: true,
          amountDays: "${bonusDays.toInt()} ${appLocalizations.unit}",
          icon: Icons.emoji_events_outlined,
          iconColor: ColorManager.lightBrown,
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
    this.isDays = false, this.amountDays
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
      padding: REdgeInsets.all(14),
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
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 30.sp,
          ),

          const Spacer(),

          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: ColorManager.greyDark.withOpacity(.6),
            ),
          ),

          SizedBox(height: 4.h),

          isDays? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color:
                  isDeduction ? ColorManager.red : const Color(0xff1A1A1A),
                ),
              ),
              Text(
                amountDays ?? "",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color:
                  ColorManager.greyText
                ),
              ),
            ],
          ) :Text(
            amount,
            style: TextStyle(
              fontSize: 15.sp,
              height: 1.3,
              fontWeight: FontWeight.bold,
              color:
              isDeduction ? ColorManager.red : const Color(0xff1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}