import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/mini_text_field.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/result_box.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/total_salary_card.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class DeductionRewardCard extends StatelessWidget {
  const DeductionRewardCard({
    super.key,
    required this.deductionAbsentController,
    required this.deductionCustomController,
    required this.rewardValueController,
    required this.rewardMultiplierController,
    required this.deductionResult,
    required this.rewardResult,
    required this.totalSalary,
    required this.totalSalaryWithReward,
    required this.onChanged,
  });

  final TextEditingController deductionAbsentController;
  final TextEditingController deductionCustomController;
  final TextEditingController rewardValueController;
  final TextEditingController rewardMultiplierController;

  final double deductionResult;
  final double rewardResult;
  final double totalSalary;
  final double totalSalaryWithReward;

  final VoidCallback onChanged;

  static const primaryColor = Color(0xff004D40);

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 16.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appLocalizations.deductions_Rewards,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 22.h),
          Text(
            appLocalizations.deductionFormula,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: ColorManager.greyDark,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 10.h,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 75.w,
                child: MiniTextField(
                  controller: deductionAbsentController,
                  hint: appLocalizations.count,
                  onChanged: onChanged,
                ),
              ),
              Text("+", style: TextStyle(fontSize: 18.sp)),
              SizedBox(
                width: 75.w,
                child: MiniTextField(
                  controller: deductionCustomController,
                  hint: appLocalizations.days,
                  onChanged: onChanged,
                ),
              ),
              Text("=", style: TextStyle(fontSize: 18.sp)),

              ResultBox(value: deductionResult),
            ],
          ),
          SizedBox(height: 28.h),
          Text(
            appLocalizations.rewardFormula,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: ColorManager.greyDark,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 10.h,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 75.w,
                child: MiniTextField(
                  controller: rewardValueController,
                  hint: appLocalizations.value,
                  onChanged: onChanged,
                ),
              ),
              Text("+", style: TextStyle(fontSize: 18.sp)),
              SizedBox(
                width: 75.w,
                child: MiniTextField(
                  controller: rewardMultiplierController,
                  hint: appLocalizations.amount,
                  onChanged: onChanged,
                ),
              ),
              Text("=", style: TextStyle(fontSize: 18.sp)),
              ResultBox(value: rewardResult),
            ],
          ),

          SizedBox(height: 30.h),
          TotalSalaryCard(
            title: appLocalizations.totalSalary,
            formula: "${appLocalizations.basic} + ${appLocalizations.oT} + ${appLocalizations.bonus} - ${appLocalizations.deductions}",
            value: totalSalary,
          ),
          SizedBox(height: 18.h),
          TotalSalaryCard(
            title: appLocalizations.total_Salary_with_Reward,
            formula: "${appLocalizations.totalSalary} + ${appLocalizations.reward}",
            value: totalSalaryWithReward,
          ),
        ],
      ),
    );
  }
}
