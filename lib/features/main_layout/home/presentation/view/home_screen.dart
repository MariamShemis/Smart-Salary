import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/features/main_layout/home/presentation/widgets/home_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: REdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeTitle(),
              SizedBox(height: 3.h),
              Divider(
                color: ColorManager.greyDark.withOpacity(0.2),
                thickness: 1.5,
                indent: 4,
                endIndent: 4,
              ),
              SizedBox(height: 16.h),
              const _BuildNetSalaryCard(),
              SizedBox(height: 20.h),
              const _BuildSalaryDetailsGrid(),
              SizedBox(height: 20.h),
              const _BuildVacationBalanceCard(),
              SizedBox(height: 24.h),
              Text(
                'QUICK ACTIONS',
                style: TextStyle(
                  color: ColorManager.greyDark.withOpacity(0.6),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: 12.h),
              const _BuildQuickActionsRow(),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

/// 1. ويدجت كارت صافي الراتب الحالي (Net Salary)
class _BuildNetSalaryCard extends StatelessWidget {
  const _BuildNetSalaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'CURRENT MONTH',
                  style: TextStyle(
                    color: ColorManager.primaryColor.withOpacity(0.8),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Icon(
                Icons.account_balance_wallet_outlined,
                color: ColorManager.greyDark.withOpacity(0.5),
                size: 20.sp,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'NET SALARY',
            style: TextStyle(
              color: ColorManager.greyDark.withOpacity(0.6),
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '\$4,820',
                  style: TextStyle(
                    color: ColorManager.primaryColor,
                    fontSize: 34.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '.50',
                  style: TextStyle(
                    color: ColorManager.primaryColor.withOpacity(0.7),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(
                Icons.trending_up_rounded,
                color: ColorManager.primaryColor,
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                '4.2% ',
                style: TextStyle(
                  color: ColorManager.primaryColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'from last month',
                style: TextStyle(
                  color: ColorManager.greyDark.withOpacity(0.6),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 2. ويدجت شبكة تفاصيل الراتب (Grid Items)
class _BuildSalaryDetailsGrid extends StatelessWidget {
  const _BuildSalaryDetailsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 1.35,
      children: [
        const _SalaryItemCard(
          title: 'Basic Salary',
          amount: '\$4,000',
          icon: Icons.account_balance_rounded,
          iconColor: Color(0xFF006064),
        ),
        const _SalaryItemCard(
          title: 'Overtime',
          amount: '\$420.50',
          icon: Icons.more_time_rounded,
          iconColor: Color(0xFF006064),
        ),
        const _SalaryItemCard(
          title: 'Bonuses',
          amount: '\$600',
          icon: Icons.emoji_events_outlined,
          iconColor: Colors.orange,
          badgeText: '+15%',
        ),
        const _SalaryItemCard(
          title: 'Deductions',
          amount: '\$200.00',
          icon: Icons.remove_circle_outline_rounded,
          iconColor: Colors.redAccent,
          isDeduction: true,
        ),
      ],
    );
  }
}

/// الكارت الموحد القابل لإعادة الاستخدام داخل الشبكة
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
          Icon(icon, color: iconColor, size: 22.sp),
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
                        color: isDeduction ? Colors.redAccent : const Color(0xFF1A1A1A),
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

/// 3. ويدجت كارت رصيد الإجازات (Vacation Balance Card)
class _BuildVacationBalanceCard extends StatelessWidget {
  const _BuildVacationBalanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // النصوص والزر جهة اليسار
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vacation Balance',
                style: TextStyle(
                  color: const Color(0xFF1A1A1A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '14 days remaining from 25',
                style: TextStyle(
                  color: ColorManager.greyDark.withOpacity(0.6),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16.h),
              // زر طلب الإجازة التفاعلي
              InkWell(
                onTap: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Request Leave ',
                      style: TextStyle(
                        color: ColorManager.primaryColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorManager.primaryColor,
                      size: 12.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // المؤشر الدائري جهة اليمين ومكتوب بداخله الرقم
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 65.w,
                height: 65.w,
                child: CircularProgressIndicator(
                  value: 14 / 25, // النسبة المحسوبة للأيام المتبقية
                  strokeWidth: 7.w,
                  backgroundColor: const Color(0xFFE0E0E0).withOpacity(0.5),
                  valueColor: AlwaysStoppedAnimation<Color>(ColorManager.primaryColor),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '14',
                    style: TextStyle(
                      color: ColorManager.primaryColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    'DAYS',
                    style: TextStyle(
                      color: ColorManager.greyDark.withOpacity(0.7),
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 5. ويدجت صف الأزرار السريعة (Quick Actions Row)
class _BuildQuickActionsRow extends StatelessWidget {
  const _BuildQuickActionsRow();

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

/// ويدجت الكارت الموحد للـ Quick Action
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