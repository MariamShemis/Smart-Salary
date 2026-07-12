import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/routes/app_routes.dart';
import 'package:smart_salary/features/main_layout/profile/presentation/widgets/profile_header.dart';
import 'package:smart_salary/features/main_layout/profile/presentation/widgets/profile_menu_item.dart';
import 'package:smart_salary/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/features/auth/data/cubit/auth_cubit.dart';
import 'package:smart_salary/features/auth/data/cubit/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: REdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              ProfileHeader(
                name: 'Alexander Sterling',
                job: 'Senior Product Designer',
                phoneNumber: '01054574545',
                image: CircleAvatar(
                  radius: 40.r,
                  backgroundColor: ColorManager.greyText,
                  child: Icon(
                    Icons.person,
                    size: 35.sp,
                    color: ColorManager.white,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              Text(
                appLocalizations.general_settings.toUpperCase(),
                style: TextStyle(
                  color: ColorManager.greyDark.withOpacity(0.5),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.015),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ProfileMenuTile(
                      icon: Icons.person_outline_outlined,
                      title: appLocalizations.editProfile,
                      onTap: () {},
                    ),
                    ProfileMenuTile(
                      icon: Icons.security_rounded,
                      title: appLocalizations.account_Security,
                      onTap: () {},
                    ),
                    ProfileMenuTile(
                      icon: Icons.language_rounded,
                      title: appLocalizations.language,
                      trailingText: 'English',
                      onTap: () {},
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 44.h),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: TextButton(
                  onPressed: () {
                    _showDialogLogOut(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: ColorManager.red.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: ColorManager.red,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        appLocalizations.log_out,
                        style: TextStyle(
                          color: ColorManager.red,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialogLogOut(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: ColorManager.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          appLocalizations.log_out,
          style: TextStyle(
            color: ColorManager.primaryColor,
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          appLocalizations.are_you_sure_you_want_to_log_out,
          style: TextStyle(
            color: ColorManager.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              appLocalizations.cancel,
              style: TextStyle(color: ColorManager.red),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            ),
            child: Text(
              appLocalizations.ok,
              style: TextStyle(color: ColorManager.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
