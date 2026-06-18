class Regex {
  static String? validateUsername(String? val) {
    RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9,.-]+$');
    if (val == null) {
      return 'this field is required';
    } else if (val.isEmpty) {
      return 'this field is required';
    } else if (!usernameRegex.hasMatch(val)) {
      return 'enter valid username';
    } else {
      return null;
    }
  }

static String? validatePhoneNumber(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'this field is required';
    }
    String trimmed = val.trim();
    if (trimmed.startsWith('+20')) {
      trimmed = trimmed.substring(3);
    }
    if (int.tryParse(trimmed) == null) {
      return 'enter numbers only';
    }
    if (trimmed.length != 10) {
      return 'enter value must be 11 digit including country code or 10 without it';
    }
    return null;
  }
  static String? validatePassword(String? val) {
    RegExp passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])');
    if (val == null) {
      return 'this field is required';
    } else if (val.isEmpty) {
      return 'this field is required';
    } else if (val.length < 8 || !passwordRegex.hasMatch(val)) {
      return 'strong password please';
    } else {
      return null;
    }
  }
}