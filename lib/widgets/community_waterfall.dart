// import 'package:flutter/material.dart';
// import 'package:seecooker/widgets/community_card.dart';
// import 'package:waterfall_flow/waterfall_flow.dart';
//
// class CommunityWaterfall extends StatefulWidget {
//   const CommunityWaterfall({super.key});
//
//   @override
//   State<CommunityWaterfall> createState() => _CommunityWaterfallState();
// }
//
// class _CommunityWaterfallState extends State<CommunityWaterfall> {
//   @override
//   Widget build(BuildContext context) {
//     return WaterfallFlow.builder(
//       padding: const EdgeInsets.all(16),
//       gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 8,
//         mainAxisSpacing: 8,
//       ),
//       itemBuilder: (BuildContext context, int index) {
//         return const CommunityCard(
//             id: index,
//             thumbnailUrl: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
//             author: 'author',
//             title: 'title',
//             avatarUrl: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg');
//       },
//       itemCount: 10,
//     );
//   }
// }