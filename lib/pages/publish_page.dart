import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/pages/publish_post.dart';
import 'package:seecooker/pages/publish_recipe.dart';

import 'package:seecooker/providers/user_provider.dart';

class PublishPage extends StatefulWidget{
  final param;
  const PublishPage({super.key,required this.param});
  @override
  State<PublishPage> createState() => _PublishPageState(param: param);

}
class _PublishPageState extends State<PublishPage>{
  final param;
  _PublishPageState({required this.param});
  @override
  Widget build(BuildContext context) {
    // final userModel = Provider.of<UserProvider>(context);
    // // 检查用户是否已登录
    // if (!userModel.isLoggedIn) {
    //   // 如果未登录，则导航到LoginPage
    //   WidgetsBinding.instance!.addPostFrameCallback((_) {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context) => const LoginPage()),
    //     );
    //   });
    //   print(userModel.isLoggedIn);
    //   //Navigator.pop(context);
    // }
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('发布'),
        ),
        body:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children:[
              Padding(
                padding: EdgeInsets.fromLTRB(16,8,16,8),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //包含发布菜谱和发布帖子两个按钮
                    Padding(
                      padding: EdgeInsets.fromLTRB(0,0,16,0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          )),
                        ),
                          onPressed:(){
                          //将发布菜谱页push进路由
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PublishRecipe(param: param)),
                            );
                          },
                          child:const SizedBox(
                              width: 100,
                              height: 120,
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children:[
                                  Icon(Icons.restaurant_menu),
                                  Text("发布菜谱"),
                                ],
                              )
                          )
                      ),
                    ),
                    Padding(
                      padding:const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child:ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                            )),
                          ),
                          onPressed:(){
                            //将发布帖子页push进路由
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PublishPost(param: param)),
                            );
                          },
                          child:const SizedBox(
                              width: 100,
                              height: 120,
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children:[
                                  Icon(Icons.post_add),
                                  Text("发布帖子"),
                                ],
                              )
                          )
                      ),
                    )
                  ],
                ),
              ),
            ]
        )
    );
  }
}
