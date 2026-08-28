import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class AccountInfoCard extends StatelessWidget {
  final String email;
  final bool isVerified;

  const AccountInfoCard({
    super.key,
    required this.email,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36.r,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(.1),
            child: Icon(
              Icons.security_rounded,
              size: 34.sp,
              color: Theme.of(context).primaryColor,
            ),
          ),

          SizedBox(height: 18.h),

          Text(
            appLocalizations.account_Security,
            style: GoogleFonts.inter(
              fontSize: 21.sp,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 8.h),

          Text(
            email.isEmpty ? "No Email Provided" : email,
            style: GoogleFonts.inter(
              color: Colors.grey.shade700,
              fontSize: 14.sp,
            ),
          ),

          SizedBox(height: 20.h),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isVerified ? Colors.green.shade50 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isVerified
                      ? Icons.verified_rounded
                      : Icons.warning_amber_rounded,
                  size: 18.sp,
                  color: isVerified ? Colors.green : Colors.orange,
                ),
                SizedBox(width: 8.w),
                Text(
                  isVerified ? appLocalizations.emailVerified : appLocalizations.emailNotVerified,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: isVerified
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
