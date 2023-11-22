class RecipeModel {
  String author;

  String authorAvatar;

  int starAmount;

  bool isFavorite;

  Map<int, String> contents;

  RecipeModel(this.author, this.authorAvatar, this.starAmount, this.isFavorite,
      this.contents);
}
