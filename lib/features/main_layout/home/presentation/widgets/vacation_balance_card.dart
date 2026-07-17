import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class VacationBalanceCard extends StatelessWidget {
  const VacationBalanceCard({
    super.key,
    required this.remainingDays,
  });

  final double remainingDays;

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    const double totalDays = 30;
    final progress = (remainingDays / totalDays).clamp(0.0, 1.0);
    return Container(
      width: double.infinity,
      padding: REdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Text(
                appLocalizations.vacationBalance,
                style: TextStyle(
                  color: const Color(0xFF1A1A1A),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "${remainingDays.toDouble()} ${appLocalizations.days_remaining_from} $totalDays",
                style: TextStyle(
                  color: ColorManager.greyDark.withOpacity(.6),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),

          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 65.w,
                height: 65.w,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 7.w,
                  backgroundColor:
                  const Color(0xFFE0E0E0).withOpacity(.5),
                  valueColor: AlwaysStoppedAnimation(
                    ColorManager.primaryColor,
                  ),
                ),
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    remainingDays.toDouble().toString(),
                    style: TextStyle(
                      color: ColorManager.primaryColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    appLocalizations.days.toUpperCase(),
                    style: TextStyle(
                      color: ColorManager.greyDark.withOpacity(.7),
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