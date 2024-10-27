import 'package:kuayteawhatyai/models/menu.dart';

class OrderItem {
  String orderItemId;
  Menu menu;
  int quantity;
  double price;
  List<dynamic> ingredients;
  String? extraInfo;
  String? portion;

  OrderItem({
    required this.orderItemId,
    required this.menu,
    required this.quantity,
    required this.price,
    required this.ingredients,
    this.extraInfo,
    required this.portion,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderItemId': orderItemId,
      'menu': menu.toJson(),
      'quantity': quantity,
      'price': price,
      'ingredients': ingredients,
      'portion': portion,
      'extraInfo': extraInfo,
    };
  }
}