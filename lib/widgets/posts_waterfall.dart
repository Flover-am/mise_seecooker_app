import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:seecooker/providers/post/posts_provider.dart';
import 'package:seecooker/widgets/post_card.dart';
import 'package:provider/provider.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

/// 用于展示帖子的瀑布流组件
/// 使用前应在父Widget处声明实现了PostsProvider接口的自定义Provider，并作为泛型参数传入
/// 使用前无需提前获取数据
/// 组件内部已经实现了骨架屏、图片预加载、下拉刷新、无限滑动、错误信息展示及空内容提示信息展示
class PostsWaterfall<T extends PostsProvider> extends StatelessWidget {
  /// 未获取到任何帖子数据时展示的空内容提示信息
  final String emptyMessage;

  const PostsWaterfall({super.key, this.emptyMessage = '暂无帖子'});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<T>(context, listen: false).fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(
                child: _buildSkeleton()
            );
          } else if (snapshot.hasError) {
            return Container(
                padding: const EdgeInsets.all(32),
                child: SelectableText('Error: ${snapshot.error}')
            );
          } else {
            if(Provider.of<T>(context, listen: false).count == 0){
              return Container(
                  padding: const EdgeInsets.all(32),
                  child: Text(emptyMessage)
              );
            } else {
              return RefreshIndicator(
                onRefresh: Provider.of<T>(context).fetchPosts,
                child: Consumer<T>(
                    builder: (context, provider, child) {
                      return WaterfallFlow.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemBuilder: (context, index) {
                          if (index == provider.count - 1) {
                            provider.fetchMorePosts();
                          }
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
                            child: PostCard(
                                postId: provider.itemAt(index).postId,
                                cover: provider.itemAt(index).cover,
                                posterName: provider.itemAt(index).posterName,
                                title: provider.itemAt(index).title,
                                posterAvatar: provider.itemAt(index).posterAvatar
                            ),
                          );
                        },
                        itemCount: provider.count,
                      );
                    }
                ),
              );
            }
          }
        }
    );
  }

  Widget _buildSkeleton() {
    return WaterfallFlow.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return const PostCardSkeleton();
      },
      itemCount: 4,
    );
  }
}