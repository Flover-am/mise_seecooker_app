import 'package:seecooker/models/post.dart';

abstract class PostsProvider {
  /// 帖子数量
  int get count;

  /// 单个帖子
  Post itemAt(int index);

  /// 初始化帖子列表及刷新帖子列表
  Future<void> fetchPosts();

  /// 获取更多帖子，用于无限滑动
  Future<void> fetchMorePosts();
}