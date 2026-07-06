import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';

class LogoApp extends StatelessWidget {
  const LogoApp({
    super.key,
    required this.width,
    required this.height,
    required this.size,
  });
  final double width;
  final double height;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.h,
      decoration: BoxDecoration(
        color: ColorManager.primaryColor,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryColor.withOpacity(0.2),
            blurRadius: 20.r,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(
        Icons.account_balance_wallet_rounded,
        size: size.sp,
        color: Colors.white,
      ),
    );
  }
}
