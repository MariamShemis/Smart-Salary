import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/routes/routes_generator.dart';
import 'package:smart_salary/core/theme/theme_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/routes/app_routes.dart';
import 'l10n/app_localizations.dart';

class SmartSalary extends StatelessWidget {
  const SmartSalary({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 882),
      splitScreenMode: true,
      minTextAdapt: true,
      builder:(context, child) =>  MaterialApp(
        title: "Smart Salary",
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RoutesGenerator.router,
        initialRoute: AppRoutes.splashScreen,
        theme: ThemeManager.light,
        themeMode: ThemeMode.light,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Locale("en"),
        supportedLocales: const [
          Locale('ar'),
          Locale('en'),
        ],
      ),
    );
  }
}
