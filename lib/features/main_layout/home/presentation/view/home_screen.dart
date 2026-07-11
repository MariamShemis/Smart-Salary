import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/features/main_layout/home/data/cubit/home_cubit.dart';
import 'package:smart_salary/features/main_layout/home/data/cubit/home_state.dart';
import 'package:smart_salary/features/main_layout/home/presentation/widgets/home_title.dart';
import 'package:smart_salary/features/main_layout/home/presentation/widgets/net_salary_card.dart';
import 'package:smart_salary/features/main_layout/home/presentation/widgets/salary_details_grid.dart';
import 'package:smart_salary/features/main_layout/home/presentation/widgets/vacation_balance_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().loadHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading || state is HomeInitial) {
          return const Center(
            child: CircularProgressIndicator(
              color: ColorManager.primaryColor,
            ),
          );
        }

        final homeState = state as HomeLoaded;

        return SafeArea(
          top: false,
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<HomeCubit>().loadHome();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: REdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomeTitle(),
                    SizedBox(height: 3.h),

                    Divider(
                      color: ColorManager.greyDark.withOpacity(.2),
                      thickness: 1.5,
                      indent: 4,
                      endIndent: 4,
                    ),

                    SizedBox(height: 16.h),

                    NetSalaryCard(
                      totalSalary: homeState.homeData["totalSalary"]!,
                      totalSalaryWithReward:
                      homeState.homeData["totalSalaryWithReward"]!,
                      month: DateFormat("MMMM yyyy").format(homeState.month),
                    ),

                    SizedBox(height: 20.h),

                    SalaryDetailsGrid(
                      basicSalary: homeState.homeData["basicSalary"]!,
                      overtimeDays: homeState.homeData["overtimeDays"]!,
                      overtimeMonth: homeState.homeData["overtimeMonth"]!,
                      bonusDays: homeState.homeData["bonusDays"]!,
                      bonusMonth: homeState.homeData["bonusMonth"]!,
                      deduction: homeState.homeData["deduction"]!,
                    ),

                    SizedBox(height: 20.h),

                    VacationBalanceCard(
                      remainingDays: homeState.homeData["vacationDays"]!,
                    ),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}