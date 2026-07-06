import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/widgets/custom_auth_text_form_field.dart';
import 'package:smart_salary/core/widgets/logo_app.dart';
import 'package:smart_salary/core/widgets/main_gradient_background.dart';
import 'package:smart_salary/features/auth/presentation/widgets/custom_login_outline_border.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return MainGradientBackground(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: ColorManager.primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            appLocalizations.sign_up,
            style: TextStyle(
              color: ColorManager.primaryColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: REdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Container(
                padding: REdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(28.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20.r,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LogoApp(width: 65.w, height: 65.h, size: 43),
                    SizedBox(height: 16.h),
                    Text(
                      appLocalizations.smartSalary,
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.primaryColor,
                      ),
                    ),
                    SizedBox(height: 25.h),
                    CustomAuthTextFormField(
                      controller: _nameController,
                      labelText: appLocalizations.name,
                      hintText: appLocalizations.enterYourName,
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(height: 20.h),
                    CustomAuthTextFormField(
                      controller: _emailController,
                      labelText: appLocalizations.email,
                      hintText: appLocalizations.enterYourEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20.h),
                    CustomAuthTextFormField(
                      controller: _passwordController,
                      labelText: appLocalizations.password,
                      hintText: '••••••••',
                      keyboardType: TextInputType.visiblePassword,
                      isPassword: true,
                    ),
                    SizedBox(height: 20.h),
                    CustomAuthTextFormField(
                      controller: _confirmPasswordController,
                      labelText: appLocalizations.confirmPassword,
                      hintText: '••••••••',
                      keyboardType: TextInputType.visiblePassword,
                      isPassword: true,
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(appLocalizations.sign_up),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFE5E9E7),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: REdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            appLocalizations.orContinueWith,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.greyDark,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFE5E9E7),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomLoginOutlineBorder(onPressed: () {}),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: CustomLoginOutlineBorder(
                            onPressed: () {},
                            isGoogle: false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${appLocalizations.alreadyHaveAccount}  ",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorManager.greyDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            appLocalizations.login,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
