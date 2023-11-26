import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/post_detail_page.dart';
import '../providers/post_detail_provider.dart';

class CommunityCard extends StatelessWidget {
  final int id;
  final String thumbnailUrl;
  final String author;
  final String title;
  final String avatarUrl;

  const CommunityCard({
    super.key,
    required this.id,
    required this.thumbnailUrl,
    required this.author,
    required this.title,
    required this.avatarUrl
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant, // filled card
      // shape: RoundedRectangleBorder( // outlined card
      //   side: BorderSide(
      //     color: Theme.of(context).colorScheme.outline,
      //   ),
      //   borderRadius: const BorderRadius.all(Radius.circular(12)),
      // ),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailPage(postId: id))),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image(
                  image: NetworkImage(thumbnailUrl),
                  fit: BoxFit.cover,
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
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                  const SizedBox(width: 12),  // add some space between the avatar and the text
                  Text(
                    author,
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
