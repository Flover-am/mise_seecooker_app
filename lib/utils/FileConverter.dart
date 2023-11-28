import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class FileConverter {
  static Future<File> xFile2File(XFile xFile) async {
    Uint8List bytes = await xFile.readAsBytes();
    return File.fromRawPath(bytes);
  }

  static Future<MultipartFile> file2MultipartFile(File file) async {
    MultipartFile res =
        MultipartFile.fromBytes(await file.readAsBytes(), filename: file.path);
    return res;
  }
  static Future<MultipartFile> xFile2MultipartFile(File file) async {
    MultipartFile res =
    MultipartFile.fromBytes(await file.readAsBytes(), filename: file.path);
    return res;
  }
}
