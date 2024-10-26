import 'package:kuayteawhatyai/models/menu.dart';

class Order {
  Menu menu;
  int quantity;
  List<String>? ingredients;
  String? extraInfo;
  String? portion;

  Order({
    required this.menu,
    required this.quantity,
    this.ingredients,
    this.extraInfo,
    this.portion,
  });

  Map<String, dynamic> toJson() {
    return {
      'menu': menu.toJson(),
      'quantity': quantity,
      'ingredients': ingredients,
      'portion': portion,
      'extraInfo': extraInfo,
    };
  }
}
