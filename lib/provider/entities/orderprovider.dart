import 'package:flutter/material.dart';
import 'package:kuayteawhatyai/entities/order.dart';

class OrderProvider with ChangeNotifier{
  Order? order;
  updateOrder(Order order){
    order.updateOrder(order);
    notifyListeners();
  }
}