import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/assets_manager.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/utils/ui_utils.dart';
import 'package:smart_salary/core/utils/validators/app_validators.dart';
import 'package:smart_salary/core/widgets/custom_auth_text_form_field.dart';
import 'package:smart_salary/core/widgets/main_gradient_background.dart';
import 'package:smart_salary/features/auth/data/cubit/auth_cubit.dart';
import 'package:smart_salary/features/auth/data/cubit/auth_state.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ResetPasswordLoading) {
          UiUtils.showLoading(context, isDismissible: false);
        }
        if (state is ResetPasswordSuccess) {
          UiUtils.showSuccess(
            context,
            "Password reset email sent successfully.",
          );
          Navigator.pop(context);
        }
        if (state is ResetPasswordError) {
          UiUtils.showError(context, state.message);
        }
      },
      builder: (context, state) {
        return MainGradientBackground(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: ColorManager.primaryColor,
                ),
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
                  left: 24.0,
                  right: 24,
                  top: 10.0,
                  bottom: 16.0,
                ),
                child: Form(
                  key: _formKey,
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
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(fontSize: 12.sp),
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
                              validator: (value) =>
                                  AppValidators.validateEmail(value, context),
                            ),
                            SizedBox(height: 24.h),
                            ElevatedButton(
                              onPressed: _resetPassword,
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
          ),
        );
      },
    );
  }

  void _resetPassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthCubit>().resetPassword(_emailController.text.trim());
  }
}
