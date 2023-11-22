import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipeCard extends StatelessWidget {
  final int id;
  final String title;
  final String coverUrl;
  final String author;
  final int like;
  final double rate;

  const RecipeCard({
    super.key,
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.author,
    required this.like,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
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
                      image: coverUrl,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 16,
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w300),
                  )
                ),
                Positioned(
                  left: 16,
                  bottom: 8,
                  child: Row(
                    children: [
                      const Icon(Icons.favorite_outline_rounded, color: Colors.white, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        '1',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                      )
                    ],
                  )
                )
              ]
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(coverUrl),
                ),
                title: Text(author),
              ),
            ),
          )
        ],
      ),
    );
  }
}