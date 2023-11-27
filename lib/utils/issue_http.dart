import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient(this.baseUrl);

  Future<void> get(String path, Function(dynamic) onSuccess, Function(String) onError) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$path'));
      handleResponse(response, onSuccess, onError);
    } catch (error) {
      onError('Error: $error');
    }
  }

  Future<void> post(String path, Map<String, dynamic> body, Function(dynamic) onSuccess, Function(String) onError) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      handleResponse(response, onSuccess, onError);
    } catch (error) {
      onError('Error: $error');
    }
  }

  void handleResponse(http.Response response, Function(dynamic) onSuccess, Function(String) onError) {
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      onSuccess(jsonResponse);
    } else {
      onError('Request failed with status: ${response.statusCode}');
    }
  }
}