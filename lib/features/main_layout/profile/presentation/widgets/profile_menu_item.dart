import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;
  final bool showDivider;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: REdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: REdgeInsets.all(7),
                  decoration : BoxDecoration(
                    color: ColorManager.primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    color: ColorManager.white,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ColorManager.greyDark,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (trailingText != null) ...[
                  Text(
                    trailingText!,
                    style: TextStyle(
                      color: ColorManager.primaryColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4.w),
                ],
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: ColorManager.greyDark.withOpacity(0.4),
                  size: 17.sp,
                ),
              ],
            ),
          ),
          if (showDivider)
            Divider(
              height: 1,
              thickness: 1,
              color: ColorManager.greyDark.withOpacity(0.08),
              indent: 16.w,
              endIndent: 16.w,
            ),
        ],
      ),
    );
  }
}