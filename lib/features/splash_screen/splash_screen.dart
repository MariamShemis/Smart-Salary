import 'package:flutter/material.dart';
import 'package:smart_salary/core/costants/assets_manager.dart';

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
    _navigateToHomeScreen();
  }

  void _navigateToHomeScreen() async {
    await Future.delayed(const Duration(seconds: 5));
    if (mounted) {
      // استبدل 'HomeScreen()' بصفحة تطبيقك الرئيسية
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryDarkGreen = Color(0xFF005954);
    const Color textBlack = Color(0xFF1A1A1A);
    const Color textGrey = Color(0xFF708090);

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
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: primaryDarkGreen,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryDarkGreen.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_rounded,
                              size: 55,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Smart Salary',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textBlack,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Precision Payroll & Financial Clarity',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: textGrey,
                      ),
                    ),
                    const Spacer(flex: 3),
                    SizedBox(
                      width: 180,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: const LinearProgressIndicator(
                              backgroundColor: Color(0xFFD0E6E4),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                primaryDarkGreen,
                              ),
                              minHeight: 3,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'INITIALIZING',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: primaryDarkGreen,
                              letterSpacing: 4.0,
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
