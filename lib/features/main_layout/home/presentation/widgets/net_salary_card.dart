import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';

class NetSalaryCard extends StatelessWidget {
  const NetSalaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorManager.white,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorManager.white,
            ColorManager.white,
            ColorManager.background.withOpacity(0.03),
          ],
          stops: const [0.0, 0.65, 2.0],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 15,
            spreadRadius: 0,
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
                  '4,820',
                  style: TextStyle(
                    color: ColorManager.primaryColor,
                    fontSize: 34.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '.50 ',
                  style: TextStyle(
                    color: ColorManager.primaryColor.withOpacity(0.7),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'LE',
                  style: TextStyle(
                    color: ColorManager.primaryColor,
                    fontSize: 34.sp,
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
