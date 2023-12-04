import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipeCard extends StatelessWidget {
  final int recipeId;
  final String name;
  final String cover;
  final ValueNotifier<bool> _isFavorite = ValueNotifier(false);

  RecipeCard({
    super.key,
    required this.recipeId,
    required this.name,
    required this.cover,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Get if favorite
    _isFavorite.value = false;

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
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: cover,
                      fit: BoxFit.cover,
                    ),
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
                ValueListenableBuilder<bool>(
                  valueListenable: _isFavorite,
                  builder: (context, value, child) {
                    return Positioned(
                      left: 4,
                      bottom: 4,
                      child: IconButton(
                        icon: value
                          ? Icon(Icons.favorite_rounded, color: Theme.of(context).colorScheme.primary)
                          : const Icon(Icons.favorite_outline_rounded, color: Colors.white),
                        onPressed: () => addOrRemoveFavorite(),
                      )
                    );
                  },
                )
              ]
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void addOrRemoveFavorite() {
    if(_isFavorite.value) {
      // TODO: Remove favorite

    } else {
      // TODO: Add favorite
    }
    _isFavorite.value = !_isFavorite.value;
  }
}