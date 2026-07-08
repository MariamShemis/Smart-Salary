import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';

class SummaryItem extends StatelessWidget {
  final String? title;
  final String value;
  final bool isTitle;

  const SummaryItem({
    super.key,
    this.title,
    required this.value,
    this.isTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ?isTitle
            ? Text(
                title ?? "",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
        SizedBox(width: isTitle ? 20.w : 0.w),
        Container(
          width: isTitle ?65.w : 30.w,
          height: 38.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.black12),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: ColorManager.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
