import 'package:dio/dio.dart';
import 'package:seecooker/models/http_result.dart';

const String tokenType='satoken';

class PublishService{
  static const String baseUrl ='https://mock.apifox.com/m1/3614939-0-default';//TODO:改为正式部署环境url
  static Dio dio=Dio();

  static Future<HttpResult> publishPost(String token,String title,String content,List<String> filePath)async{
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