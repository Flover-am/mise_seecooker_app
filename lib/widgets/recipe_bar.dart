import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/providers/recipe_detail_provider.dart';

class RecipeBar extends StatelessWidget {
  const RecipeBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeDetailProvider>(builder: (context,value,child){
      var model = value.model;
      return SizedBox(
        height: 80,
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 IgnorePointer(
                   ignoring: model.isMarked,
                   child:  Row(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: List.generate(5, (index) {
                       return Container(
                         height: 35,
                         width: 35,
                         child: IconButton(
                             splashColor: Colors.transparent,
                             highlightColor: Colors.transparent,
                             iconSize: 35,
                             padding: EdgeInsets.zero,
                             onPressed: () {
                               value.changeStarAmount(index);
                             },
                             icon: Icon(index > value.model.starAmount
                                 ? Icons.favorite_border
                                 : Icons.favorite)),
                       );
                     }),
                   ),
                 ),
                  !model.isMarked ?IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed:value.sendMark,
                      icon: Container(
                        padding: const EdgeInsets.all(0),
                        height: 35,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Text('评价')),
                      )):Container()
                ],
              ),
              IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: model.isFavorite ? value.removeToFavorite : value.addToFavorite,
                  highlightColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  splashColor: Colors.transparent,
                  icon: Icon(model.isFavorite ? Icons.star : Icons.star_border),
                  iconSize: 35)
            ],
          ),
        ),
      );
    });
  }
}
