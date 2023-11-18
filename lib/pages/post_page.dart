import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostPage extends StatefulWidget {
  final String param;

  const PostPage({super.key, required this.param});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  var text = 'post';
  var hasCover = false;

  final titleController = TextEditingController();
  final summaryController = TextEditingController();

  static const imageUrlTmp =
      "https://iknow-pic.cdn.bcebos.com/79f0f736afc3793104af684afbc4b74542a91189?x-bce-process=image%2Fresize%2Cm_lfit%2Cw_600%2Ch_800%2Climit_1%2Fquality%2Cq_85%2Fformat%2Cf_auto";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('post'),
      ),
      body: ListView(
        // 整个页面
        children: [
          _buildCover(hasCover),
          TextField(
            obscureText: true,
            controller: titleController,
            decoration: const InputDecoration(
              labelText: '标题',
              // TODO: 修改样式
            ),
          ),
          TextField(
            obscureText: true,
            controller: summaryController,
            decoration: const InputDecoration(
              labelText: '简介',
              // TODO: 修改样式
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCover(hasCover) {
    return Container(
      child: GestureDetector(
          onTap: () {
            Fluttertoast.showToast(msg: "//TODO: 跳转到相册添加图片");
          },
          child: Container(
            height: 200,
            color: const Color.fromARGB(0xFF, 0xF6, 0xF6, 0xF6),
            child: Center(
              child: hasCover
                  ? Image.network(imageUrlTmp)
                  : const Text(
                      "+ 添加你的美食封面 ～",
                      style: TextStyle(color: Color(0xFF909090)),
                    ),
            ),
          )),
    );
  }
}
