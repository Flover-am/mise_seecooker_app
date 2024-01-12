import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seecooker/providers/post/community_posts_provider.dart';

import 'package:seecooker/providers/user/user_provider.dart';
import 'package:seecooker/models/http_result.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/services/community_service.dart';


class PublishPostPage extends StatefulWidget {
  final String param;
  const PublishPostPage({super.key,required this.param});

  @override
  State<PublishPostPage> createState() => _PublishPostPageState();
}

class _PublishPostPageState extends State<PublishPostPage> {
  final ImagePicker picker = ImagePicker();

  List<String> _userImage = [];

  /// 用于筛选社团的输入框的控制器
  final TextEditingController _communityFilterInputController = TextEditingController();

  final FocusNode _titleInputFocusNode = FocusNode();

  final TextEditingController _titleInputController = TextEditingController();

  final FocusNode _contentInputFocusNode = FocusNode();

  final TextEditingController _contentInputController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final GlobalKey _textInputKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    var userModel = Provider.of<UserProvider>(context,listen: false);
    // if (!userModel.isLoggedIn) {
    //   // 如果未登录，则导航到LoginPage
    //   WidgetsBinding.instance!.addPostFrameCallback((_) {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context) => const LoginPage()),
    //     );
    //   });
    //   print(userModel.isLoggedIn);
    // }

    _titleInputFocusNode.addListener(() {
      if (_titleInputFocusNode.hasFocus) {
        Scrollable.ensureVisible(_textInputKey.currentContext!, duration: const Duration(milliseconds: 500), curve: Curves.ease);
      }
    });

