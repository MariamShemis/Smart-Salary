import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/utils/ui_utils.dart';
import 'package:smart_salary/core/widgets/main_gradient_background.dart';
import 'package:smart_salary/features/back_up/data/cubit/back_up_cubit.dart';
import 'package:smart_salary/features/back_up/data/cubit/back_up_state.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class BackUpScreen extends StatefulWidget {
  const BackUpScreen({super.key});

  @override
  State<BackUpScreen> createState() => _BackUpScreenState();
}

class _BackUpScreenState extends State<BackUpScreen> {
  String backupType = "drive";

  @override
  void initState() {
    super.initState();
    context.read<BackupCubit>().loadBackup(backupType);
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return MainGradientBackground(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(appLocalizations.backup_Restore),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.r),
          child: BlocConsumer<BackupCubit, BackupState>(
            listener: (context, state) {
              if (state is BackupLoading) {
                UiUtils.showLoading(context, isDismissible: false);
              }
              if (state is BackupCreateSuccess) {
                UiUtils.hideLoading(context);
                UiUtils.showToast(
                  appLocalizations.backup_completed_successfully,
                );
                context.read<BackupCubit>().loadBackup(
                  backupType,
                ); // تحديث التاريخ في الشاشة
              }
              if (state is BackupRestoreSuccess) {
                UiUtils.hideLoading(context);
                UiUtils.showToast(
                  appLocalizations.restore_completed_successfully,
                );
                context.read<BackupCubit>().loadBackup(backupType);
              }
              if (state is BackupCancelled) {
                UiUtils.hideLoading(context);
                UiUtils.showToast(appLocalizations.operation_cancelled);
              }
              if (state is BackupInitial) {
                UiUtils.hideLoading(context);
              }
              if (state is BackupError) {
                UiUtils.hideLoading(context);
                UiUtils.showError(context, state.message);
              }
            },
            builder: (context, state) {
              DateTime? lastBackup;

              if (state is BackupInfoSuccess) {
                lastBackup = state.lastBackup;
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.cloud_done_outlined,
                            size: 60.sp,
                            color: ColorManager.primaryColor,
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            appLocalizations.backup_Restore,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            lastBackup == null
                                ? appLocalizations.no_backup_created_yet
                                : "${appLocalizations.last_backup}\n${lastBackup.toString().split(".").first}",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appLocalizations.backupLocation,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            RadioListTile<String>(
                              value: "drive",
                              groupValue: backupType,
                              onChanged: (value) {
                                setState(() {
                                  backupType = value!;
                                });
                                context.read<BackupCubit>().loadBackup("drive");
                              },
                              title: Text(appLocalizations.googleDrive),
                              secondary: const Icon(Icons.cloud),
                            ),
                            RadioListTile<String>(
                              value: "local",
                              groupValue: backupType,
                              onChanged: (value) {
                                setState(() {
                                  backupType = value!;
                                });
                                context.read<BackupCubit>().loadBackup("local");
                              },
                              title: Text(appLocalizations.localDevice),
                              secondary: const Icon(Icons.phone_android),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<BackupCubit>().createBackup(
                            type: backupType,
                          );
                        },
                        icon: const Icon(Icons.cloud_upload),
                        label: Text(appLocalizations.createBackup),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.read<BackupCubit>().restoreBackup(
                            type: backupType,
                          );
                        },
                        icon: const Icon(Icons.restore),
                        label: Text(appLocalizations.restoreBackup),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
