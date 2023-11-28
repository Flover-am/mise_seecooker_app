import 'dart:io';
import 'package:dio/dio.dart';
import 'package:seecooker/utils/FileConverter.dart';


class NewRecipe {
  /// 封面
  late File cover;

  /// 标题
  late String name;

  /// 简介
  late String introduction;

  /// 每一步的图片

  List<File> stepImages = [];

  /// 每一步的内容
  List<String> stepContents = [];

  /// 配料
  List<Map<String, String>> ingredients = [];

  NewRecipe();

  NewRecipe.all(this.cover, this.name, this.introduction, this.stepImages,
      this.stepContents, this.ingredients);

  FormData toFormData() {
    FormData formData = FormData.fromMap({
      'name': name,
      'introduction': introduction,
      'stepContents': stepContents,
      'cover': FileConverter.file2MultipartFile(cover),
      'stepImages': stepImages.map((e) => FileConverter.file2MultipartFile(e)),
    });
    return formData;
  }
}