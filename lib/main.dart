import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/features/main_layout/daily_reports/data/cubit/daily_reports_cubit.dart';
import 'package:smart_salary/features/main_layout/home/data/cubit/home_cubit.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/data/cubit/salary_cubit.dart';
import 'package:smart_salary/smart_salary.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SalaryCubit()),
        BlocProvider(create: (_) => DailyReportsCubit()),
        BlocProvider(create: (_) => HomeCubit()..loadHome()),
      ],
      child: SmartSalary(),
    ),
  );
}
