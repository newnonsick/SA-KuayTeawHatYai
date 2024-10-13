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
        imageURL = json['imageURL'],
        isAvailable = json['isAvailable'],
        type = json['type'];
}
