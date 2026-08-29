import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:smart_salary/core/routes/routes_generator.dart';
import 'package:smart_salary/core/theme/theme_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smart_salary/features/language/data/cubit/language_state.dart';
import 'core/routes/app_routes.dart';
import 'features/language/data/cubit/language_cubit.dart';
import 'l10n/app_localizations.dart';

class SmartSalary extends StatelessWidget {
  const SmartSalary({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 882),
        splitScreenMode: true,
        minTextAdapt: true,
        builder: (context, child) =>
            BlocBuilder<LanguageCubit, LanguageState>(
              builder: (context, state) {
                return MaterialApp(
                  title: "Smart Salary",
                  debugShowCheckedModeBanner: false,
                  onGenerateRoute: RoutesGenerator.router,
                  initialRoute: AppRoutes.appLock,
                  theme: ThemeManager.light,
                  themeMode: ThemeMode.light,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    MonthYearPickerLocalizations.delegate,
                  ],
                  supportedLocales: AppLocalizations.supportedLocales,
                    locale: state.locale,
                );
              },
            )
    );
  }
}
