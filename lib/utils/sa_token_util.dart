import 'package:seecooker/utils/shared_preferences_util.dart';

/// SaToken相关功能
class SaTokenUtil {
  SaTokenUtil._internal();
  factory SaTokenUtil() => _instance;
  static final _instance = SaTokenUtil._internal();

  static Future<String> _tokenName = SharedPreferencesUtil.getString("tokenName");

  static Future<String> _tokenValue = SharedPreferencesUtil.getString("tokenValue");

  static Future<String> getTokenName() async {
    final tokenName = await _tokenName;
    if (tokenName.isEmpty) {
      throw Exception('请登录');
    }
    return tokenName;
  }

  static Future<String> getTokenValue() async {
    final tokenValue = await _tokenValue;
    if (tokenValue.isEmpty) {
      throw Exception('请登录');
    }
    return tokenValue;
  }

  static Future<void> refreshToken() async {
    _tokenName = SharedPreferencesUtil.getString("tokenName");
    _tokenValue = SharedPreferencesUtil.getString("tokenValue");
  }
}