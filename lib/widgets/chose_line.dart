import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/providers/explore_post_provider.dart';

class ChoseLine extends StatelessWidget{
  const ChoseLine({super.key, required this.title, required this.dishesFilter});
  final String title;
  final List<String> dishesFilter;
  @override
  Widget build(BuildContext context) {
    return Consumer<ExplorePostProvider>(
      builder: (context, provider, child){
        return Column(
            children: [Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
              Container(
                  height: MediaQuery.of(context).size.height/4,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 3,
                        color: Theme.of(context).colorScheme.primaryContainer),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: ListView(children: [Wrap(
                    spacing: 5.0,
                    children: dishesFilter.map((String dish) {
                      return FilterChip(
                        label: Text(dish),
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
                  )],)
              )
            ]
        );
      }
      ,);
  }
}