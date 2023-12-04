import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/providers/explore_post_provider.dart';

class ChosePage extends StatelessWidget {
  const ChosePage({Key? key, required this.title, required this.dishesFilter, required this.subtitle}) : super(key: key);

  final String title;
  final String subtitle;
  final List<String> dishesFilter;

  @override
  Widget build(BuildContext context) {
    return Consumer<ExplorePostProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
              child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(width: 10), // 标题和图标之间的间距
                  Icon(Icons.add_circle_outline), // 放在标题右边的图标
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.2),
              child: Text(
                subtitle,
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Scrollbar (
                  thumbVisibility: true,
                  child: ListView(
                  children: [
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 5.0,
                      children: dishesFilter.map((String dish) {
                        return FilterChip(
                          label: Text(
                            dish,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          selected: provider.contain(dish),
                          onSelected: (bool selected) {
                            if (selected) {
                              provider.add(dish);
                            } else {
                              provider.remove(dish);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),)
              ),
            ),
          ],
        );
      },
    );
  }
}
