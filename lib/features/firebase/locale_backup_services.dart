import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class LocalBackupService {
  static Future<bool> createLocalBackup(Map<String, dynamic> data) async {
    try {
      final jsonString = jsonEncode(_convertData(data));
      final List<int> bytes = utf8.encode(jsonString);
      final fileName = 'smart_salary_backup_${DateTime.now().millisecondsSinceEpoch}.json';

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup File',
        fileName: fileName,
        bytes: Uint8List.fromList(bytes),
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (outputFile == null) {
        return false;
      }
      final file = File(outputFile);
      if (!await file.exists()) {
        await file.writeAsString(jsonString);
      }

      return true;
    } catch (e) {
      print("CREATE LOCAL BACKUP ERROR: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>?> restoreLocalBackup() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.single.path == null) {
        return null;
      }

      final filePath = result.files.single.path!;

      if (!filePath.endsWith('.json')) {
        throw Exception("Invalid file format. Please select a JSON backup file.");
      }

      final file = File(filePath);
      final jsonString = await file.readAsString();
      final decodedData = jsonDecode(jsonString);

      if (decodedData is Map<String, dynamic>) {
        return decodedData;
      } else {
        throw Exception("Invalid backup data format.");
      }
    } catch (e) {
      print("RESTORE LOCAL BACKUP ERROR: $e");
      rethrow;
    }
  }

  static dynamic _convertData(dynamic value) {
    if (value is Timestamp) {
      return value.toDate().toIso8601String();
    }
    if (value is DateTime) {
      return value.toIso8601String();
    }
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), _convertData(val)));
    }
    if (value is List) {
      return value.map((e) => _convertData(e)).toList();
    }
    return value;
  }
}