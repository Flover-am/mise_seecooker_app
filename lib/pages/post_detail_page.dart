import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/models/post_detail.dart';
import 'package:seecooker/providers/post_detail_provider.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailPage extends StatefulWidget {
  final int id;

  const PostDetailPage({super.key, required this.id});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostDetailProvider(),
      builder: (context, child) {
        return FutureBuilder(
          future: Provider.of<PostDetailProvider>(context, listen: false).fetchPostDetail(widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator()
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error: ${snapshot.error}')
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
  const PageContent({super.key});

  void showCommentSection(BuildContext context, bool autofocus, List<CommentModel> comments, Function onSubmit) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 600,
          child: Column(
              children: [
                CommentInput(autofocus: autofocus, onSubmit: onSubmit),
                const SizedBox(height: 8),
                const CommentSectionTitle(),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return CommentItem(comment: comments[index]);
                    },
                    itemCount: comments.length,
                  ),
                )
              ]
          ),
        );
      },
      isScrollControlled: true,
      showDragHandle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
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
            slivers: [
              SliverToBoxAdapter(
                child: ImageCardSwiper(imageUrls: model.imageUrls),
              ),
              SliverToBoxAdapter(
                child: TextSection(title: model.title, content: model.content),
              ),
              const SliverToBoxAdapter(
                child: CommentSectionTitle(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return CommentItem(comment: model.comments[index]);
                  },
                  childCount: model.comments.length
                )
              )
            ],
          ),
          bottomNavigationBar: SizedBox(
            height: 80,
            child: BottomAppBar(
              child: Row(
                children: <Widget>[
                  IconButton(
                    tooltip: '评论',
                    icon: const Icon(Icons.notes),
                    onPressed: () => showCommentSection(context, false, model.comments, provider.postComment),
                  ),
                  IconButton(
                    tooltip: '喜欢',
                    icon: const Icon(Icons.favorite_outline),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            onPressed: () => showCommentSection(context, true, model.comments, provider.postComment),
            mini: true,
            child: const Icon(Icons.edit),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        );
      },
    );
  }
}

class CommentInput extends StatefulWidget {
  final bool autofocus;
  final Function onSubmit;

  const CommentInput({super.key, required this.autofocus, required this.onSubmit});

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 68,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: widget.autofocus,
              focusNode: _focusNode,
              cursorRadius: const Radius.circular(2),
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                  hintText: '在此输入你的评论',
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                  errorText: _errorText,
              ),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.tonal(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  widget.onSubmit(_controller.text);
                  _focusNode.unfocus();
                } else {
                  _focusNode.requestFocus();
                }
              },
              child: const Text('发送')
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _controller.text.isEmpty) {
        setState(() {
          _errorText = '请输入内容';
        });
      } else {
        setState(() {
          _errorText = null;
        });
      }
    });

    _controller.addListener(() {
      if (_focusNode.hasFocus && _controller.text.isEmpty) {
        setState(() {
          _errorText = '请输入内容';
        });
      } else {
        setState(() {
          _errorText = null;
        });
      }
    });
  }
}

enum Order { hot, time }

class CommentSectionTitle extends StatefulWidget {
  const CommentSectionTitle({super.key});

  @override
  State<CommentSectionTitle> createState() => _CommentSectionTitleState();
}

class _CommentSectionTitleState extends State<CommentSectionTitle> {
  Order order = Order.hot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '评论区',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SegmentedButton<Order>(
            style: const ButtonStyle(visualDensity: VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity)),
            multiSelectionEnabled: false,
            segments: [
              ButtonSegment(
                value: Order.hot,
                label: Text('最热', style: Theme.of(context).textTheme.labelMedium),
                icon: const Icon(Icons.whatshot_outlined)
              ),
              ButtonSegment(
                value: Order.time,
                label: Text('最新', style: Theme.of(context).textTheme.labelMedium),
                icon: const Icon(Icons.calendar_today_outlined)
              )
            ],
            selected: {order},
            onSelectionChanged: (newSelection) {
              setState(() {
                order = newSelection.first;
              });
            },
          )
        ],
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

class CommentItem extends StatefulWidget {
  final CommentModel comment;

  const CommentItem({super.key, required this.comment});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool hasThumbUped = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 0,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.comment.avatarUrl),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.comment.author,
                      style: Theme.of(context).textTheme.titleSmall
                    ),
                    Text(
                      widget.comment.date.toString(),
                      style: Theme.of(context).textTheme.labelSmall,
                    )
                  ],
                )
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 48),
              child: Text(widget.comment.content),
            ),
            trailing: IconButton(
              icon: hasThumbUped
                ? const Icon(Icons.thumb_up, color: Colors.red)
                : const Icon(Icons.thumb_up_outlined),
              onPressed: () {
                setState(() {
                  hasThumbUped = !hasThumbUped;
                });
              },
            ),
          ),
          const Divider(indent: 48)
        ],
      ),
    );
  }
}