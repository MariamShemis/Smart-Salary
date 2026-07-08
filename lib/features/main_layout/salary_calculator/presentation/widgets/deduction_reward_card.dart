import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'mini_text_field.dart';
import 'result_box.dart';
import 'total_salary_card.dart';

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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Deductions & Rewards",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const SizedBox(
                width: 110,
                child: Text(
                  "Deduction =",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Expanded(
                child: MiniTextField(
                  controller: deductionAbsentController,
                  hint: "number",
                  onChanged: onChanged,
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text("+"),
              ),

              Expanded(
                child: MiniTextField(
                  controller: deductionCustomController,
                  hint: "absent",
                  onChanged: onChanged,
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text("="),
              ),

              ResultBox(
                value: deductionResult,
              ),
            ],
          ),

          const Divider(height: 30),

          const Text(
            "Reward Formula",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: MiniTextField(
                  controller: rewardValueController,
                  hint: "sum",
                  onChanged: onChanged,
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text("+"),
              ),

              Expanded(
                child: MiniTextField(
                  controller: rewardMultiplierController,
                  hint: "amount",
                  onChanged: onChanged,
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text("="),
              ),

              const ResultBox(
                value: 0,
              ),
            ],
          ),

          SizedBox(height: 25.h),

          TotalSalaryCard(
            title: "Total Salary",
            formula: "Basic + OT + Bonus - Deduct",
            value: totalSalary,
          ),

          SizedBox(height: 20.h),

          TotalSalaryCard(
            title: "Total Salary with Reward",
            formula: "Total Salary + Reward",
            value: totalSalaryWithReward,
          ),
        ],
      ),
    );
  }
}