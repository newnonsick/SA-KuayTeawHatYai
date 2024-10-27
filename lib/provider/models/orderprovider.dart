import 'package:flutter/material.dart';
import 'package:kuayteawhatyai/models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  String? tableNumber;

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    for (Order o in _orders) {
      if (o.menu.name == order.menu.name &&
          o.portion == order.portion &&
          o.extraInfo == order.extraInfo) {
        bool sameIngredients = true;

        if (order.ingredients != null) {
          for (String ingredient in order.ingredients!) {
            if (!o.ingredients!.contains(ingredient)) {
              sameIngredients = false;
              break;
            }
          }
        }

        if (sameIngredients) {
          o.quantity += order.quantity;
          notifyListeners();
          return;
        }
      }
    }

    _orders.add(order);
    notifyListeners();
  }

  void removeOrder(Order order) {
    _orders.remove(order);
    notifyListeners();
  }

  void incrementQuantity(Order order) {
    order.quantity += 1;
    notifyListeners();
  }

  void decrementQuantity(Order order) {
    if (order.quantity > 1) {
      order.quantity -= 1;
      notifyListeners();
    }
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (Order order in _orders) {
      totalPrice += (order.portion == "พิเศษ"
              ? order.menu.price + 10
              : order.menu.price) *
          order.quantity;
    }
    return totalPrice;
  }

  void clearOrder() {
    _orders = [];
    notifyListeners();
  }

  void setTableNumber(String tableNumber) {
    this.tableNumber = tableNumber;
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': _orders.map((order) => order.toJson()).toList(),
      if (tableNumber != null) 'tableNumber': tableNumber,
    };
  }
}
