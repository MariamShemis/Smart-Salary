import 'package:flutter/material.dart';
import 'package:smart_salary/core/routes/routes_generator.dart';

import 'core/routes/app_routes.dart';

class SmartSalary extends StatelessWidget {
  const SmartSalary({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Smart Salary",
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RoutesGenerator.router,
      initialRoute: AppRoutes.splashScreen,
      //theme: ThemeManager.lightTheme,
    );
  }
}
