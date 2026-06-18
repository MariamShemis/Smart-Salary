import 'package:flutter/material.dart';

class MainGradientBackground extends StatelessWidget {
  final Widget child;

  const MainGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.0, -0.2),
          radius: 1.3,
          colors: [
            Color(0xFFE2F4F1),
            Color(0xFFF4F7F6),
          ],
        ),
      ),
      child: child,
    );
  }
}