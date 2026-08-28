import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';

class CustomLanguageCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String languageCode;
  final String selectedLanguage;
  final ValueChanged<String?> onChanged;

  const CustomLanguageCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.languageCode,
    required this.selectedLanguage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedLanguage == languageCode;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected
            ? ColorManager.green6e.withValues(alpha: 0.5)
            : ColorManager.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected ? ColorManager.secondary : ColorManager.greyText,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        child: RadioListTile<String>(
          value: languageCode,
          groupValue: selectedLanguage,
          activeColor: ColorManager.secondary,
          radioScaleFactor: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          radioSide: BorderSide(
            color: isSelected ? ColorManager.secondary : ColorManager.greyText,
            width: 1,
          ),
          onChanged: onChanged,
          title: Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          subtitle: Text(
            subTitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
          ),
          secondary: CircleAvatar(
            backgroundColor: ColorManager.secondary,
            child: Text(
              languageCode.toUpperCase(),
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          controlAffinity: ListTileControlAffinity.trailing,
        ),
      ),
    );
  }
}