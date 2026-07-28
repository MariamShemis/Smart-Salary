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
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isTitle && title != null) ...[
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              title!,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: ColorManager.black
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 25.w),
        ],
        Container(
          constraints: BoxConstraints(minWidth: 40.w),
          height: 38.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.black12),
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
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