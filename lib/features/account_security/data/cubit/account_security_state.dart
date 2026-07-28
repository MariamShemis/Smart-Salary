abstract class AccountSecurityState {}

class AccountSecurityInitial extends AccountSecurityState {}

class ChangePasswordLoading extends AccountSecurityState {}

class ChangePasswordSuccess extends AccountSecurityState {}

class ChangePasswordError extends AccountSecurityState {
  final String message;

  ChangePasswordError(this.message);
}

class DeleteAccountLoading extends AccountSecurityState {}

class DeleteAccountSuccess extends AccountSecurityState {}

class DeleteAccountError extends AccountSecurityState {
  final String message;

  DeleteAccountError(this.message);
}

class EmailVerificationUpdated extends AccountSecurityState {
  final bool verified;

  EmailVerificationUpdated(this.verified);
}