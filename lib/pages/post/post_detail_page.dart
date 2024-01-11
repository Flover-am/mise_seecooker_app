import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/models/post_detail.dart';
import 'package:seecooker/models/comment.dart';
import 'package:seecooker/providers/comments_provider.dart';
import 'package:seecooker/providers/post_detail_provider.dart';
import 'package:seecooker/utils/image_util.dart';
import 'package:seecooker/widgets/refresh_place_holder.dart';
import 'package:skeletons/skeletons.dart';

import '../../providers/other_user/other_user_provider.dart';
import '../account/other_account_page.dart';

class PostDetailPage extends StatefulWidget {
  final int postId;

  /// 是否为个人发布的帖子
  final bool private;

  const PostDetailPage({super.key, required this.postId, this.private = false});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (context) => PostDetailProvider(widget.postId)),
          ChangeNotifierProvider(create: (context) => CommentsProvider(widget.postId)),
        ],
        builder: (context, child) {
          Future future = Provider.of<PostDetailProvider>(context, listen: false).fetchPostDetail();
          return FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildSkeleton();
              } else if (snapshot.hasError) {
                log('${snapshot.error}');
                return Scaffold(
                  appBar: AppBar(),
                  body: RefreshPlaceholder(
                    message: '网络出现了一点小故障，待会再来看看吧',
                    onRefresh: () {
                      setState(() {
                        future = Provider.of<PostDetailProvider>(context, listen: false).fetchPostDetail();
                      });
                    },
                  ),
                );
              } else {
                return PageContent(private: widget.private);
              }
            },
          );
        }
    );
  }

  Widget _buildSkeleton(){
    return Scaffold(
      appBar: AppBar(
        title: SkeletonListTile(
          leadingStyle: SkeletonAvatarStyle(
              height: 32,
              width: 32,
              borderRadius: BorderRadius.circular(16)
          ),
          titleStyle: const SkeletonLineStyle(
            height: 24,
            width: 72,
          ),
        ),
      ),
      body: Column(
        children: [
          SkeletonLine(
            style: SkeletonLineStyle(
                height: 368,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                borderRadius: BorderRadius.circular(12)
            ),
          ),
          const SizedBox(height: 32),
          const SkeletonLine(
            style: SkeletonLineStyle(
              height: 24,
              width: 96,
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          SkeletonParagraph(
            style: const SkeletonParagraphStyle(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              spacing: 8,
            ),
          )
        ],
      ),
    );
  }
}

class PageContent extends StatefulWidget {
  final bool private;

  const PageContent({super.key, required this.private});

  @override
  State<PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<PageContent> {
  /// 页面滑动控制器
  final ScrollController _scrollController = ScrollController();

  /// 评论区标题
  final GlobalKey _commentSectionTitleKey = GlobalKey();

  /// 快照区域
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  /// 评论输入框焦点
  final FocusNode _focusNode = FocusNode();

  /// 评论输入框文本编辑控制器
  final TextEditingController _textEditingController = TextEditingController();

  /// 点赞数
  late ValueNotifier<int> _likeNum;

  /// 是否点赞
  late ValueNotifier<bool> _like;

  /// 评论输入框弹窗
  late OverlayEntry _overlayEntry;

  @override
  Widget build(BuildContext context) {
    // 提前构建弹窗
    _overlayEntry = _buildOverlayEntry(context);

    // 添加监听器，失焦后关闭弹窗
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _overlayEntry.remove();
      }
    });

    return Consumer<PostDetailProvider>(
      builder: (context, provider, child) {
        PostDetail model = provider.model;

        // 初始化点赞数据
        _likeNum = ValueNotifier(model.likeNum);
        _like = ValueNotifier(model.like);

        return RepaintBoundary(
          key: _repaintBoundaryKey,
          child: Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              title: GestureDetector(
                onTap: () async {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => OtherAccountPage()),
                  // );
                },
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        OtherUserProvider otherUserProvider = Provider.of<OtherUserProvider>(context,listen: false);
                        PostDetailProvider postDetailProvider = Provider.of<PostDetailProvider>(context,listen: false);
                        await otherUserProvider.getUserById(postDetailProvider.model.posterId);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OtherAccountPage()),
                        );
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.transparent,
                        backgroundImage: ExtendedNetworkImageProvider(
                          model.posterAvatar,
                          cache: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        model.posterName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.home_outlined),
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                    ), // 设置图标之间的间距
                    widget.private
                        ? IconButton(
                      onPressed: () {
                        _showBottomSheet(context);
                      },
                      icon: const Icon(Icons.more_horiz_outlined),
                    )
                        : IconButton(
                      onPressed: () async {
                        // 分享屏幕快照
                        try {
                          await ImageUtil.shareImageData(await _capturePng());
                        } catch (e) {
                          Fluttertoast.showToast(msg: "分享失败");
                        }
                      },
                      icon: const Icon(Icons.share_outlined),
                    ),
                  ],
                ),
              ],
            ),
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // 图片
                SliverToBoxAdapter(
                  child: ImageCardSwiper(images: model.images ?? []),
                ),
                // 文本
                SliverToBoxAdapter(
                  child: TextSection(title: model.title, content: model.content),
                ),
                // 发布时间
                SliverToBoxAdapter(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(model.publishTime, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)))
                    )
                ),
                // 分隔线
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                    child: Divider(
                        thickness: 1,
                        color: Theme.of(context).colorScheme.primary.withAlpha(20)
                    ),
                  ),
                ),
                // 评论区标题
                SliverToBoxAdapter(
                  key: _commentSectionTitleKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('评论区', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                // 评论区
                FutureBuilder(
                    future: Provider.of<CommentsProvider>(context, listen: false).fetchComments(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SliverToBoxAdapter(
                            child: SkeletonListTile(
                              leadingStyle: SkeletonAvatarStyle(
                                  height: 36,
                                  width: 36,
                                  borderRadius: BorderRadius.circular(18)
                              ),
                              titleStyle: SkeletonLineStyle(
                                  height: 36,
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            )
                        );
                      } else if (snapshot.hasError) {
                        return const SliverToBoxAdapter(
                            child: Center(
                                child: RefreshPlaceholder(message: '悲报！帖子内容在网络中迷路了')
                            )
                        );
                      } else {
                        return Consumer<CommentsProvider>(
                          builder: (context, provider, child) {
                            return SliverList(
                                delegate: SliverChildBuilderDelegate((context, index) {
                                  return CommentItem(
                                    comment: provider.itemAt(index),
                                    onTap: (commenter) {
                                      _textEditingController.clear();
                                      _textEditingController.text = '回复 @$commenter : ';
                                      Overlay.of(context).insert(_overlayEntry);
                                      _focusNode.requestFocus();
                                    },
                                  );
                                },
                                    childCount: provider.length
                                )
                            );
                          },
                        );
                      }
                    }
                ),
                // 底部分隔线
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(thickness: 1, color: Theme.of(context).colorScheme.primary.withAlpha(20)),
                        ),
                        Text(' 没有更多了 ', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.primary.withAlpha(80))),
                        Expanded(
                          child: Divider(thickness: 1, color: Theme.of(context).colorScheme.primary.withAlpha(20)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomAppBar(
              elevation: 0,
              surfaceTintColor: Theme.of(context).colorScheme.primary,
              child: Row(
                children: <Widget>[
                  IconButton(
                    tooltip: '评论',
                    icon: const Icon(Icons.chat_bubble_outline_rounded),
                    // 滑动至评论区
                    onPressed: () {
                      Scrollable.ensureVisible(_commentSectionTitleKey.currentContext!, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                      // 弹出弹窗
                      Overlay.of(context).insert(_overlayEntry);
                      _focusNode.requestFocus();
                    },
                  ),
                  Consumer<CommentsProvider>(
                      builder: (context, provider, child) {
                        return Text('${provider.length}', style: Theme.of(context).textTheme.titleSmall);
                      }
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    tooltip: '喜欢',
                    icon: ValueListenableBuilder<bool>(
                      valueListenable: _like,
                      builder: (context, value, child) {
                        return value
                            ? Icon(Icons.favorite_rounded, color: Theme.of(context).colorScheme.primary)
                            : const Icon(Icons.favorite_outline_rounded);
                      },
                    ),
                    onPressed: () async {
                      try {
                        _like.value = await provider.likePost();
                        _likeNum.value += (_like.value ? 1 : -1);
                      } catch (e) {
                        Fluttertoast.showToast(msg: '$e'.substring(11));
                      }
                    },
                  ),
                  ValueListenableBuilder<int>(
                      valueListenable: _likeNum,
                      builder: (context, value, child) {
                        return Text('$value', style: Theme.of(context).textTheme.titleSmall);
                      }
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              mini: true,
              heroTag: UniqueKey(),
              elevation: 0,
              onPressed: () {
                // 弹出弹窗
                Overlay.of(context).insert(_overlayEntry);
                _focusNode.requestFocus();
              },
              child: Icon(Icons.edit, color: Theme.of(context).colorScheme.surface),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
          ),
        );
      },
    );
  }

  void _showBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      elevation: 0,
      showDragHandle: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Row(
            children: [
              const SizedBox(width: 16),
              SizedBox(
                width: 64,
                height: 64,
                child: InkWell(
                  onTap: () async {
                    try {
                      await ImageUtil.shareImageData(await _capturePng());
                      Navigator.pop(context);
                    } catch (e) {
                      Fluttertoast.showToast(msg: "分享失败");
                      Navigator.pop(context);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.share, size: 30),
                      const SizedBox(height: 4),
                      Text('分享', style: Theme.of(context).textTheme.labelMedium)
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 64,
                height: 64,
                child: InkWell(
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              elevation: 0,
                              title: const Text('是否删除帖子'),
                              content: const Text('删除帖子后无法恢复'),
                              actions: [
                                TextButton(
                                  child: const Text('取消'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: const Text('确认'),
                                  onPressed: () async {
                                    // TODO: 删除帖子
                                    // try {
                                    //   await Provider.of<PostDetailProvider>(ctx, listen: false).deletePost();
                                    //   Provider.of<UserPostsProvider>(context, listen: false).fetchPosts();
                                    //
                                    //   Fluttertoast.showToast(msg: "帖子已删除");
                                    //   Navigator.pop(context);
                                    //   Navigator.pop(context);
                                    //   Navigator.pop(context);
                                    // } catch (e) {
                                    //   Fluttertoast.showToast(msg: "删除失败");
                                    //   Navigator.pop(context);
                                    //   Navigator.pop(context);
                                    // }
                                  },
                                )
                              ]
                          );
                        }
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.delete_outlined, size: 30),
                      const SizedBox(height: 4),
                      Text('删除', style: Theme.of(context).textTheme.labelMedium)
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  OverlayEntry _buildOverlayEntry(BuildContext buildContext) {
    return OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 0,
        right: 0,
        child: Material(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
          ),
          elevation: 3,
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              leading: IconButton(
                onPressed: () {
                  // 返回
                  _overlayEntry.remove();
                  _textEditingController.clear();
                },
                icon: const Icon(Icons.clear_rounded),
              ),
              title: TextField(
                focusNode: _focusNode,
                controller: _textEditingController,
                cursorRadius: const Radius.circular(2),
                maxLength: 100,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: '在此输入你的评论',
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              trailing: IconButton(
                onPressed: () async {
                  if(_textEditingController.text.isNotEmpty) {
                    // 发送评论
                    _overlayEntry.remove();
                    try {
                      await Provider.of<CommentsProvider>(buildContext, listen: false).createComment(_textEditingController.text);
                      Fluttertoast.showToast(msg: "评论已发送");
                    } catch (e) {
                      Fluttertoast.showToast(msg: "$e".substring(11));
                    }
                    _textEditingController.clear();
                  } else {
                    Fluttertoast.showToast(msg: "请输入内容");
                  }
                },
                icon: const Icon(Icons.done_rounded),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 捕捉屏幕快照
  Future<Uint8List?> _capturePng() async {
    RenderRepaintBoundary? boundary = _repaintBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();
    return pngBytes;
  }
}

class ImageCardSwiper extends StatefulWidget {
  /// 展示的图片
  final List<String> images;


  const ImageCardSwiper({super.key, required this.images});

  @override
  State<ImageCardSwiper> createState() => _ImageCardSwiperState();
}

class _ImageCardSwiperState extends State<ImageCardSwiper> {
  /// 详情页和图片展示页共用的当前图片索引
  int _currentIndex = 0;

  /// 图片展示页的当前图片索引
  final ValueNotifier<int> _tipIndex = ValueNotifier(0);

  /// 图片滑动控制器
  final SwiperController _controller = SwiperController();

  @override
  Widget build(BuildContext context) {
    // 图片预加载
    for(var image in widget.images) {
      precacheImage(ExtendedNetworkImageProvider(image), context);
    }

    return SizedBox(
      height: 400,
      child: Swiper(
        index: _currentIndex,
        controller: _controller,
        onIndexChanged: (index) {
          _currentIndex = index;
        },
        scale: 0.8,
        loop: false,
        indicatorLayout: PageIndicatorLayout.COLOR,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 32,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) {
                                return _buildImagePageView(context);
                              }
                          )
                      );
                      _controller.move(_currentIndex);
                    },
                    child: Hero(
                      tag: widget.images[index],
                      child: ExtendedImage.network(
                        widget.images[index],
                        cache: true,
                        enableLoadState: false,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              )
          );
        },
        itemCount: widget.images.length,
        pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
              color: Colors.grey,
              activeColor: Theme.of(context).colorScheme.primary,
            )
        ),
        control: null,
      ),
    );
  }

  Widget _buildImagePageView(BuildContext context){
    _tipIndex.value = _currentIndex;
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ExtendedImageGesturePageView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.all(4),
                  child: Hero(
                    tag: widget.images[index],
                    child: ExtendedImage.network(
                      widget.images[index],
                      fit: BoxFit.contain,
                      mode: ExtendedImageMode.gesture,
                    ),
                  ),
                );
              },
              itemCount: widget.images.length,
              onPageChanged: (int index) {
                _currentIndex = index;
                _tipIndex.value = index;
              },
              controller: ExtendedPageController(
                initialPage: _currentIndex,
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                child: ValueListenableBuilder<int>(
                  valueListenable: _tipIndex,
                  builder: (context, value, child) => Text('${value + 1}/${widget.images.length}', style: Theme.of(context).textTheme.titleMedium),
                )
            ),
            Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 16,
                child: ActionChip(
                  label: const Text('保存图片'),
                  onPressed: () async {
                    try {
                      await ImageUtil.saveImageToGallery(widget.images[_currentIndex]);
                      Fluttertoast.showToast(msg: "图片已保存至相册");
                    } catch (e) {
                      Fluttertoast.showToast(msg: "图片保存失败");
                    }
                  },
                )
            ),
          ],
        ),
      ),
    );
  }
}

class TextSection extends StatelessWidget {
  /// 标题
  final String title;

  /// 正文
  final String content;

  const TextSection({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          SelectableText(content, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class CommentItem extends StatelessWidget {
  /// 评论内容
  final Comment comment;

  /// 点击时回调
  final void Function(String author) onTap;

  const CommentItem({super.key, required this.comment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () async {

              log("commenterId: ${comment.commenterId}");
              OtherUserProvider otherUserProvider = Provider.of<OtherUserProvider>(context,listen: false);
              await otherUserProvider.getUserById(comment.commenterId);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OtherAccountPage()),
              );
            },
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(comment.commenterAvatar),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Card(
              elevation: 0,
              margin: const EdgeInsets.all(0),
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onTap(comment.commenterName),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment.commenterName, style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 4),
                      Text(comment.content, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 6),
                      Text.rich(
                        TextSpan(
                            style: Theme.of(context).textTheme.labelMedium,
                            children: [
                              TextSpan(
                                  text: comment.commentTime,
                                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))
                              ),
                              const TextSpan(text: ' 回复', style: TextStyle(fontWeight: FontWeight.bold)),
                            ]
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}