import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:seecooker/models/post.dart';
import 'package:seecooker/models/post_detail.dart';

class PostService {
  // TODO: set base url
  static const String baseUrl = '';

  static Future<List<Post>> getPosts() async {
    // final response = await http.get(Uri.parse('$baseUrl/posts'));
    // if(response.statusCode == 200) {
    //   return (jsonDecode(response.body) as List)
    //     .map((e) => Post.fromJson(e))
    //     .toList();
    // } else {
    //   throw Exception('Failed to get posts');
    // }
    await Future.delayed(const Duration(seconds: 2));
    return (List.generate(
        5,
            (index) => Post(
            index,
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
            'author$index',
            'title$index',
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'
        )
    ));
  }

  static Future<PostDetail> getPostDetail(int postId) async {
    // final response = await http.get(Uri.parse('$baseUrl/post/$postId'));
    // if(response.statusCode == 200) {
    //   return PostDetail.fromJson(jsonEncode(response.body) as Map<String, dynamic>);
    // } else {
    //   throw Exception('Failed to get post detail');
    // }
    await Future.delayed(const Duration(seconds: 2));
    return PostDetail(
        '标题$postId',
        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
        '作者$postId',
        '内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容$postId',
        ['https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'
        ],
        5
    );
  }
}