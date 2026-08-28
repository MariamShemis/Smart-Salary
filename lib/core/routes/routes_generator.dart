import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/core/routes/app_routes.dart';
import 'package:smart_salary/features/account_security/presentation/view/account_security_screen.dart';
import 'package:smart_salary/features/auth/presentation/view/forget_password.dart';
import 'package:smart_salary/features/auth/presentation/view/login_screen.dart';
import 'package:smart_salary/features/auth/presentation/view/register_screen.dart';
import 'package:smart_salary/features/back_up/presentation/view/back_up_screen.dart';
import 'package:smart_salary/features/edit_profile/presentation/view/edit_profile.dart';
import 'package:smart_salary/features/language/presentation/view/language_profile.dart';
import 'package:smart_salary/features/main_layout/main_layout.dart';
import 'package:smart_salary/features/onboarding/presentation/view/onboarding_screen.dart';
import 'package:smart_salary/features/splash_screen/splash_screen.dart';
import 'package:smart_salary/features/verify_email/data/cubit/verify_email_cubit.dart';
import 'package:smart_salary/features/verify_email/presentation/view/verify_email_screen.dart';

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
      case AppRoutes.register:
        {
          return CupertinoPageRoute(builder: (context) => RegisterScreen());
        }
      case AppRoutes.forgetPassword:
        {
          return CupertinoPageRoute(builder: (context) => ForgetPassword());
        }
      case AppRoutes.mainLayout:
        {
          return CupertinoPageRoute(builder: (context) => MainLayout());
        }
      case AppRoutes.language:
        {
          return CupertinoPageRoute(builder: (context) => LanguageProfile());
        }
      case AppRoutes.editProfile:
        {
          return CupertinoPageRoute(builder: (context) => EditProfile());
        }
      case AppRoutes.backUp:
        {
          return CupertinoPageRoute(builder: (context) => BackUpScreen());
        }
      case AppRoutes.verifyEmail:
        {
          final args = settings.arguments;
          String? email;
          bool fromAccountSecurity = false;

          if (args is String) {
            email = args;
          } else if (args is Map<String, dynamic>) {
            email = args['email'] as String?;
            fromAccountSecurity = args['fromAccountSecurity'] as bool? ?? false;
          }
          return CupertinoPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => VerifyEmailCubit(),
              child: VerifyEmailScreen(
                email: email,
                fromAccountSecurity: fromAccountSecurity,
              ),
            ),
          );
        }
      case AppRoutes.accountSecurity:
        {
          return CupertinoPageRoute(
            builder: (context) => AccountSecurityScreen(),
          );
        }
    }

    return null;
  }
}
