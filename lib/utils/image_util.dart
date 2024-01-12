import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// 图片相关功能
class ImageUtil {
  static var dio = Dio();

  /// 保存URL对应的图片至相册
  static Future<void> saveImageToGallery(String url) async {
    final data = await getNetworkImageData(url, useCache: true);
    if(data == null || data.isEmpty) {
      throw Exception('Failed to get image');
    }
    final result = await ImageGallerySaver.saveImage(data);
    if(result['isSuccess'] == false) {
      throw Exception('Failed to save image');
    }
  }

  /// 通过URL分享图片
  static Future<void> shareImageUrl(String url) async {
    final cacheFile = await getCachedImageFile(url);
    late Uint8List? data;

    if(cacheFile == null) {
      data = await getNetworkImageData(url);
      if(data == null || data.isEmpty) {
        throw Exception('Failed to get image');
      }
    } else {
      data = await cacheFile.readAsBytes();
    }

    final fileName = 'share';
    final extension = Uri.parse(url).pathSegments.last.split('.').last;
    final tempDir = await getTemporaryDirectory();

    final file = await File('${tempDir.path}/shareimage/$fileName.$extension').create(recursive: true);
    await file.writeAsBytes(data);

    Share.shareXFiles([XFile(file.path)], text: 'share content', subject: 'share content');
  }

  /// 通过图片数据分享图片
  static Future<void> shareImageData(Uint8List? data) async {
    if(data == null) {
      throw Exception('Failed to get image');
    }

    final fileName = 'share';
    final tempDir = await getTemporaryDirectory();

    final file = await File('${tempDir.path}/shareimage/$fileName.png').create(recursive: true);
    await file.writeAsBytes(data);

    Share.shareXFiles([XFile(file.path)], text: 'share content', subject: 'share content');
  }
}