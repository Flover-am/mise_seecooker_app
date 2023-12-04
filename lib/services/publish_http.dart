import 'package:http/http.dart' as http;

final String apiUrl = 'https://a5eb-202-119-41-55.ngrok-free.app/v1/post';

Future<void> sendFormDataRequest(String apiUrl,String title,String content, List<String> filePath,var success,var fail,var err) async {
  var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

  // 添加文本字段
  request.fields['title'] = title;
  request.fields['content'] = content;

  // 添加文件字段
  for(var path in filePath){
    var file = await http.MultipartFile.fromPath('fileField', path);
    request.files.add(file);
  }

  try {
    // 发送请求
    var response = await http.Response.fromStream(await request.send());

    // 处理响应
    if (response.statusCode == 200) {
      success(response.body);
    } else {
      fail(response.body);
    }
  } catch (error) {
    err(error);
  }
}