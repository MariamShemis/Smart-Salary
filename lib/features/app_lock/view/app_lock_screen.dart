import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_salary/core/routes/app_routes.dart';
import 'package:smart_salary/core/session_service/biometric_service.dart';
import 'package:smart_salary/core/widgets/main_gradient_background.dart';
import 'package:smart_salary/features/firebase/firebase_services.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndAuthenticate();
    });
  }

  Future<void> _checkAndAuthenticate() async {
    // 1. إذا لم يكن هناك مستخدم مسجل، نذهب للـ Splash مباشرة
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _goToSplash();
      return;
    }

    // 2. التحقق مما إذا كانت البصمة مفعلة للحساب
    final isBiometricEnabled = await FirebaseServices.shouldUseBiometric();
    if (!isBiometricEnabled) {
      _goToSplash();
      return;
    }

    // 3. طلب البصمة في حال كانت مفعلة
    _authenticate();
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;
    setState(() => _isAuthenticating = true);

    final success = await BiometricService().authenticate(
      localizedReason: "Confirm your identity to access Smart Salary",
      biometricOnly: false,
    );

    if (mounted) {
      setState(() => _isAuthenticating = false);
      if (success) {
        _goToSplash();
      }
    }
  }

  void _goToSplash() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.splashScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainGradientBackground(
      child: Scaffold(
        body: const SizedBox.expand(),
      ),
    );
  }
}