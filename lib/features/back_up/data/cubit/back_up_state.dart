abstract class BackupState {}

class BackupInitial extends BackupState {}

class BackupLoading extends BackupState {}

class BackupInfoSuccess extends BackupState {
  final DateTime? lastBackup;

  BackupInfoSuccess({this.lastBackup});
}

class BackupCreateSuccess extends BackupState {
  final DateTime createdAt;

  BackupCreateSuccess(this.createdAt);
}

class BackupRestoreSuccess extends BackupState {}

class BackupCancelled extends BackupState {}

class BackupError extends BackupState {
  final String message;

  BackupError(this.message);
}