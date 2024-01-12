import 'dart:developer';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:seecooker/pages/post/post_detail_page.dart';
import 'package:seecooker/providers/post/posts_provider.dart';
import 'package:seecooker/widgets/post_card.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/widgets/refresh_place_holder.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

/// 用于展示帖子的瀑布流组件
/// 使用前应在父Widget处声明实现了PostsProvider接口的自定义Provider，并作为泛型参数传入
/// 使用前无需提前获取数据
/// 组件内部已经实现了骨架屏、图片预加载、下拉刷新、无限滑动、错误信息展示及空内容提示信息展示
class PostsWaterfall<T extends PostsProvider> extends StatefulWidget {
  /// 未获取到任何帖子数据时展示的空内容提示信息
  final String emptyMessage;

  /// 末尾提示信息
  final String endMessage;

  /// 是否允许下拉刷新
  final bool enableRefresh;

  /// 是否为个人发布帖子展示
  final bool private;

  const PostsWaterfall({super.key, this.emptyMessage = '暂无帖子', this.endMessage = '没有更多了 ~', this.enableRefresh = true, this.private = false});

  @override
  State<PostsWaterfall<T>> createState() => _PostsWaterfallState<T>();
}

class _PostsWaterfallState<T extends PostsProvider> extends State<PostsWaterfall<T>> {
  @override
  Widget build(BuildContext context) {
    Future future = Provider.of<T>(context, listen: false).fetchPosts();
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: _buildSkeleton());
          } else if (snapshot.hasError) {
            log('${snapshot.error}');
            return RefreshPlaceholder(
              message: '悲报！帖子在网络中迷路了',
              onRefresh: () {
                setState(() {
                  future = Provider.of<T>(context, listen: false).fetchPosts();
                });
              },
            );
          } else {
            if(Provider.of<T>(context, listen: false).count == 0){
              return RefreshPlaceholder(
                message: widget.emptyMessage,
                onRefresh: () {
                  setState(() {
                    future = Provider.of<T>(context, listen: false).fetchPosts();
                  });
                },
              );
            } else {
              return widget.enableRefresh
                ? RefreshIndicator(
                    onRefresh: Provider.of<T>(context, listen: false).fetchPosts,
                    child: _buildWaterfall(),
                  )
                : _buildWaterfall();
            }
          }
        }
    );
  }

  Widget _buildWaterfall() {
    return Consumer<T>(
        builder: (context, provider, child) {
          return WaterfallFlow.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              lastChildLayoutTypeBuilder: (index) => index == provider.count
                  ? LastChildLayoutType.fullCrossAxisExtent
                  : LastChildLayoutType.none,
            ),
            itemBuilder: (context, index) {
              if (index == provider.count) {
                provider.fetchMorePosts();
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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(child: Text(widget.endMessage, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)))),
                  ),
                );
              } else {
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
                  child: PostCard(
                    postId: provider.itemAt(index).postId,
                    cover: provider.itemAt(index).cover,
                    posterId: provider.itemAt(index).posterId,
                    posterName: provider.itemAt(index).posterName,
                    title: provider.itemAt(index).title,
                    posterAvatar: provider.itemAt(index).posterAvatar,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailPage(postId: provider.itemAt(index).postId, private: widget.private))),
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
    return WaterfallFlow.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return const PostCardSkeleton();
      },
      itemCount: 4,
    );
  }
}