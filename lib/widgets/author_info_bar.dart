import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/account/other_account_page.dart';
import '../providers/other_user/other_user_provider.dart';
import '../providers/post_detail_provider.dart';

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
        //TODO:try it when publication function is available
        // GestureDetector(
        //   onTap: () async {
        //     OtherUserProvider otherUserProvider = Provider.of<OtherUserProvider>(context,listen: false);
        //     PostDetailProvider postDetailProvider = Provider.of<PostDetailProvider>(context,listen: false);
        //     await otherUserProvider.getUserById(postDetailProvider.model.posterId);
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => OtherAccountPage()),
        //     );
        //   },
        //   child: CircleAvatar(
        //     backgroundImage: Image.network(authorAvatar).image,
        //   ),
        // ),


        Container(
            margin:
            const EdgeInsets.symmetric(horizontal: 10),
            child: Text(authorName)),
      ],
    );
  }
}
