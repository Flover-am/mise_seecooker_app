import 'package:flutter/material.dart';

class AuthorInfoBar extends StatelessWidget {
  final String authorAvatar;
  final String authorName;
  const AuthorInfoBar({super.key, required this.authorAvatar, required this.authorName});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: Image.network(authorAvatar).image,
        ),
        Container(
            margin:
            const EdgeInsets.symmetric(horizontal: 10),
            child: Text(authorName)),
      ],
    );
  }
}
