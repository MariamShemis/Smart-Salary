import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';

class NetSalaryCard extends StatefulWidget {
  final double totalSalary;
  final double totalSalaryWithReward;
  final String month;

  const NetSalaryCard({
    super.key,
    required this.totalSalary,
    required this.totalSalaryWithReward, required this.month,
  });

  @override
  State<NetSalaryCard> createState() => _NetSalaryCardState();
}

class _NetSalaryCardState extends State<NetSalaryCard> {
  bool _showReward = false;

  @override
  Widget build(BuildContext context) {
    final salary = _showReward
        ? widget.totalSalaryWithReward
        : widget.totalSalary;

    final parts = salary.toStringAsFixed(2).split(".");

    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorManager.white,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorManager.white,
            ColorManager.white,
            ColorManager.background.withOpacity(0.03),
          ],
          stops: const [0.0, 0.65, 2.0],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                        widget.month.toUpperCase(),
                      style: TextStyle(
                        color: ColorManager.primaryColor.withOpacity(.8),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: ColorManager.greyDark.withOpacity(.5),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Column(
                  key: ValueKey(_showReward),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _showReward
                          ? "NET SALARY WITH REWARD"
                          : "NET SALARY",
                      style: TextStyle(
                        color: ColorManager.greyDark.withOpacity(.6),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          parts[0],
                          style: TextStyle(
                            color: ColorManager.primaryColor,
                            fontSize: 34.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ".${parts[1]} ",
                          style: TextStyle(
                            color: ColorManager.primaryColor,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "LE",
                          style: TextStyle(
                            color: ColorManager.primaryColor,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          IconButton(
            onPressed: () {
              setState(() {
                _showReward = !_showReward;
              });
            },
            icon: AnimatedRotation(
              duration: const Duration(milliseconds: 300),
              turns: _showReward ? .5 : 0,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: ColorManager.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}