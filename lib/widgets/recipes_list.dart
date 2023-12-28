import 'package:flutter/material.dart';
import 'package:seecooker/providers/recipe/recipes_provider.dart';

// TODO: 完成组件
/// 用于展示菜谱的列表组件
/// 使用前应在父Widget处声明实现了RecipesProvider接口的自定义Provider，并作为泛型参数传入
/// 使用前无需提前获取数据
/// 组件内部已经实现了骨架屏、图片预加载、下拉刷新、无限滑动、错误信息展示及空内容提示信息展示
class RecipesList<T extends RecipesProvider> extends StatefulWidget {
  /// 未获取到任何帖子数据时展示的空内容提示信息
  final String emptyMessage;

  /// 末尾提示信息
  final String endMessage;

  /// 是否允许下拉刷新
  final bool enableRefresh;

  /// 是否为个人发布菜谱展示
  final bool private;

  const RecipesList({super.key, this.emptyMessage = '暂无菜谱', this.endMessage = '没有更多了 ~', this.enableRefresh = true, this.private = false});

  @override
  State<RecipesList<T>> createState() => _RecipesListState<T>();
}

class _RecipesListState<T extends RecipesProvider> extends State<RecipesList<T>> {
  @override
  Widget build(BuildContext context) {
    return Text('');
  }
}