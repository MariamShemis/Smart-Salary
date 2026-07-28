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
      } else if (type == "local") {
        isSuccess = await LocalBackupService.createLocalBackup(data);
      }

      // لو العملية اتلغت من المستخدم
      if (!isSuccess) {
        emit(BackupCancelled());
        return;
      }

      // تحفيظ التاريخ فقط لو نجحت العملية بالفعل
      await SalaryFirestoreServices.saveBackupInfo(uid: uid, type: type);
      emit(BackupCreateSuccess(DateTime.now()));
    } catch (e, stack) {
      print("BACKUP ERROR =====> $e");
      emit(BackupError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  Future<void> restoreBackup({required String type}) async {
    try {
      emit(BackupLoading());
      final uid = FirebaseAuth.instance.currentUser!.uid;

      if (type == "drive") {
        final backupData = await GoogleDriveService.downloadLatestBackup();

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
          // المستخدم ألغى الاختيار
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