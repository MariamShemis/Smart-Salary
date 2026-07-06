import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';

class VacationBalanceCard extends StatelessWidget {
  const VacationBalanceCard({super.key});

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
