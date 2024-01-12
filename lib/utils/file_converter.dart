import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class FileConverter {
  /// XFile 转换为 File
  static File xFile2File(XFile xFile) {
    return File(xFile.path);
  }

  /// File转换为为MultipartFile
  static Future<MultipartFile> file2MultipartFile(File file) async {
    MultipartFile res =
        MultipartFile.fromBytes(await file.readAsBytes(), filename: file.path);
    MultipartFile res1 =
        await MultipartFile.fromFile(file.path);
    return res1;
  }

  /// XFile转换为为MultipartFile
  static Future<MultipartFile> xFile2MultipartFile(File file) async {
    MultipartFile res =
        MultipartFile.fromBytes(await file.readAsBytes(), filename: file.path);
    return res;
  }
}
