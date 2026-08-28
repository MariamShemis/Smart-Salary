import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../costants/color_manager.dart';

class ThemeManager {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: ColorManager.primaryColor,
    scaffoldBackgroundColor: Colors.transparent,

    colorScheme: ColorScheme.light(
      primary: ColorManager.primaryColor,
      onPrimary: ColorManager.white,
      secondary: ColorManager.secondary,
      onSecondary: ColorManager.black,
      background: ColorManager.background,
      onBackground: ColorManager.black,
      surface: ColorManager.white,
      onSurface: ColorManager.black,
      error: ColorManager.red,
      onError: ColorManager.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: ColorManager.black),
      titleTextStyle: GoogleFonts.inter(
        color: ColorManager.black,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.primaryColor,
        foregroundColor: ColorManager.white,
        minimumSize: Size(double.infinity, 52.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        textStyle: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, 52.h),
        side: BorderSide(color: Color(0xFFD1DCDA), width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        textStyle: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorManager.white,
      contentPadding: REdgeInsets.symmetric(horizontal: 20, vertical: 16),

      hintStyle: GoogleFonts.inter(color: ColorManager.greyDark, fontSize: 14.sp),
      labelStyle: GoogleFonts.inter(color: ColorManager.greyDark, fontSize: 14.sp),
      floatingLabelStyle: GoogleFonts.inter(
        color: ColorManager.primaryColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      prefixIconColor: ColorManager.greyDark,
      suffixIconColor: ColorManager.greyDark,

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.0.w),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(
          color: ColorManager.primaryColor,
          width: 1.5.w,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: ColorManager.red, width: 1.0.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: ColorManager.red, width: 1.5.w),
      ),
      errorStyle: GoogleFonts.inter(
        color: ColorManager.red,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
    ),

    textTheme: TextTheme(
      headlineLarge: GoogleFonts.inter(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        color: ColorManager.black,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: ColorManager.black,
      ),
      bodyLarge: GoogleFonts.inter(fontSize: 16.sp, color: ColorManager.black),
      bodyMedium: GoogleFonts.inter(fontSize: 14.sp, color: ColorManager.greyDark),
      labelLarge: GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: ColorManager.white,
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: ColorManager.white,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
  );
}
