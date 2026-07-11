import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.job,
    required this.phoneNumber,
    required this.image,
  });

  final String name;
  final String job;
  final String phoneNumber;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: REdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorManager.primaryColor.withOpacity(0.3),
                    width: 3,
                  ),
                ),
                child: image,
              ),
              Positioned(
                right: -1,
                bottom: 1,
                child: CircleAvatar(
                  radius: 15.r,
                  backgroundColor: ColorManager.primaryColor,
                  child: Icon(
                    Icons.camera_alt,
                    color: ColorManager.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            name,
            style: TextStyle(
              color: ColorManager.greyDark,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            job,
            style: TextStyle(
              color: ColorManager.greyDark.withOpacity(0.6),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone, color: ColorManager.primaryColor, size: 16.sp),
              SizedBox(width: 5.w),
              Text(
                phoneNumber,
                style: TextStyle(
                  color: ColorManager.primaryColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
