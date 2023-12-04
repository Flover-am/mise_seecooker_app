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
import 'package:share_plus/share_plus.dart';
import 'package:skeletons/skeletons.dart';

class PostDetailPage extends StatelessWidget {
  final int postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PostDetailProvider(postId)),
        ChangeNotifierProvider(create: (context) => CommentsProvider(postId)),
      ],
      builder: (context, child) {
        return FutureBuilder(
          future: Provider.of<PostDetailProvider>(context, listen: false).fetchPostDetail(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildSkeleton();
            } else if (snapshot.hasError) {
              return Scaffold(
                appBar: AppBar(),
                body: Center(
                    child: Text('Error: ${snapshot.error}')
                ),
              );
            } else {
              return PageContent();
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
              height: 36,
              width: 36,
              borderRadius: BorderRadius.circular(18)
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

class PageContent extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _commentSectionTitleKey = GlobalKey();
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  late OverlayEntry _overlayEntry; // 评论输入框弹窗

  PageContent({super.key});

  @override
  Widget build(BuildContext context) {
    _overlayEntry = _buildOverlayEntry(context);

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _overlayEntry.remove();
      }
    });

    return Consumer<PostDetailProvider>(
      builder: (context, provider, child) {
        PostDetail model = provider.model;
        return RepaintBoundary(
          key: _repaintBoundaryKey,
          child: Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.transparent,
                    backgroundImage: ExtendedNetworkImageProvider(
                      model.posterAvatar,
                      cache: false,
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
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: IconButton(
                      onPressed: () async {
                        try {
                          await ImageUtil.shareImageData(await _capturePng());
                        } catch (e) {
                          Fluttertoast.showToast(msg: "分享失败: $e");
                        }
                      },
                      icon: const Icon(Icons.share_outlined)
                  ),
                )
              ],
            ),
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: ImageCardSwiper(images: model.images),
                ),
                SliverToBoxAdapter(
                  child: TextSection(title: model.title, content: model.content),
                ),
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
                /* comment section */
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
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Text('Error: ${snapshot.error}')
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
                    onPressed: () => Scrollable.ensureVisible(_commentSectionTitleKey.currentContext!, duration: const Duration(milliseconds: 500), curve: Curves.ease),
                  ),
                  Consumer<CommentsProvider>(
                    builder: (context, provider, child) {
                      return Text('${provider.length}', style: Theme.of(context).textTheme.titleSmall);
                    }
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    tooltip: '喜欢',
                    icon: const Icon(Icons.favorite_outline_rounded),
                    onPressed: () {},
                  ),
                  Text('1', style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              mini: true,
              heroTag: UniqueKey(),
              elevation: 0,
              onPressed: () {
                Overlay.of(context).insert(_overlayEntry);
                _focusNode.requestFocus();
              },
              child: const Icon(Icons.edit),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
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
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 0,
            leading: IconButton(
              onPressed: () {
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
                  _overlayEntry.remove();
                  try {
                    await Provider.of<CommentsProvider>(buildContext, listen: false).createComment(_textEditingController.text);
                    Fluttertoast.showToast(msg: "评论已发送");
                  } catch (e) {
                    Fluttertoast.showToast(msg: "$e");
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
    );
  }

  Future<Uint8List?> _capturePng() async {
    RenderRepaintBoundary? boundary = _repaintBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();
    return pngBytes;
  }

}

class ImageCardSwiper extends StatelessWidget {
  final List<String> images;
  int _currentIndex = 0; // 详情页和图片展示页共用的当前图片索引
  final ValueNotifier<int> _tipIndex = ValueNotifier(0); // 图片展示页的当前图片索引

  ImageCardSwiper({super.key, required this.images});

  final SwiperController _controller = SwiperController();

  @override
  Widget build(BuildContext context) {
    for(var image in images) {
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
                bottom: 32
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
                    tag: images[index],
                    child: ExtendedImage.network(
                      images[index],
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
        itemCount: images.length,
        pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
              color: Colors.grey,
              activeColor: Theme
                  .of(context)
                  .colorScheme
                  .primary,
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
        onTap: () => { Navigator.pop(context) },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ExtendedImageGesturePageView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.all(4),
                  child: Hero(
                    tag: images[index],
                    child: ExtendedImage.network(
                      images[index],
                      fit: BoxFit.contain,
                      mode: ExtendedImageMode.gesture,
                    ),
                  ),
                );
              },
              itemCount: images.length,
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
                builder: (context, value, child) => Text('${value + 1}/${images.length}', style: Theme.of(context).textTheme.titleMedium),
              )
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 16,
              child: ActionChip(
                label: const Text('保存图片'),
                onPressed: () async {
                  try {
                    await ImageUtil.saveImageToGallery(images[_currentIndex]);
                    Fluttertoast.showToast(msg: "图片已保存至相册");
                  } catch (e) {
                    Fluttertoast.showToast(msg: "图片保存失败：$e");
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
  final String title;
  final String content;

  const TextSection({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16)
        ],
      ),
    );
  }
}

class CommentItem extends StatelessWidget {
  final Comment comment;
  final void Function(String author) onTap;

  const CommentItem({super.key, required this.comment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(comment.commenterAvatar),
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
                      //Text('${comment.date}', style: Theme.of(context).textTheme.labelSmall),
                      Text.rich(
                        TextSpan(
                          style: Theme.of(context).textTheme.labelMedium,
                          children: [
                            TextSpan(
                              text: comment.commentTime,
                              style: TextStyle(color: Theme.of(context).colorScheme.outline)
                            ),
                            TextSpan(text: ' 回复', style: Theme.of(context).textTheme.bodySmall),
                          ]
                        )
                      )
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