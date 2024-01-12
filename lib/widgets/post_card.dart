import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

/// 用于分栏展示帖子的单个卡片组件
class PostCard extends StatelessWidget {
  final int postId;
  final String cover;
  final int posterId;
  final String posterName;
  final String title;
  final String posterAvatar;

  final void Function() onTap;

  const PostCard({
    super.key,
    required this.postId,
    required this.cover,
    required this.posterId,
    required this.posterName,
    required this.title,
    required this.posterAvatar,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ExtendedImage.network(
                  cover,
                  cache: true,
                  fit: BoxFit.cover,
                  enableLoadState: true,
                  loadStateChanged: (ExtendedImageState state) {
                    if (state.extendedImageLoadState case LoadState.loading) {
                      return SkeletonLine(
                        style: SkeletonLineStyle(
                            height: 172,
                            borderRadius: BorderRadius.circular(12)
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
                        child: ExtendedRawImage(
                          image: state.extendedImageInfo?.image,
                          fit: BoxFit.cover,
                        )
                      );
                    }
                  }
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: ExtendedNetworkImageProvider(
                      posterAvatar,
                      cache: false,
                    ),
                  ),
                  const SizedBox(width: 12),  // add some space between the avatar and the text
                  Text(
                    posterName,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostCardSkeleton extends StatelessWidget {
  const PostCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SkeletonLine(
            style: SkeletonLineStyle(
                height: 172,
                borderRadius: BorderRadius.circular(12)
            )
        ),
        const SkeletonLine(
            style: SkeletonLineStyle(
              height: 24,
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            )
        ),
        SkeletonListTile(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          leadingStyle: SkeletonAvatarStyle(
            height: 24,
            width: 24,
            borderRadius: BorderRadius.circular(12),
          ),
          titleStyle: const SkeletonLineStyle(
            height: 20,
            width: 72,
          ),
        ),
      ],
    );
  }

}