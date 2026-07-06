import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';

class SalaryDetailsGrid extends StatelessWidget {
  const SalaryDetailsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 1.6,
      children: [
        const _SalaryItemCard(
          title: 'Basic Salary',
          amount: '4,000 LE',
          icon: Icons.account_balance_rounded,
          iconColor: Color(0xFF006064),
        ),
        const _SalaryItemCard(
          title: 'Overtime',
          amount: '420.50 LE',
          icon: Icons.more_time_rounded,
          iconColor: Color(0xFF006064),
        ),
        _SalaryItemCard(
          title: 'Bonuses',
          amount: '600 LE',
          icon: Icons.emoji_events_outlined,
          iconColor: ColorManager.lightBrown,
          badgeText: '+15%',
        ),
        _SalaryItemCard(
          title: 'Deductions',
          amount: '200.00 LE',
          icon: Icons.remove_circle_outline_rounded,
          iconColor: ColorManager.red,
          isDeduction: true,
        ),
      ],
    );
  }
}

class _SalaryItemCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color iconColor;
  final String? badgeText;
  final bool isDeduction;

  const _SalaryItemCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconColor,
    this.badgeText,
    this.isDeduction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: iconColor, size: 30.sp),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ColorManager.greyDark.withOpacity(0.5),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      amount,
                      style: TextStyle(
                        color: isDeduction ? ColorManager.red : const Color(0xFF1A1A1A),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (badgeText != null) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        badgeText!,
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}