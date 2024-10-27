import 'package:kuayteawhatyai/services/apiservice.dart';

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
  Future<void> updateIngredientAvailability() async {
    
    isAvailable = !isAvailable;
    await ApiService().putData("/ingredients/update-status", {
    "name": name,
    "is_available": isAvailable,
});
  }
}
