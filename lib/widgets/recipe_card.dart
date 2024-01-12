import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class RecipeCard extends StatelessWidget {
  final int recipeId;
  final String name;
  final String introduction;
  final String cover;
  final bool favorite;
  final Function onFavorite;

  /// 是否允许收藏
  final bool favorable;

  RecipeCard({
    super.key,
    required this.recipeId,
    required this.name,
    required this.introduction,
    required this.cover,
    required this.favorite,
    required this.onFavorite,
    this.favorable = true,
  });

  final ValueNotifier<bool> _favorite = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    _favorite.value = favorite;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
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
                              height: MediaQuery.of(context).size.width - 48,
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
                Positioned(
                  top: 52,
                  left: 16,
                  child: Text(
                    "“$introduction”",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                ),
                favorable
                  ? ValueListenableBuilder<bool>(
                      valueListenable: _favorite,
                      builder: (context, value, child) {
                        return Positioned(
                          left: 4,
                          bottom: 4,
                          child: IconButton(
                            icon: value
                              ? Icon(Icons.favorite_rounded, color: Theme.of(context).colorScheme.primary)
                              : const Icon(Icons.favorite_outline_rounded, color: Colors.white),
                            onPressed: () async {
                              _favorite.value = await onFavorite();
                            },
                          )
                        );
                      },
                    )
                  : const SizedBox()
              ]
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}