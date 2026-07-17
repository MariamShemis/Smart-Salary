import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/features/auth/data/cubit/auth_cubit.dart';
import 'package:smart_salary/features/edit_profile/data/cubit/edit_profile_cubit.dart';
import 'package:smart_salary/features/language/data/cubit/language_cubit.dart';
import 'package:smart_salary/features/main_layout/daily_reports/data/cubit/daily_reports_cubit.dart';
import 'package:smart_salary/features/main_layout/home/data/cubit/home_cubit.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/data/cubit/salary_cubit.dart';
import 'package:smart_salary/smart_salary.dart';
import 'features/main_layout/profile/data/cubit/profile_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => SalaryCubit()),
        BlocProvider(create: (_) => DailyReportsCubit()),
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(create: (_) => HomeCubit()..loadHome()),
        BlocProvider(create: (_) => ProfileCubit()),
        BlocProvider(create: (_) => EditProfileCubit()),
      ],
      child: SmartSalary(),
    ),
  );
}
