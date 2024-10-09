import 'package:flutter/material.dart';
import 'package:kuayteawhatyai/models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
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
      totalPrice += order.menu.price * order.quantity;
    }
    return totalPrice;
  }
}
