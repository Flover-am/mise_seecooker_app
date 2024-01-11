import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ExpRecipeCard extends StatelessWidget {
  final int id;
  final String title;
  final String coverUrl;
  final String author;
  final String introduction;
  final String authorAvatar;
  final bool favourite;
  const ExpRecipeCard({
    super.key,
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.author,
    required this.introduction,
    required this.authorAvatar,
    required this.favourite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
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
                          bottom: 130,
                          child:
                              this.favourite ? Icon(Icons.favorite, color: Colors.white, size: 24) : Icon(Icons.favorite_outline, color: Colors.white, size: 24),
                      )],

                ),
              ))
          ,
          Expanded(child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(authorAvatar),
                ),
                title: Text(author,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27)),
                subtitle: Text(introduction.substring(0,17)+"……",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27)),
              ),
            ),
          ))
        ],
    );
  }
}