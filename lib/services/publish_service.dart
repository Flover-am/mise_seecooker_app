import 'package:dio/dio.dart';
import 'package:seecooker/models/http_result.dart';

import 'package:seecooker/utils/shared_preferences_util.dart';

class PublishService{
  static const String baseUrl ='http://124.222.18.205:8080/v1';//TODO:改为正式部署环境url
  static Dio dio=Dio();

  static Future<HttpResult> publishPost(String title,String content,List<String> filePath)async{

    String tokenType=await SharedPreferencesUtil.getString("tokenName");
    String token=await SharedPreferencesUtil.getString("tokenValue");

    if(tokenType==null||token==null||tokenType.isEmpty||token.isEmpty){
      throw Exception("未登录");
    }

    BaseOptions publishOptions=BaseOptions(
      baseUrl: baseUrl,
      headers:{
        tokenType:token
      }
    );
    dio.options=publishOptions;

    //构建FormData
    final FormData formData =FormData.fromMap(
      {
        'title':title,
        'content':content,
      }
    );
    for(String singleFilePath in filePath){
      MultipartFile multipartFile=await MultipartFile.fromFile(singleFilePath,filename:singleFilePath.split('/').last);
      formData.files.add(MapEntry("images",multipartFile));
    }
    //发送请求并等待回复
    final response=await dio.post(
      '/post',
      data:formData
    );

    HttpResult result=HttpResult.fromJson(response.data);
    return result;
  }
}