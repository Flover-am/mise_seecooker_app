
import 'package:json_annotation/json_annotation.dart';
part 'http_result.g.dart';

@JsonSerializable()
/// 网络请求返回值封装类
class HttpResult{
  /// 业务状态Code:
    /// 成功：0
  late int code;
  /// 业务返回信息，当code不为0时，message返回错误信息
  late String message;
  /// 返回数据类
  late dynamic data;

  /// 构造函数
  HttpResult(this.code, this.message, this.data);
  factory HttpResult.fromJson(Map<String, dynamic> json) => _$HttpResultFromJson(json);
  Map<String, dynamic> toJson() => _$HttpResultToJson(this);

  /// 判断此次请求是否成功
  bool isSuccess(){
    return code==0&&message=="success";
  }
}