import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/models/post_detail.dart';
import 'package:seecooker/providers/post_detail_provider.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailPage extends StatelessWidget {
  final int id;

  const PostDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostDetailProvider(),
      builder: (context, child) {
        return FutureBuilder(
          future: Provider.of<PostDetailProvider>(context, listen: false).fetchPostDetail(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator()
                ),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
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
}

class PageContent extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _commentSectionTitleKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  late OverlayEntry _overlayEntry;

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
        PostDetailModel model = provider.model;
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(model.avatarUrl),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    model.author,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: IconButton(
                    onPressed: () {
                      Share.share('share content');
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
                child: ImageCardSwiper(imageUrls: model.imageUrls),
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
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return CommentItem(
                      comment: model.comments[index],
                      onTap: (author) {
                        _textEditingController.clear();
                        _textEditingController.text = '回复 @$author : ';
                        Overlay.of(context).insert(_overlayEntry);
                        _focusNode.requestFocus();
                      },
                    );
                  },
                  childCount: model.comments.length
                )
              )
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              children: <Widget>[
                IconButton(
                  tooltip: '评论',
                  icon: const Icon(Icons.notes),
                  onPressed: () => Scrollable.ensureVisible(_commentSectionTitleKey.currentContext!, duration: const Duration(milliseconds: 500), curve: Curves.ease),
                  //onPressed: () => showCommentSection(context, false, model.comments, provider.postComment),
                ),
                IconButton(
                  tooltip: '喜欢',
                  icon: const Icon(Icons.favorite_outline),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            onPressed: () {
              //Scrollable.ensureVisible(_commentSectionTitleKey.currentContext!, duration: const Duration(milliseconds: 500), curve: Curves.ease);
              Overlay.of(context).insert(_overlayEntry);
              _focusNode.requestFocus();
              //FocusScope.of(context).requestFocus(_focusNode);
            },
            //onPressed: () => showCommentSection(context, true, model.comments, provider.postComment),
            mini: true,
            child: const Icon(Icons.edit),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
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
        child: Card(
          //elevation: 0,
          //color: Theme.of(context).colorScheme.surfaceVariant,
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
              decoration: InputDecoration(
                hintText: '在此输入你的评论',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
              ),
              onEditingComplete: () {
                _overlayEntry.remove();
              },
              onSubmitted: (value) {
                Provider.of<PostDetailProvider>(buildContext, listen: false).postComment(value);
                _textEditingController.clear();
              },
            ),
            trailing: IconButton(
              onPressed: () {
                if(_textEditingController.text.isNotEmpty) {
                  Provider.of<PostDetailProvider>(buildContext, listen: false).postComment(_textEditingController.text);
                }
                _overlayEntry.remove();
              },
              icon: const Icon(Icons.done_rounded),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageCardSwiper extends StatelessWidget {
  final List<String> imageUrls;

  const ImageCardSwiper({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Swiper(
        scale: 0.8,
        loop: false,
        indicatorLayout: PageIndicatorLayout.COLOR,
        itemBuilder: (BuildContext context,
            int index) {
          return Padding(
              padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 32
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    12),
                child: Container(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondaryContainer,
                  child: Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                  ),
                ),
              )
          );
        },
        itemCount: imageUrls.length,
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
  final CommentModel comment;
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
            radius: 16,
            backgroundImage: NetworkImage(comment.avatarUrl),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Card(
              elevation: 0,
              margin: const EdgeInsets.all(0),
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: InkWell(
                onTap: () => onTap(comment.author),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment.author, style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 2),
                      Text(comment.content),
                      const SizedBox(height: 2),
                      Text('${comment.date}', style: Theme.of(context).textTheme.labelSmall)
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