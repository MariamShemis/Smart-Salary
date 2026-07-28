import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({super.key, required this.name, required this.image});

  final String name;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final dayName = DateFormat('EEEE').format(now);
    final fullDate = DateFormat('dd MMM yyyy').format(now);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: ColorManager.secondary, width: 2.w),
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: image,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${appLocalizations.welcome_back} ✨",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorManager.greyDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: ColorManager.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              dayName,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: ColorManager.greyDark,
              ),
            ),
            Text(
              fullDate,
              style: TextStyle(
                fontSize: 16.sp,
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
