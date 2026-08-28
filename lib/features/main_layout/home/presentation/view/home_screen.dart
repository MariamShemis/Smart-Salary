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
import 'package:smart_salary/l10n/app_localizations.dart';

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
      context.read<HomeCubit>().listenUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading || state is HomeInitial) {
          return const Center(
            child: CircularProgressIndicator(color: ColorManager.primaryColor),
          );
        }

        if (state is HomeError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                SizedBox(height: 12.h),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeCubit>().listenUser();
                  },
                  child: Text(appLocalizations.tryAgain),
                ),
              ],
            ),
          );
        }
        if (state is HomeLoaded) {
          return SafeArea(
            top: false,
            child: RefreshIndicator(
              color: ColorManager.primaryColor,
              onRefresh: () async {
                context.read<HomeCubit>().listenUser();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: REdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeTitle(
                        name: state.user.name,
                        image: CircleAvatar(
                          radius: 28.r,
                          backgroundColor: ColorManager.primaryColor,
                          backgroundImage:
                              (state.user.image?.isNotEmpty ?? false)
                              ? NetworkImage(state.user.image!)
                              : null,
                          child: (state.user.image?.isNotEmpty ?? false)
                              ? null
                              : Icon(
                                  Icons.person,
                                  color: ColorManager.secondary,
                                  size: 25.sp,
                                ),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Divider(
                        color: ColorManager.greyDark.withOpacity(.2),
                        thickness: 1.5,
                        indent: 4,
                        endIndent: 4,
                      ),
                      SizedBox(height: 16.h),
                      NetSalaryCard(
                        totalSalary: state.homeData["totalSalary"] ?? 0,
                        totalSalaryWithReward:
                            state.homeData["totalSalaryWithReward"] ?? 0,
                        month: DateFormat("MMMM yyyy").format(state.month),
                      ),
                      SizedBox(height: 20.h),
                      SalaryDetailsGrid(
                        basicSalary: state.homeData["basicSalary"] ?? 0,
                        overtimeDays: state.homeData["overtimeDays"] ?? 0,
                        overtimeMonth: state.homeData["overtimeMonth"] ?? 0,
                        bonusDays: state.homeData["bonusDays"] ?? 0,
                        bonusMonth: state.homeData["bonusMonth"] ?? 0,
                        deduction: state.homeData["deduction"] ?? 0,
                        annualOvertime: state.homeData["annualOvertime"] ?? 0,
                        annualBonus: state.homeData["annualBonus"] ?? 0,
                      ),
                      SizedBox(height: 20.h),
                      VacationBalanceCard(
                        remainingDays: state.homeData["vacationDays"] ?? 30,
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
