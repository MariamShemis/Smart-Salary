import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_salary/core/costants/color_manager.dart';

class CustomProfileField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomProfileField({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: REdgeInsets.only(left: 4, bottom: 8, right: 4),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.black,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}