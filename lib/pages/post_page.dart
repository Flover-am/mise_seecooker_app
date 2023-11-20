import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/models/user_model.dart';
import 'package:seecooker/pages/login_page.dart';

class PostPage extends StatefulWidget {
  final String param;

  const PostPage({super.key, required this.param});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  var text = 'post';

  @override
  Widget build(BuildContext context) {
    var userModel = Provider.of<UserModel>(context,listen: false);

    // 检查用户是否已登录
    if (!userModel.isLoggedIn) {
      // 如果未登录，则导航到LoginPage
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
      print(userModel.isLoggedIn);
      //Navigator.pop(context);
    }
    return Scaffold(
      appBar: AppBar(
        title:
          Consumer<UserModel>(
          builder: (context, user, child) => Stack(
            children: [
              Text('${user.username} post'),
            ],
          ),
        )
      ),
      body: Center(
        child: Text(text),
      ),
    );
  }
}