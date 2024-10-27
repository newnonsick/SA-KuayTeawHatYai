import 'package:kuayteawhatyai/models/menu.dart';

class Order {
  Menu menu;
  int quantity;
  List<String>? ingredients;
  String? extraInfo;
  String? portion;
  double? orderPrice;
  String? orderStatus;


  Order({
    required this.menu,
    required this.quantity,
    this.ingredients,
    this.extraInfo,
    this.portion,
    this.orderPrice,
    this.orderStatus,
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
