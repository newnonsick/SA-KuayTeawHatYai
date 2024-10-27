import 'package:flutter/material.dart';
import 'package:kuayteawhatyai/entities/order_item.dart';

class OrderItemProvider with ChangeNotifier {
  List<OrderItem> _orderItems = [];

  void addOrder(OrderItem orderItem) {
    for (OrderItem o in _orderItems) {
      if (o.menu.name == orderItem.menu.name &&
          o.portion == orderItem.portion &&
          o.extraInfo == orderItem.extraInfo) {
        bool sameIngredients = true;

        for (String ingredient in orderItem.ingredients!) {
          if (!o.ingredients!.contains(ingredient)) {
            sameIngredients = false;
            break;
          }
        }

        if (sameIngredients) {
          o.quantity += orderItem.quantity;
          notifyListeners();
          return;
        }
      }
    }

    _orderItems.add(orderItem);
    notifyListeners();
  }
  get orderItems => _orderItems;
}
