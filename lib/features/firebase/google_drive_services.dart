import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

class GoogleDriveService {
  static const String _backupFileName = "smart_salary_backup.json";

  static Future<void> uploadBackup(Map<String, dynamic> data) async {
    final googleSignIn = GoogleSignIn(scopes: [DriveApi.driveFileScope]);

    var account = await googleSignIn.signIn();

    if (account == null) {
      throw Exception("Google sign in cancelled");
    }

    final client = await googleSignIn.authenticatedClient();

    if (client == null) {
      throw Exception("Google authentication failed");
    }

    final drive = DriveApi(client);
    final jsonData = jsonEncode(_convertData(data));
    final bytes = utf8.encode(jsonData);
    final media = Media(Stream.value(bytes), bytes.length);

    final fileList = await drive.files.list(
      q: "name = '$_backupFileName' and trashed = false",
      pageSize: 1,
    );

    if (fileList.files != null && fileList.files!.isNotEmpty) {

      final fileId = fileList.files!.first.id!;
      final fileToUpdate = File()..name = _backupFileName;
      await drive.files.update(fileToUpdate, fileId, uploadMedia: media);
    } else {

      final newFile = File()
        ..name = _backupFileName
        ..mimeType = "application/json";
      await drive.files.create(newFile, uploadMedia: media);
    }
  }

  static Future<Map<String, dynamic>?> downloadLatestBackup() async {
    final googleSignIn = GoogleSignIn(scopes: [DriveApi.driveFileScope]);

    var account = await googleSignIn.signIn();

    if (account == null) {
      throw Exception("Google sign in cancelled");
    }

    final client = await googleSignIn.authenticatedClient();

    if (client == null) {
      throw Exception("Google authentication failed");
    }

    final drive = DriveApi(client);

    final fileList = await drive.files.list(
      q: "name = '$_backupFileName' and trashed = false",
      orderBy: "createdTime desc",
      pageSize: 1,
    );

    if (fileList.files == null || fileList.files!.isEmpty) {
      throw Exception("لم يتم العثور على نسخة احتياطية على Google Drive");
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