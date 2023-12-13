import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:seecooker/providers/user_provider.dart';
import 'package:seecooker/services/publish_service.dart';
import 'package:seecooker/models/http_result.dart';
import 'package:seecooker/pages/account/login_page.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class PublishPost extends StatefulWidget {
  final String param;
  const PublishPost({super.key,required this.param});

  @override
  State<PublishPost> createState() => _PublishPostState();
}

class _PublishPostState extends State<PublishPost> {
  final ImagePicker picker = ImagePicker();
  List<String> _userImage = [];
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
        title: const Text('帖子发布'),
      ),
      body: Stack(
        children: [
          CustomScrollView(
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
                      Divider(thickness: 1, color: Theme.of(context).colorScheme.primary.withAlpha(10)),
                      _buildContentInput(),
                      Divider(thickness: 1, color: Theme.of(context).colorScheme.primary.withAlpha(10)),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 400),
              )
            ],
          ),
          // 底部发布按钮
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 16,
            left: 16,
            right: 16,
            child: SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: _togglePublishButton,
                child: Text('发布帖子', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.surface),),
              ),
            )
          )
        ],
      ),
    );
  }

  /// 点击发布按钮回调
  void _togglePublishButton() async {
    if(_userImage.isEmpty){
      Fluttertoast.showToast(msg: '请至少上传一张图片');
    } else if(_titleInputController.text.isEmpty) {
      Fluttertoast.showToast(msg: '请输入标题');
    } else if(_contentInputController.text.isEmpty) {
      Fluttertoast.showToast(msg: '请输入正文');
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>const LoadingPage(prompt: "正在将帖子上传至总部..."))
      );
      HttpResult result = await _issuePost();

      Navigator.pop(context);

      if(result.message=="success"){
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "发布成功！",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.green,
            fontSize: 16.0
        );
      }else{
        AlertDialog(
            title: const Text('上传失败！'),
            content:Text(result.message),
            actions:<Widget>[
              TextButton(
                child: const Text('确认'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ]
        );
      }
    }
  }

  /// 标题输入框
  Widget _buildTitleInput(){
    return TextField(
      focusNode: _titleInputFocusNode,
      controller: _titleInputController,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
      decoration: const InputDecoration(
        hintText: "给帖子加上标题吧 ~",
        border: InputBorder.none,
      ),
    );
  }

  /// 内容输入框
  Widget _buildContentInput(){
    // TODO: fix scroll bar hide bug
    return Scrollbar(
      child: SingleChildScrollView(
        child: TextField(
          maxLines: 10,
          focusNode: _contentInputFocusNode,
          controller: _contentInputController,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: const InputDecoration(
            hintText: "添加正文",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  /// 返回图片选择区组件
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
          // TODO: border
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
                  pictureSource(context);
                }else{//图片的点击逻辑
                  _showDetailedImage(context,_userImage[index],index);
                }
              },
              onLongPress: () {
                // 删除
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
    Navigator.push(context,MaterialPageRoute(
      builder:(context)=>DetailImagePage(path:path,index:index,deletionCallback:(){
        setState(() {
          _userImage.removeAt(index);
        });
      })
    ));
  }

  /// 图片添加占位
  Widget _buildImageAdder(){
    return GestureDetector(
      onTap:(){
        pictureSource(context);
      },
      child: const Icon(Icons.add_rounded)
    );

  }

  /// 从相册或相机获取图片
  void pictureSource(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (BuildContext context){
      return Container(
        height: 120,
        child:Wrap(
          children: <Widget>[
            SizedBox(
              height: 60,
              child:Align(
                alignment: Alignment.centerLeft,
                child:ListTile(
                  title: const Text('相册'),
                  onTap:(){
                    _pickMultipleImages();
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            SizedBox(
                height: 60,
                child:Align(
                  alignment: Alignment.centerLeft,
                    child:ListTile(
                      title: const Text('相机'),
                      onTap:(){
                        _pickImageFromCamera();
                        Navigator.pop(context);
                      },
                    )
                )
            )

          ],
        )
      );
    });
  }

  /// 从相册选择多张图片
  Future<void> _pickMultipleImages() async{
    try{
      List<XFile> pickedFile = await picker.pickMultiImage();
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
      XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
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
        return PublishService.publishPost(_titleInputController.text, _contentInputController.text, _userImage);
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
  final deletionCallback;

  DetailImagePage({required this.path,required this.index,required this.deletionCallback});
  @override
  Widget build(BuildContext context){
    void callBack(){
      deletionCallback();
      Navigator.of(context).pop();
    };
    return Scaffold(
      body:
        Material(
        color:Colors.black,
        child:InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
            child:SafeArea(
              child:Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Hero(
                              tag:'showDetailImage$index',
                              child:Image.file(
                                File(path),
                                fit: BoxFit.contain,
                                width: MediaQuery.of(context).size.width,
                              )
                          ),
                        ]
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                      child: ElevatedButton(
                          child: const Icon(Icons.delete),
                          onPressed: (){
                            showDialog<String>(
                                context:context,
                                builder: (context){
                                  return AlertDialog(
                                      title: const Text('确认删除图片？'),
                                      content:const Text('这将从已选图片中删除该图片。'),
                                      actions:<Widget>[
                                        TextButton(
                                          child: const Text('取消'),
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('确认'),
                                          onPressed: (){
                                            callBack();
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ]);
                                }
                            );
                          }
                      ),
                    )
                  ]
              )
            )
        )
    )
    );
  }
}
