import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:seecooker/models/comment.dart';

class CommentService {
  // TODO: set base url
  static const String baseUrl = '';

  static Future<List<Comment>> getComments(int postId) async {
    // final response = await http.get(Uri.parse('$baseUrl/comments/$postId'));
    // if(response.statusCode == 200) {
    //   return (jsonDecode(response.body) as List)
    //       .map((e) => Comment.fromJson(e))
    //       .toList();
    // } else {
    //   throw Exception('Failed to get comments');
    // }
    await Future.delayed(const Duration(seconds: 1));
    return [
      Comment('111', '2023-2-11', 'content', 'https://picsum.photos/210'),
      Comment('111', '2023-2-11', 'content', 'https://picsum.photos/190'),
    ];
  }

  static Future<void> postComment(int commenterId, int postId, String content) async {
    // final response = await http.post(
    //   Uri.parse('$baseUrl/comments'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //     body: jsonEncode(<String, dynamic>{
    //       'commenterId': commenterId,
    //       'postId': postId,
    //       'content': content
    //     })
    // );
    // if(response.statusCode != 200) {
    //   throw Exception('Failed to post comment');
    // }
    await Future.delayed(const Duration(seconds: 2));
  }
}