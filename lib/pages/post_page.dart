import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/models/user_model.dart';

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