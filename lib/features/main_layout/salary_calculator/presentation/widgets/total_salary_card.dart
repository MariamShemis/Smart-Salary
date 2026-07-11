import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TotalSalaryCard extends StatelessWidget {
  const TotalSalaryCard({
    super.key,
    required this.title,
    required this.formula,
    required this.value,
  });

  final String title;
  final String formula;
  final double value;

  static const primaryColor = Color(0xff004D40);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 110.w,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: REdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: primaryColor,
                width: 1.2.w,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$formula =",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  value.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}