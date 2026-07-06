import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/assets_manager.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/widgets/custom_auth_text_form_field.dart';
import 'package:smart_salary/core/widgets/main_gradient_background.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
            appLocalizations.forgetPassword,
            style: TextStyle(
              color: ColorManager.primaryColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: REdgeInsets.only(
              left: 24.0, right: 24,
              top: 10.0,
              bottom: 16.0,
            ),
            child: Column(
              children: [
                Image.asset(
                  ImageAssets.forgetPassword,
                  height: 300.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10.h),
                Container(
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
                    children: [
                      Text(
                        appLocalizations.forget_password_,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: REdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          appLocalizations
                              .pleaseEnterYourEmailToReceiveAConfirmationCodeToSetANewPassword,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(fontSize: 12.sp),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      CustomAuthTextFormField(
                        controller: _emailController,
                        labelText: appLocalizations.email,
                        hintText: appLocalizations.enterYourEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 24.h),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 48.h),
                        ),
                        child: Text(appLocalizations.resetPassword),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}