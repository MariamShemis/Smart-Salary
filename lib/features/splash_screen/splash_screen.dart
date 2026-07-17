import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/assets_manager.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/routes/app_routes.dart';
import 'package:smart_salary/core/session_service/session_service.dart';
import 'package:smart_salary/core/widgets/logo_app.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoSkewAnimation;
  late Animation<double> _logoRotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _logoScaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );
    _logoRotationAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(
              begin: -0.5,
              end: 0.3,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 30,
          ),
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 0.3,
              end: -0.1,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 30,
          ),
          TweenSequenceItem(
            tween: Tween<double>(
              begin: -0.1,
              end: 0.0,
            ).chain(CurveTween(curve: Curves.easeIn)),
            weight: 40,
          ),
        ]).animate(
          CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.8)),
        );
    _logoSkewAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );
    _controller.forward();
    _navigate();
  }

  void _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    final onboardingDone = await SessionService.onboardingCompleted;
    if (!onboardingDone) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      return;
    }
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageAssets.splashBg),
            fit: BoxFit.fill,
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _logoFadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 4),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final Matrix4 transformMatrix = Matrix4.identity()
                          ..setEntry(3, 2, 0.002)
                          ..setEntry(0, 1, _logoSkewAnimation.value)
                          ..rotateZ(_logoRotationAnimation.value)
                          ..scale(_logoScaleAnimation.value);
                        return Transform(
                          alignment: Alignment.center,
                          transform: transformMatrix,
                          child: LogoApp(width: 110.w, height: 110.h, size: 55.sp,),
                        );
                      },
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      appLocalizations.smartSalary,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.black,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      appLocalizations.precisionPayroll_FinancialClarity,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorManager.greyDark,
                      ),
                    ),
                    const Spacer(flex: 3),
                    SizedBox(
                      width: 180.w,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2.r),
                            child: const LinearProgressIndicator(
                              backgroundColor: Color(0xFFD0E6E4),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                ColorManager.primaryColor,
                              ),
                              minHeight: 3,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            appLocalizations.iNITIALIZING,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
