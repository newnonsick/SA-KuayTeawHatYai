import 'package:kuayteawhatyai/models/menu.dart';

class Order {
  Menu menu;
  int quantity;
  List<String>? ingredients;
  String? extraInfo;

  Order({
    required this.menu,
    required this.quantity,
    this.ingredients,
    this.extraInfo,
  });
}
