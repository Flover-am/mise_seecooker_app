import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import 'package:seecooker/pages/recipe/recipe_detail_page.dart';

/// 用于以列表形式展示食谱得单个卡片组件
class RecipeItem extends StatelessWidget {
  final int id;
  final String name;
  final String cover;
  final String introduction;
  final double score;
  final int authorId;
  final String authorName;
  final String authorAvatar;
  final String publishTime;

  const RecipeItem({
    super.key,
    required this.id,
    required this.name,
    required this.cover,
    required this.introduction,
    required this.score,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.publishTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 144,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Theme.of(context).colorScheme.surface,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipeDetailPage(id: id)));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 封面图
              AspectRatio(
                aspectRatio: 1.2,
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
                                height: 128,
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
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  // 食谱名
                  Text(name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  // 评分
                  Row(
                    children: [
                      const Icon(Icons.star_border_rounded, color: Colors.yellow, size: 18),
                      Text('${score.toStringAsFixed(1)}分', style: Theme.of(context).textTheme.labelLarge),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 简介
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "“$introduction”",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.outline),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  // 作者头像及昵称
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Theme.of(context).colorScheme.outline,
                        backgroundImage: ExtendedNetworkImageProvider(
                          authorAvatar,
                          cache: false,
                        ),
                      ),
                      const SizedBox(width: 8),  // add some space between the avatar and the text
                      Text(authorName, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.outline)),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}