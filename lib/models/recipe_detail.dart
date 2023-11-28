class RecipeModel {
  String authorName;
  String authorAvatar;
  // String name;
  // String introduction;
  int starAmount;

  bool isFavorite;
  bool isMarked;
  Map<int, String> stepContents;


  RecipeModel(this.authorName, this.authorAvatar, this.starAmount,
      this.isFavorite, this.isMarked, this.stepContents);
}
