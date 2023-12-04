import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  SharedPreferencesUtil._internal();
  factory SharedPreferencesUtil() => _instance;
  static final _instance = SharedPreferencesUtil._internal();

  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<bool> setString(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(key, value);
  }

  static Future<String> getString(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key) ?? '';
  }

  static Future<bool> setInt(String key, int value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setInt(key, value);
  }

  static Future<int> getInt(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(key) ?? 0;
  }

  static Future<bool> setBool(String key, bool value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setBool(key, value);
  }

  static Future<bool> getBool(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(key) ?? false;
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setStringList(key, value);
  }

  static Future<List<String>> getStringList(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getStringList(key) ?? [];
  }

  static Future<bool> remove(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.remove(key);
  }

  static Future<bool> clear() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.clear();
  }
}