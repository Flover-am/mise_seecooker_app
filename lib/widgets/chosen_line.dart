/// 各个分类具体菜品的展示和选择框

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/providers/explore/explore_post_provider.dart';

class ChosenLine extends StatelessWidget{
  const ChosenLine({super.key, required this.title, required this.dishesFilter});
  final String title;
  final List<String> dishesFilter;
  @override
  Widget build(BuildContext context) {
    return Consumer<ExplorePostProvider>(
      builder: (context, provider, child){
        return Column(
            children: [
              Expanded(child: Text(title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),),
              Expanded(
                flex: 4,
                  child:
              Container(
                  height: MediaQuery.of(context).size.height/4,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child:
                  ListView(children: [
                    Wrap(
                    spacing: 5.0,
                    children: dishesFilter.map((String dish) {
                      return FilterChip(
                        label: Text(dish,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
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
              )

            ]
        );
      }
      ,);
  }
}