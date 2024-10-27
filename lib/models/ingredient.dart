class Ingredient {
  String name;
  String imageURL;
  bool isAvailable;
  String type;
  //constructor
  Ingredient({
    required this.name,
    required this.imageURL,
    required this.isAvailable,
    required this.type,
  });
  //from Json
  Ingredient.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        imageURL = json['image_url'],
        isAvailable = json['is_available'],
        type = json['ingredient_type'];
}
