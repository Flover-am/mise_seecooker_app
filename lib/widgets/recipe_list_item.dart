import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:seecooker/pages/recipe/recipe_detail.dart';

class RecipeListItem extends StatelessWidget {
  final int id;
  final String name;
  final String cover;
  final String authorName;
  final String? authorAvatar;

  const RecipeListItem({
    super.key,
    required this.id,
    required this.name,
    required this.cover,
    required this.authorName,
    required this.authorAvatar
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
                MaterialPageRoute(builder: (context) => RecipeDetail(id: id)));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: cover,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  // TODO: 食谱评分
                  Row(
                    children: [
                      const Icon(Icons.star_border_rounded, color: Colors.yellow, size: 18),
                      Text('8.6分', style: Theme.of(context).textTheme.labelLarge),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // TODO: 食谱标签
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '“我都不敢想象会有多好吃！”',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.outline),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Theme.of(context).colorScheme.outline,
                        backgroundImage: authorAvatar != null
                        ? ExtendedNetworkImageProvider(
                          authorAvatar!,
                          cache: false,
                        )
                        : null,
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