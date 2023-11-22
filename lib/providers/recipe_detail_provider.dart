import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seecooker/models/recipe_detail.dart';

class RecipeDetailProvider with ChangeNotifier {
  late RecipeModel _model;

  RecipeModel get model => _model;

  Future<RecipeModel> fetchPostDetail(int id) async {
    await Future.delayed(const Duration(seconds: 1));
    _model =
        RecipeModel('XiaoHu', 'assets/images/tmp/avatar.png', 0, false, false, {
      0: "活虾清洗干净后 ，从头部去除内脏和虾线，去壳留虾仁和虾头。\n油热放入葱姜丝，虾头锅里煸出虾油，放入水烧开，加入食盐，胡椒粉调味，煮开后翻滚几分钟后，放入虾仁，青菜叶，关火（虾仁烫熟肉质会比较鲜嫩），放入适量鸡精。\n    面条单独起锅煮熟捞入碗中，倒入做好的鲜汤，加入一个煎蛋，完美。",
      1: "1️⃣、香菇、土豆切丁，辣椒切段，热锅入油，放入葱姜爆香，倒入肉末翻炒变色➕1勺料酒翻炒，倒入香菇丁土豆丁翻炒均匀",
      2: "2️⃣、加入生抽2勺➕老抽1勺➕蚝油2勺➕盐和糖半勺➕适量胡椒粉，翻炒均匀上色，加入一碗温水，煮几分钟\n    3️⃣、放入辣椒🌶️淋入适量水淀粉，翻炒至浓稠即可",
      3: "👍盛碗米饭拌上香菇土豆肉沫，真的太香了"
    });
    return _model;
  }

  void changeStarAmount(int SM2) {
    _model.starAmount = SM2;
    notifyListeners();
  }

  void addToFavorite() {
    Fluttertoast.showToast(msg: "已收藏");
    _model.isFavorite = true;
    notifyListeners();
  }

  void removeToFavorite() {
    Fluttertoast.showToast(msg: "取消收藏");
    _model.isFavorite = false;
    notifyListeners();
  }

  void sendMark() {
    _model.isMarked = true;
    Fluttertoast.showToast(msg: "评论成功");
    notifyListeners();
  }

}
