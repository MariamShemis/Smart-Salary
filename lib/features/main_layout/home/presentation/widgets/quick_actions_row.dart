import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // الزر الأول الأخضر المميز الداكن
        Expanded(
          child: _QuickActionItem(
            label: 'Add Overtime',
            icon: Icons.add_alarm_rounded,
            backgroundColor: ColorManager.primaryColor,
            contentColor: ColorManager.white,
          ),
        ),
        SizedBox(width: 10.w),
        // الزر الثاني الرمادي الفاتح
        Expanded(
          child: _QuickActionItem(
            label: 'Log Status',
            icon: Icons.calendar_today_outlined,
            backgroundColor: const Color(0xFFEAEAEA).withOpacity(0.6),
            contentColor: const Color(0xFF2D3748),
          ),
        ),
        SizedBox(width: 10.w),
        // الزر الثالث الرمادي الفاتح
        Expanded(
          child: _QuickActionItem(
            label: 'Payslips',
            icon: Icons.receipt_long_outlined,
            backgroundColor: const Color(0xFFEAEAEA).withOpacity(0.6),
            contentColor: const Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color contentColor;

  const _QuickActionItem({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: contentColor, size: 22.sp),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              color: contentColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}