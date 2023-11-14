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

  @override
  void initState() {
    avatarUrl = 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg';
    author = 'author';
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
        child: Swiper(
          itemBuilder: (BuildContext context,int index){
            return Image.network('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',fit: BoxFit.fill,);
          },
          itemCount: 3,
          pagination: SwiperPagination(),
          control: null,
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(),
                )
              ),
              SizedBox(width: 16),
              IconButton(icon: Icon(Icons.thumb_up_outlined), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}