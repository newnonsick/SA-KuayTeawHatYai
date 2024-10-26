import 'package:kuayteawhatyai/models/menu.dart';

class OrderItem {
  String orderItemId;
  Menu menu;
  String orderId;
  int quantity;
  double price;
  List<String>? ingredients;
  String? extraInfo;
  String? portion;

  OrderItem({
    required this.orderItemId,
    required this.menu,
    required this.orderId,
    required this.quantity,
    required this.price,
    this.ingredients,
    this.extraInfo,
    required this.portion,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderItemId': orderItemId,
      'menu': menu.toJson(),
      'orderId': orderId,
      'quantity': quantity,
      'price': price,
      'ingredients': ingredients,
      'portion': portion,
      'extraInfo': extraInfo,
    };
  }
}