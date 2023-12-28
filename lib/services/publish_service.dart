import 'package:dio/dio.dart';
import 'package:seecooker/models/http_result.dart';
import 'package:seecooker/utils/sa_token_util.dart';
import 'package:seecooker/utils/server_url_util.dart';

import 'package:seecooker/utils/shared_preferences_util.dart';

class PublishService{
  static const String baseUrl = ServerUrlUtil.baseUrl;//TODO:改为正式部署环境url
  static Dio dio=Dio();

  static Future<HttpResult> publishPost(String title, String content, List<String> filePath) async {
    String tokenName = await SaTokenUtil.getTokenName();
    String tokenValue = await SaTokenUtil.getTokenValue();

    BaseOptions publishOptions=BaseOptions(
        baseUrl: baseUrl,
        headers:{
          tokenName: tokenValue
        }
    );
    dio.options=publishOptions;

    //构建FormData
    final FormData formData =FormData.fromMap(
        {
          'title': title,
          'content': content
        }
    );

    for(String singleFilePath in filePath){
      MultipartFile multipartFile = await MultipartFile.fromFile(singleFilePath, filename: singleFilePath.split('/').last);
      formData.files.add(MapEntry("images",multipartFile));
    }

    //发送请求并等待回复
    final response = await dio.post(
        '/post',
        data: formData
    );

    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('网络错误: ${response.statusCode}');
    }
  }
}