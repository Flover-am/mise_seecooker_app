class RecipeModel {
  String authorName;

  String authorAvatar;

  int starAmount;

  bool isFavorite;
  bool isMarked;
  Map<int, String> contents;

  RecipeModel(this.authorName, this.authorAvatar, this.starAmount,
      this.isFavorite, this.isMarked, this.contents);
}
