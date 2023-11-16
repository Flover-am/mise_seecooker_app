import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class DetailPage extends StatefulWidget {
  final int id;

  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late String avatarUrl;
  late String author;
  late String title;
  late String content;

  @override
  void initState() {
    avatarUrl = 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg';
    author = 'author';
    title = 'title';
    content = 'contentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontent';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                author,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Icon(Icons.share_outlined),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 400,
              child: Swiper(
                scale: 0.8,
                loop: false,
                indicatorLayout: PageIndicatorLayout.COLOR,
                itemBuilder: (BuildContext context,int index){
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 32
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        child: Image.network(
                          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  );
                },
                itemCount: 3,
                pagination: SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.grey,
                    activeColor: Theme.of(context).colorScheme.primary,
                  )
                ),
                control: null,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(content)
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: '评论',
              icon: const Icon(Icons.notes),
              onPressed: () {},
            ),
            IconButton(
              tooltip: '喜欢',
              icon: const Icon(Icons.favorite_outline),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingActionButton(
          elevation: 0,
          child: const Icon(Icons.edit),
          onPressed: null
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      // bottomNavigationBar: SizedBox(
      //   height: 48,
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 16),
      //     child: Row(
      //       children: <Widget>[
      //         Expanded(
      //           child: Container(
      //             decoration: BoxDecoration(
      //               color: Colors.grey.withOpacity(0.2),
      //               borderRadius: BorderRadius.circular(16),
      //             ),
      //             child: TextField(),
      //           )
      //         ),
      //         SizedBox(width: 16),
      //         IconButton(icon: Icon(Icons.thumb_up_outlined), onPressed: () {}),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}