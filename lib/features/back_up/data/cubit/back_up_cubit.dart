import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/features/back_up/data/cubit/back_up_state.dart';
import 'package:smart_salary/features/firebase/google_drive_services.dart';
import 'package:smart_salary/features/firebase/locale_backup_services.dart';
import 'package:smart_salary/features/firebase/salary_firestore_services.dart';

class BackupCubit extends Cubit<BackupState> {
  BackupCubit() : super(BackupInitial());

  Future<void> createBackup({required String type}) async {
    try {
      emit(BackupLoading());

      final uid = FirebaseAuth.instance.currentUser!.uid;
      final data = await SalaryFirestoreServices.getBackupData(uid: uid);

      bool isSuccess = true;

      if (type == "drive") {
        await GoogleDriveService.uploadBackup(data);
        await FirebaseAuth.instance.currentUser?.reload();
      } else if (type == "local") {
        isSuccess = await LocalBackupService.createLocalBackup(data);
      }
      if (!isSuccess) {
        emit(BackupCancelled());
        return;
      }

      await SalaryFirestoreServices.saveBackupInfo(uid: uid, type: type);
      emit(BackupCreateSuccess(DateTime.now()));
    } catch (e, stack) {
      print("BACKUP ERROR =====> $e");
      emit(BackupError(e.toString().replaceAll("Exception: ", "")));
    }
  }
  Future<void> performAutoBackup({bool checkPeriodic = true}) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final uid = currentUser.uid;
      if (checkPeriodic) {
        final doc = await SalaryFirestoreServices.backupStream(uid: uid, type: "drive").first;
        if (doc.exists) {
          final lastDate = (doc.data()?["createdAt"] as Timestamp?)?.toDate();
          if (lastDate != null && DateTime.now().difference(lastDate).inDays < 3) {
            return;
          }
        }
      }

      final data = await SalaryFirestoreServices.getBackupData(uid: uid);
      final isSuccess = await GoogleDriveService.uploadBackupSilently(data);

      if (isSuccess) {
        await SalaryFirestoreServices.saveBackupInfo(uid: uid, type: "drive");
        print("AUTO BACKUP SUCCESSFUL");
      }
    } catch (e) {
      print("AUTO BACKUP FAILED: $e");
    }
  }

  Future<void> restoreBackup({required String type}) async {
    try {
      emit(BackupLoading());
      final uid = FirebaseAuth.instance.currentUser!.uid;

      if (type == "drive") {
        final backupData = await GoogleDriveService.downloadLatestBackup();
        await FirebaseAuth.instance.currentUser?.reload();
        if (backupData != null) {
          await SalaryFirestoreServices.restoreBackupData(
            uid: uid,
            backupData: backupData,
          );
          await SalaryFirestoreServices.saveBackupInfo(uid: uid, type: type);
          emit(BackupRestoreSuccess());
        } else {
          emit(BackupCancelled());
        }
      } else if (type == "local") {
        final backupData = await LocalBackupService.restoreLocalBackup();

        if (backupData != null) {
          await SalaryFirestoreServices.restoreBackupData(
            uid: uid,
            backupData: backupData,
          );
          await SalaryFirestoreServices.saveBackupInfo(uid: uid, type: type);
          emit(BackupRestoreSuccess());
        } else {
          emit(BackupCancelled());
        }
      }
    } catch (e, stack) {
      print("RESTORE ERROR =====> $e");
      emit(BackupError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  Future<void> loadBackup(String type) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final doc = await SalaryFirestoreServices.backupStream(
        uid: uid,
        type: type,
      ).first;

      DateTime? date;

      if (doc.exists) {
        final data = doc.data();
        date = (data?["createdAt"] as dynamic)?.toDate();
      }

      emit(BackupInfoSuccess(lastBackup: date));
    } catch (e) {
      emit(BackupError(e.toString().replaceAll("Exception: ", "")));
    }
  }
}