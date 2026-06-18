import 'package:flutter/cupertino.dart';
import 'package:smart_salary/core/routes/app_routes.dart';
import 'package:smart_salary/features/auth/presentation/view/login_screen.dart';
import 'package:smart_salary/features/onboarding/presentation/view/onboarding_screen.dart';
import 'package:smart_salary/features/splash_screen/splash_screen.dart';

abstract class RoutesGenerator {
  static Route? router(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splashScreen:
        {
          return CupertinoPageRoute(builder: (context) => SplashScreen());
        }
      case AppRoutes.onboarding:
        {
          return CupertinoPageRoute(builder: (context) => OnboardingScreen());
        }
      case AppRoutes.login:
        {
          return CupertinoPageRoute(builder: (context) => LoginScreen());
        }
    }

    return null;
  }
}
