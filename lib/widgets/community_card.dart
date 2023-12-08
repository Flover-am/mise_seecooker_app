import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import '../pages/community/post_detail_page.dart';

class CommunityCard extends StatelessWidget {
  final int postId;
  final String cover;
  final String posterName;
  final String title;
  final String posterAvatar;

  const CommunityCard({
    super.key,
    required this.postId,
    required this.cover,
    required this.posterName,
    required this.title,
    required this.posterAvatar
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailPage(postId: postId))),
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
                  cache: false,
                  fit: BoxFit.cover,
                  enableLoadState: false,
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
