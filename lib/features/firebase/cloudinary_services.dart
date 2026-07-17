import 'dart:io';

import 'package:dio/dio.dart';

class CloudinaryServices {
  static const String cloudName = "kyl67cpo";
  static const String uploadPreset = "profile_images";

  static Future<String> uploadImage(File image) async {
    final dio = Dio();

    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(image.path),
      "upload_preset": uploadPreset,
    });

    final response = await dio.post(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      data: formData,
    );

    return response.data["secure_url"];
  }
}