import 'package:kuayteawhatyai/models/menu.dart';

class OrderItem {
  String orderItemId;
  Menu menu;
  int quantity;
  double price;
  List<dynamic> ingredients;
  String? extraInfo;
  String? portion;
  String? orderItemStatus;

  OrderItem({
    required this.orderItemId,
    required this.menu,
    required this.quantity,
    required this.price,
    required this.ingredients,
    this.extraInfo,
    required this.portion,
    required this.orderItemStatus,
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
      'orderItemStatus': orderItemStatus,
    };
  }
}