    _contentInputFocusNode.addListener(() {
      if (_contentInputFocusNode.hasFocus) {
        Scrollable.ensureVisible(_textInputKey.currentContext!, duration: const Duration(milliseconds: 500), curve: Curves.ease);
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('发布'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 56),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                //图片选择区域
                SliverToBoxAdapter(child: _buildImagePicker(context)),
                //文字发布区域
                SliverToBoxAdapter(
                  key: _textInputKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildTitleInput(),
                        Divider(thickness: 1, color: Theme.of(context).colorScheme.primary.withAlpha(20)),
                        _buildContentInput(),
                        Divider(thickness: 1, color: Theme.of(context).colorScheme.primary.withAlpha(20)),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 400),
                )
              ],
            ),
          ),
          // 底部发布按钮
          Positioned(
              bottom: 32,
              left: 16,
              right: 16,
              child: SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: () => _togglePublishButton(context),
                  child: Text('发布帖子', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.surface),),
                ),
              )
          )
        ],
      ),
    );
  }

  /// 点击发布按钮回调
  void _togglePublishButton(BuildContext ctx) async {
    if(_userImage.isEmpty){
      Fluttertoast.showToast(msg: '请至少上传一张图片');
    } else if(_titleInputController.text.isEmpty) {
      Fluttertoast.showToast(msg: '请输入标题');
    } else if(_contentInputController.text.isEmpty) {
      Fluttertoast.showToast(msg: '请输入正文');
    } else {
      Navigator.push(
          ctx,
          MaterialPageRoute(fullscreenDialog: true, builder: (context)=>const LoadingPage(prompt: "正在将帖子上传至总部..."))
      );
      try {
        HttpResult result = await _issuePost();

        // Navigator.pop(ctx);

        if(result.isSuccess()){
          Navigator.pop(ctx);
          Navigator.pop(ctx);
          Fluttertoast.showToast(msg: "发布成功");
          Provider.of<CommunityPostsProvider>(ctx, listen: false).fetchPosts();
        } else {
          throw Exception("发布失败");
        }
      } catch (e) {
        Navigator.pop(ctx);
        Navigator.pop(ctx);
        Fluttertoast.showToast(msg: "$e");
      }
    }
  }

  /// 标题输入框
  Widget _buildTitleInput(){
    return TextField(
      focusNode: _titleInputFocusNode,
      controller: _titleInputController,
      cursorRadius: const Radius.circular(2),
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
      decoration: const InputDecoration(
        hintText: "给帖子加上标题吧 ~",
        border: InputBorder.none,
      ),
    );
  }

  /// 内容输入框
  Widget _buildContentInput(){
    return Scrollbar(
      child: SingleChildScrollView(
        child: TextField(
          maxLines: 7,
          maxLength: 1000,
          focusNode: _contentInputFocusNode,
          controller: _contentInputController,
          style: Theme.of(context).textTheme.bodyLarge,
          cursorRadius: const Radius.circular(2),
          decoration: const InputDecoration(
            hintText: "添加正文",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  /// 图片选择区组件
  Widget _buildImagePicker(BuildContext context){
    return Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: min(_userImage.length + 1, 9),
          shrinkWrap: true,
          itemBuilder: (context,index) {
            return Card(
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.zero,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                child: InkWell(
                    onTap:(){
                      if(index==_userImage.length){//添加图片按钮的点击逻辑
                        _selectImageSource(context);
                      }else{//图片的点击逻辑
                        _showDetailedImage(context, _userImage[index], index);
                      }
                    },
                    child: Hero(
                        tag:'showDetailImage$index',
                        child: (index < _userImage.length)
                        //图片组件：返回对应图片的缩略图
                            ? Image.file(File(_userImage[index]), fit: BoxFit.cover)
                        //添加图片按钮：返回添加图片的组件
                            : _buildImageAdder()
                    )
                )
            );
          },
        )
    );
  }

  /// 方法：显示图片详情
  /// context:上下文 path:图片路径 index:图片在列表中的索引
  void _showDetailedImage(BuildContext context,String path,int index){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) {
              return DetailImagePage(
                  path: path,
                  index: index,
                  onDelete:() {
                    setState(() {
                      _userImage.removeAt(index);
                    });
                  }
              );
            }
        ));
  }

  /// 图片添加占位
  Widget _buildImageAdder(){
    return GestureDetector(
        onTap:(){
          _selectImageSource(context);
        },
        child: const Icon(Icons.add_rounded)
    );

  }

  /// 从相册或相机获取图片
  void _selectImageSource(BuildContext ctx){
    showModalBottomSheet(
        context: ctx,
        elevation: 0,
        showDragHandle: true,
        builder: (BuildContext context) {
          return Container(
              height: 200,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                        ),
                        leading: const Icon(Icons.image_outlined),
                        title: Text('相册', style: Theme.of(context).textTheme.titleMedium),
                        onTap:(){
                          _pickMultipleImages();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Divider(thickness: 1, color: Theme.of(context).colorScheme.primary.withAlpha(20)),
                  SizedBox(
                      height: 60,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child:ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            leading: const Icon(Icons.camera_alt_outlined),
                            title: Text('拍摄', style: Theme.of(context).textTheme.titleMedium),
                            onTap:(){
                              _pickImageFromCamera();
                              Navigator.pop(context);
                            },
                          )
                      )
                  ),
                ],
              )
          );
        }
    );
  }

  /// 从相册选择多张图片
  Future<void> _pickMultipleImages() async{
    try{
      List<XFile> pickedFile = await picker.pickMultiImage(
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 90
      );
      setState(() {
        for(var i = 0;i < pickedFile.length;i++){
          _userImage.add(pickedFile[i].path);
        }
        if(_userImage.length > 9){
          _userImage=_userImage.sublist(0,9);
          Fluttertoast.showToast(msg: "最多选择9张图片。");
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  /// 从相机获取单张图片
  Future<void> _pickImageFromCamera() async{
    try {
      XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 90
      );
      if(pickedFile!=null){
        setState(() {
          _userImage.add(pickedFile.path);
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  /// 发布
  Future<HttpResult> _issuePost() async{
    try {
      return CommunityService.publishPost(_titleInputController.text, _contentInputController.text, _userImage);
    } catch (e) {
      return HttpResult(200001, e.toString(), null);
    }
  }
}

/// 加载页
class LoadingPage extends StatelessWidget{
  final String prompt;
  const LoadingPage({super.key, required this.prompt});
  @override
  Widget build(BuildContext context){
    return Scaffold(
        body:Material(
          color:Colors.grey.withOpacity(0.72),
          child:Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(

                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child:Text(prompt,style: TextStyle(color: Colors.white),),
                  )
                ],
              )
          ),
        )
    );
  }
}

/// 图片详情页
class DetailImagePage extends StatelessWidget{

  final String path;
  final int index;
  final void Function() onDelete;

  const DetailImagePage({super.key, required this.path, required this.index, required this.onDelete});

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body:
        Material(
            color: Theme.of(context).colorScheme.background,
            child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height - 200
                        ),
                        child: Hero(
                            tag:'showDetailImage$index',
                            child: Image.file(
                              File(path),
                              fit: BoxFit.contain,
                              width: MediaQuery.of(context).size.width,
                            )
                        ),
                      ),
                      const SizedBox(height: 16),
                      ActionChip(
                        label: const Text('删除图片'),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    elevation: 0,
                                    title: const Text('是否删除图片'),
                                    content: const Text('这将从已选图片中删除该图片。'),
                                    actions:<Widget>[
                                      // TODO: 修改按钮样式
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('取消'),
                                      ),
                                      TextButton(
                                        onPressed: (){
                                          onDelete();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('确认'),
                                      )
                                    ]
                                );
                              }
                          );
                        },
                      ),
                    ]
                )
            )
        )
    );
  }
}