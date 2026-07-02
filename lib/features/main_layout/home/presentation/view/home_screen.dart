import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/features/main_layout/home/presentation/widgets/home_title.dart';
import 'package:smart_salary/features/main_layout/home/presentation/widgets/net_salary_card.dart';
import 'package:smart_salary/features/main_layout/home/presentation/widgets/quick_actions_row.dart';
import 'package:smart_salary/features/main_layout/home/presentation/widgets/salary_details_grid.dart';
import 'package:smart_salary/features/main_layout/home/presentation/widgets/vacation_balance_card.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: REdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeTitle(),
              SizedBox(height: 3.h),
              Divider(
                color: ColorManager.greyDark.withOpacity(0.2),
                thickness: 1.5,
                indent: 4,
                endIndent: 4,
              ),
              SizedBox(height: 16.h),
              const NetSalaryCard(),
              SizedBox(height: 20.h),
              const SalaryDetailsGrid(),
              SizedBox(height: 20.h),
              const VacationBalanceCard(),
              SizedBox(height: 24.h),
              Text(
                'QUICK ACTIONS',
                style: TextStyle(
                  color: ColorManager.greyDark.withOpacity(0.6),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: 12.h),
              const QuickActionsRow(),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}