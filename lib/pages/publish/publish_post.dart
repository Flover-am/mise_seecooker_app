import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:seecooker/providers/user_provider.dart';
import 'package:seecooker/services/publish_http.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


import '../../models/user.dart';
import '../account/login_page.dart';

class PublishPost extends StatefulWidget {
  final String param;
  const PublishPost({super.key,required this.param});

  @override
  State<PublishPost> createState() => _PublishPostState();
}

class _PublishPostState extends State<PublishPost> {
  String title='';
  String text='';
  final ImagePicker picker = ImagePicker();
  List<String> _userImage=[];//存放获取到的本地路径
  bool _issueButtonVisible=true;
  String? _errorInputMessage=null;


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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('帖子发布'),
      ),
      body: ListView(
            padding:const EdgeInsets.fromLTRB(8, 8, 8, 8),
            shrinkWrap: true,
            children: <Widget>[
              TitleInput(),
              Divider(
                  thickness: 1,
                  color: Theme.of(context).colorScheme.primary.withAlpha(10)),
              //图片选择区域
              ImageSelection(context),

              Divider(
                  thickness: 1,
                  color: Theme.of(context).colorScheme.primary.withAlpha(10)),
              //文字发布区域
              IssueText(),
            ],
          ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
          _issueButtonVisible
              ?
            SafeArea(
            child:Align(
              alignment: Alignment.bottomCenter,
              child:
              SizedBox(
                width:200,
                child:FloatingActionButton(
                  onPressed: () {
                    if(_userImage.isEmpty){
                      showDialog<String>(
                          context:context,
                          builder: (context){
                            return AlertDialog(
                                title: const Text('未上传图片！'),
                                content:const Text('请至少上传一张图片。'),
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
                      );
                    }
                    else if(text.isEmpty){
                      showDialog<String>(
                          context:context,
                          builder: (context){
                            return AlertDialog(
                                title: const Text('帖子内容为空！'),
                                content:const Text('请输入需要发布的帖子内容。'),
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
                      );
                      setState(() {
                        _errorInputMessage='输入不能为空';
                      });
                    }
                    else{
                      _issuePost();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("发布"),
                ),
              )
            )
          )
              :
              null
    );
  }

  double _safeAreaWidth(double? width,double? height){
    if(width==null||height==null){
      return 0;
    }
    if(width/height>9/16){
      return height*9/16;
    }
    return width;
  }

  /// 返回标题输入区组件
  Widget TitleInput(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
        const Text('标题',style: TextStyle(fontSize: 16)),//TODO:更改样式
        Padding(
          padding: const EdgeInsets.fromLTRB(16,8,16,8),
          child:Focus(
            onFocusChange:(hasFocus){
              setState(() {
                _issueButtonVisible=!hasFocus;
              });
            },
            child: TextField(
              decoration: const InputDecoration(
                labelText: '输入标题(可选)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onChanged: (text){
                this.title=text;
              },
              maxLines: null,
              minLines:1,
              maxLength: 25,
          ),
          )
        )
      ]
    );
  }

  /// 返回图片选择区组件
  Widget ImageSelection(BuildContext context){
    final width=_safeAreaWidth(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return SizedBox(
          width: width,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children:[
              const Text('图片选择',style: TextStyle(fontSize: 16)),//TODO:更改样式

              Padding(
                  padding: const EdgeInsets.fromLTRB(16,16,16,16),
                  child:GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: _userImage.length<9?_userImage.length+1:9,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return
                          Card(
                            clipBehavior: Clip.hardEdge,
                            child:InkWell(
                              splashColor: Colors.blue.withAlpha(30),//TODO：更改主题颜色
                              onTap:(){
                                if(index==_userImage.length){//添加图片按钮的点击逻辑
                                  PictureSource(context);
                                }else{//图片的点击逻辑
                                  _showDetailedImage(context,_userImage[index],index);
                                }
                              },
                              child:Hero(
                                  tag:'showDetailImage$index',
                                  child:Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children:
                                      (index<_userImage.length)
                                          ?
                                      <Widget>[//图片组件：返回对应图片的缩略图
                                        Expanded(
                                            child:
                                            Image.file(File(_userImage[index]), fit: BoxFit.cover)
                                        ),
                                      ]
                                          :
                                      <Widget>[//添加图片按钮：返回添加图片的组件
                                        PictureAdder()
                                      ]
                                  )
                              )
                            )

                          );
                    },
                  )
              )
            ]
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
  Widget PictureAdder(){

    return GestureDetector(
      onTap:(){
        PictureSource(context);
      },
      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child:Center(
          child:Image.asset('assets/images/add.png'),
        )
      )
    );

  }
  /// 返回文字发布区组件
  Widget IssueText(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10,8,10,8),
      child:SingleChildScrollView(
        child:Container(
          height:200,
          padding: const EdgeInsets.fromLTRB(8,8,8,8),
          child:Focus(
            onFocusChange:(hasFocus){
              setState(() {
                _issueButtonVisible=!hasFocus;
              });
            },
            child:TextField(
              decoration: InputDecoration(
                labelText: '请输入发布内容',
                errorText: _errorInputMessage,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onChanged: (text){
                this.text=text;
                if(text.isEmpty){
                  setState(() {
                    _errorInputMessage='输入不能为空';
                  });
                }else{
                  setState(() {
                    _errorInputMessage=null;
                  });
                }
              },
              maxLines: null,
              minLines:1,
              maxLength: 1000,
            ),
          )

        )
      )
    );
  }

  /// 返回发布按钮组件
  Widget IssueButton(){
    return ElevatedButton(
      onPressed: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        ),
      },
      child: const Text('发布'),
    );
  }

  /// 从相册或相机获取图片
  void PictureSource(BuildContext ctx){
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

  ///从相册选择多张图片
  Future<void> _pickMultipleImages() async{
    try{
      List<XFile>? pickedFile = await picker.pickMultiImage();
      if(pickedFile!=null){
        setState(() {
          for(var i=0;i<pickedFile.length;i++){
            _userImage.add(pickedFile[i].path);
          }
          if(_userImage.length>9){
            _userImage=_userImage.sublist(0,9);
            Fluttertoast.showToast(msg: "最多选择9张图片。");
          }
        });
      }
    }catch(e){
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.red,
        fontSize: 16.0
      );
    }
  }

  ///从相机获取单张图片
  Future<void> _pickImageFromCamera() async{
    try{
      XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
      print(pickedFile?.path);
      if(pickedFile!=null){
        setState(() {
          _userImage.add(pickedFile.path);
        });
      }
    }catch(e){
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.red,
          fontSize: 16.0
      );
    }
  }
  ///发布
  void _issuePost() async{//TODO: 完成发布逻辑
      print("Issue");
      await sendFormDataRequest(apiUrl, title, text, _userImage,
              (body){
              print(body);
              print("-------------SUCCESS--------------");
            },(body){
              print(body);
              print("-------------FAIL--------------");
          }, (err){
            print(err);
            print("-------------ERROR--------------");
          });
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
