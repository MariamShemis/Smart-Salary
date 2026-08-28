import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

class GoogleDriveService {
  // static String _generateBackupFileName() {
  //   final now = DateTime.now();
  //   final timestamp = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
  //   return "smart_salary_backup_$timestamp.json";
  // }
  static const String backupFileName = "smart_salary_backup.json";

  static Future<void> uploadBackup(Map<String, dynamic> data) async {
    final googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        DriveApi.driveFileScope,
      ],
    );

    var account = await googleSignIn.signIn();

    if (account == null) {
      throw Exception("Google sign in cancelled");
    }

    await _linkGoogleCredentialToFirebase(account);

    final client = await googleSignIn.authenticatedClient();

    if (client == null) {
      throw Exception("Google authentication failed");
    }

    final drive = DriveApi(client);
    final jsonData = jsonEncode(_convertData(data));
    final bytes = utf8.encode(jsonData);
    final media = Media(Stream.value(bytes), bytes.length);

    final existing = await drive.files.list(
      q: "name = '$backupFileName' and trashed = false",
      pageSize: 1,
    );

    if (existing.files != null && existing.files!.isNotEmpty) {
      final fileId = existing.files!.first.id!;

      await drive.files.update(
        File(),
        fileId,
        uploadMedia: media,
      );
    } else {
      final newFile = File()
        ..name = backupFileName
        ..mimeType = "application/json";

      await drive.files.create(
        newFile,
        uploadMedia: media,
      );
    }
  }

  static Future<bool> uploadBackupSilently(Map<String, dynamic> data) async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: ['email', DriveApi.driveFileScope],
      );

      var account = googleSignIn.currentUser;
      account ??= await googleSignIn.signInSilently();

      if (account == null) {
        print("AUTO BACKUP SKIPPED: No signed in Google Account");
        return false;
      }

      final client = await googleSignIn.authenticatedClient();
      if (client == null) return false;

      final drive = DriveApi(client);
      final jsonData = jsonEncode(_convertData(data));
      final bytes = utf8.encode(jsonData);
      final media = Media(Stream.value(bytes), bytes.length);

      final existing = await drive.files.list(
        q: "name = '$backupFileName' and trashed = false",
        pageSize: 1,
      );

      if (existing.files != null && existing.files!.isNotEmpty) {
        final fileId = existing.files!.first.id!;

        await drive.files.update(
          File(),
          fileId,
          uploadMedia: media,
        );
      } else {
        final newFile = File()
          ..name = backupFileName
          ..mimeType = "application/json";

        await drive.files.create(
          newFile,
          uploadMedia: media,
        );
      }

      return true;
    } catch (e) {
      print("AUTO BACKUP SILENT ERROR: $e");
      return false;
    }
  }
  static Future<void> _linkGoogleCredentialToFirebase(GoogleSignInAccount googleUser) async {
    try {
      final googleAuth = await googleUser.authentication;
      final credential = fb_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final currentUser = fb_auth.FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final isAlreadyGoogle = currentUser.providerData
            .any((element) => element.providerId == 'google.com');

        if (!isAlreadyGoogle) {
          await currentUser.linkWithCredential(credential);
          await currentUser.reload();
        }
      }
    } catch (e) {
      print("Link Credential Note / Error: $e");
    }
  }

  static Future<Map<String, dynamic>?> downloadLatestBackup() async {
    final googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        DriveApi.driveFileScope,
      ],
    );

    var account = await googleSignIn.signIn();

    if (account == null) {
      throw Exception("Google sign in cancelled");
    }

    await _linkGoogleCredentialToFirebase(account);

    final client = await googleSignIn.authenticatedClient();

    if (client == null) {
      throw Exception("Google authentication failed");
    }

    final drive = DriveApi(client);

    final fileList = await drive.files.list(
      q: "name contains 'smart_salary_backup' and trashed = false",
      orderBy: "modifiedTime desc",
      pageSize: 1,
    );

    if (fileList.files == null || fileList.files!.isEmpty) {
      throw Exception("No backup found on Google Drive");
    }

    final fileId = fileList.files!.first.id!;

    final media = await drive.files.get(
      fileId,
      downloadOptions: DownloadOptions.fullMedia,
    ) as Media;

    final List<int> dataBytes = [];
    await for (final data in media.stream) {
      dataBytes.addAll(data);
    }

    final jsonString = utf8.decode(dataBytes);
    final Map<String, dynamic> backupData = jsonDecode(jsonString);

    return backupData;
  }

  static dynamic _convertData(dynamic value) {
    if (value is Timestamp) {
      return value.toDate().toIso8601String();
    }

    if (value is Map) {
      return value.map((key, val) => MapEntry(key, _convertData(val)));
    }

    if (value is List) {
      return value.map((e) => _convertData(e)).toList();
    }

    return value;
  }
}