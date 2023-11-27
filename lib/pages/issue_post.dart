import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/issue_http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


import '../models/user_model.dart';
import 'login_page.dart';

class IssuePost extends StatefulWidget {
  final String param;
  const IssuePost({super.key,required this.param});

  @override
  State<IssuePost> createState() => _IssuePostState();
}

class _IssuePostState extends State<IssuePost> {
  String title='';
  String text='';
  final ImagePicker picker = ImagePicker();
  List<String> _userImage=[];//存放获取到的本地路径
  bool _issueButtonVisible=true;

  @override
  Widget build(BuildContext context) {
    var userModel = Provider.of<UserModel>(context,listen: false);
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
              //标题？？
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
                      //TODO:添加确认
                    }
                    else if(text.isEmpty){
                      //TODO:添加确认
                    }
                    else{
                      _issuePost();
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
            },child:TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '请输入标题(可选)',
              ),
              onChanged: (text){
                this.title=text;//TODO:标题长度控制
              },
            )
          )
        )
      ]

    );
  }
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
                                if(index==_userImage.length){
                                  PictureSource(context);
                                }else{
                                  showDetailImage(context,index);
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
                                      <Widget>[
                                        Expanded(
                                            child:
                                            Image.file(File(_userImage[index]), fit: BoxFit.cover)
                                        ),
                                      ]
                                          :
                                      <Widget>[
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
  void showDetailImage(BuildContext ctx,int index){
      OverlayEntry overlayEntry=OverlayEntry(builder: (ctx)=>Container());
      overlayEntry=OverlayEntry(
        builder:(ctx)=>Positioned(
            top:0,
            left:0,
          child:Material(
            color:Colors.black,
            child:InkWell(
              onTap: (){
                overlayEntry.remove();
              },
              child:Column(
                mainAxisSize: MainAxisSize.min,
                children:[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Hero(
                          tag:'showDetailImage$index',
                          child:Image.file(
                            File(_userImage[index]),
                            fit: BoxFit.contain,
                            width: MediaQuery.of(ctx).size.width,
                            height: MediaQuery.of(ctx).size.height,
                          )
                      ),
                    ]
                  ),
                  ElevatedButton(onPressed: (){
                        //TODO:添加确认
                        setState((){
                          _userImage.removeAt(index);
                        });
                        overlayEntry.remove();
                      }, child: const Icon(Icons.delete),
                  )

                  ]
                )
              )
            )
          )
      );

      Overlay.of(ctx)?.insert(overlayEntry);
  }
  Widget PictureAdder(){

    return GestureDetector(
      onTap:(){
        PictureSource(context);
      },
      child:Padding(
        padding: const EdgeInsets.all(12.0),
        child:Center(
          child:Image.asset('assets/images/add.png'),
        )

      )
    );

  }
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
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '请输入发布内容',
              ),
              onChanged: (text){
                this.text=text;
              },
            )
          )

        )
      )
    );
  }

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

  //从相册选择多张图片
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
  //从相机获取单张图片
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
  //发布
  void _issuePost() async{
      print("Issue");
      await sendFormDataRequest(apiUrl, title, text, _userImage,
              (body){
              print(body);
              print("-------------SUCCESS--------------");
            },(body){
              print(body.toString());
              print("-------------FAIL--------------");
          }, (err){
            print(err);
            print("-------------ERROR--------------");
          });
  }
}