import 'dart:developer';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/providers/recipe/recipes_provider.dart';
import 'package:seecooker/widgets/recipe_item.dart';
import 'package:seecooker/widgets/refresh_place_holder.dart';
import 'package:skeletons/skeletons.dart';

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
    Future future = Provider.of<T>(context).fetchRecipes();
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: _buildSkeleton());
          } else if (snapshot.hasError) {
            log('${snapshot.error}');
            return RefreshPlaceholder(
              message: '悲报！菜谱在网络中迷路了',
              onRefresh: () {
                setState(() {
                  future = Provider.of<T>(context, listen: false).fetchRecipes();
                });
              },
            );
          } else {
            if(Provider.of<T>(context, listen: false).count == 0){
              return RefreshPlaceholder(
                message: widget.emptyMessage,
                onRefresh: () {
                  setState(() {
                    future = Provider.of<T>(context, listen: false).fetchRecipes();
                  });
                },
              );
            } else {
              return widget.enableRefresh
                ? RefreshIndicator(
                    onRefresh: Provider.of<T>(context, listen: false).fetchRecipes,
                    child: _buildList(),
                  )
                : _buildList();
            }
          }
        }
    );
  }

  Widget _buildList() {
    return Consumer<T>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            if(index == provider.count) {
              provider.fetchMoreRecipes();
              return TweenAnimationBuilder(
                duration: const Duration(milliseconds: 500),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: child,
                  );
                },
                child: RefreshPlaceholder(
                  message: widget.endMessage
                ),
              );
            } else {
              precacheImage(ExtendedNetworkImageProvider(provider.itemAt(index).cover), context);
              return TweenAnimationBuilder(
                duration: const Duration(milliseconds: 500),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: child,
                  );
                },
                child: RecipeItem(
                  id: provider.itemAt(index).id,
                  name: provider.itemAt(index).name,
                  cover: provider.itemAt(index).cover,
                  authorName: provider.itemAt(index).authorName,
                  authorAvatar: provider.itemAt(index).authorAvatar,
                ),
              );
            }
          },
          itemCount: provider.count + 1,
        );
      }
    );
  }

  Widget _buildSkeleton() {
    return Column(
      children: [
        Container(
          height: 144,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(
                    width: 153.6,
                    height: 126,
                    borderRadius: BorderRadius.circular(12)
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  const SkeletonLine(style: SkeletonLineStyle(width: 96, height: 24)),
                  const SizedBox(height: 8),
                  const SkeletonLine(style: SkeletonLineStyle(width: 48, height: 20)),
                  const SizedBox(height: 8),
                  const SkeletonLine(style: SkeletonLineStyle(width: 128, height: 24)),
                  const Spacer(),
                  SizedBox(
                    width: 128,
                    child: SkeletonListTile(
                      padding: EdgeInsets.zero,
                      leadingStyle: SkeletonAvatarStyle(
                          height: 24,
                          width: 24,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      titleStyle: const SkeletonLineStyle(
                        height: 20,
                        width: 72,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}