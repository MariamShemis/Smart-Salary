import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_salary/core/costants/assets_manager.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class CustomLoginOutlineBorder extends StatelessWidget {
  const CustomLoginOutlineBorder({
    super.key,
    this.isGoogle = true,
    this.isGoogleLogin = false,
    required this.onPressed,
  });

  final bool isGoogle;
  final bool isGoogleLogin;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isGoogle || isGoogleLogin
              ? SvgPicture.asset(SvgAssets.googleIcon, height: 20.h)
              : Icon(Icons.apple, color: Colors.black, size: 22.sp),
          SizedBox(width: 8.w),
          Text(
            isGoogle
                ? 'Google'
                : isGoogleLogin
                ? appLocalizations.login_with_Google
                : "Apple ID",
            style: TextStyle(
              color: ColorManager.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
