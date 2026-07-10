import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/session_service/session_service.dart';
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
  Map<String, double>? homeData;
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }
  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    _selectedMonth = await SessionService.loadSelectedMonth();

    homeData = await SessionService.loadSalaryResults(_selectedMonth);

    print(homeData);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (homeData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      top: false,
      child: RefreshIndicator(
        onRefresh: _loadHomeData,
        child: SingleChildScrollView(
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
                  totalSalary: homeData!["totalSalary"]!,
                  totalSalaryWithReward: homeData!["totalSalaryWithReward"]!,
                  month: DateFormat("MMMM yyyy").format(_selectedMonth),
                ),
                SizedBox(height: 20.h),
                SalaryDetailsGrid(
                  basicSalary: homeData!["basicSalary"]!,
                  overtimeDays: homeData!["overtimeDays"]!,
                  overtimeMonth: homeData!["overtimeMonth"]!,
                  bonusDays: homeData!["bonusDays"]!,
                  bonusMonth: homeData!["bonusMonth"]!,
                  deduction: homeData!["deduction"]!,
                ),
                SizedBox(height: 20.h),
                VacationBalanceCard(remainingDays: homeData!["vacationDays"]!),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
