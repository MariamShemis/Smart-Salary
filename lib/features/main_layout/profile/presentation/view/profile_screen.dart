import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/routes/app_routes.dart';
import 'package:smart_salary/features/auth/data/model/user_model.dart';
import 'package:smart_salary/features/language/data/cubit/language_cubit.dart';
import 'package:smart_salary/features/language/data/cubit/language_state.dart';
import 'package:smart_salary/features/main_layout/profile/data/cubit/profile_cubit.dart';
import 'package:smart_salary/features/main_layout/profile/data/cubit/profile_state.dart';
import 'package:smart_salary/features/main_layout/profile/presentation/widgets/profile_header.dart';
import 'package:smart_salary/features/main_layout/profile/presentation/widgets/profile_menu_item.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().listenProfile();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        }
        if (state is LogoutError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Center(
            child: CircularProgressIndicator(color: ColorManager.primaryColor),
          );
        }
        if (state is ProfileError) {
          return Center(child: Text(state.message));
        }
        UserModel? user;
        if (state is ProfileSuccess) {
          user = state.user;
        }
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
                    name: user?.name ?? '',
                    job: user?.jobTitle?.isNotEmpty == true
                        ? user!.jobTitle!
                        : user?.email ?? "",
                    phoneNumber: user?.phone ?? '',
                    image: CircleAvatar(
                      radius: 40.r,
                      backgroundColor: ColorManager.greyText,
                      backgroundImage: (user?.image?.isNotEmpty ?? false)
                          ? NetworkImage(user!.image!)
                          : null,

                      child: (user?.image?.isNotEmpty ?? false)
                          ? null
                          : Icon(
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
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.editProfile);
                          },
                        ),
                        ProfileMenuTile(
                          icon: Icons.cloud_done_rounded,
                          title: appLocalizations.backup_Restore,
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.backUp);
                          },
                        ),
                        ProfileMenuTile(
                          icon: Icons.security_rounded,
                          title: appLocalizations.account_Security,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.accountSecurity,
                            );
                          },
                        ),
                        BlocBuilder<LanguageCubit, LanguageState>(
                          builder: (context, state) {
                            return ProfileMenuTile(
                              icon: Icons.language_rounded,
                              title: appLocalizations.language,
                              trailingText: state.locale.languageCode == "ar"
                                  ? "العربية"
                                  : "English",
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.language,
                                );
                              },
                              showDivider: false,
                            );
                          },
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
      },
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
            onPressed: () async {
              Navigator.pop(context);

              await context.read<ProfileCubit>().logout();
            },
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
