import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: ColorManager.secondary, width: 2.w),
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: CircleAvatar(
            radius: 28.r,
            backgroundColor: ColorManager.primaryColor,
            child: Icon(Icons.person, color: ColorManager.secondary , size: 25..sp,),
          ),
        ),
        SizedBox(width: 10.w),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back ✨ ",
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorManager.greyDark,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Alex Rivera",
              style: TextStyle(
                fontSize: 18.sp,
                color: ColorManager.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
