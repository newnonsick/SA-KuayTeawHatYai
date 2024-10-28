import 'package:flutter/material.dart';
import 'package:kuayteawhatyai/services/apiservice.dart';

class ManageOrderProvider with ChangeNotifier {
  List<dynamic> orders = [];

  void addOrder(dynamic order) {
    orders.insert(0, order);
    notifyListeners();
  }

  Future<bool> removeOrder(dynamic order) async {
    orders.remove(orders[orders
        .indexWhere((element) => element['order_id'] == order['order_id'])]);

    final response = await ApiService()
        .deleteData("orders/delete", data: {"order_id": order['order_id']});

    if (response.data["code"] == "success" || (response.data["code"] != "success" && response.data["message"] == "Order does not exist.")) {
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> changeOrderStatus(dynamic order, String status) async {
    orders[orders
            .indexWhere((element) => element['order_id'] == order['order_id'])]
        ['order_status'] = status;
    final response = await ApiService().putData("orders/update-status",
        {"order_id": order['order_id'], "order_status": status});

    if (response.data["code"] == "success") {
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }


  Future<bool> updateOrderTable(dynamic order, String tableNumber) async {
    orders[orders
            .indexWhere((element) => element['order_id'] == order['order_id'])]
        ['table_number'] = tableNumber;
    final response = await ApiService().putData("orders/update-table",
        {"order_id": order['order_id'], "table_number": tableNumber});

    if (response.data["code"] == "success") {
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void clearOrders() {
    orders.clear();
    notifyListeners();
  }

  List<dynamic> getOrders() {
    return orders;
  }

  // { this is the format of the order
  //           "order_datetime": "2024-10-27 23:13:36",
  //           "order_id": "fb9bcdfc-73f4-4bc2-9060-d22b671f01d1",
  //           "order_status": "รอทำอาหาร",
  //           "table_number": "A04",
  //           "total_amount": 315.0
  //       },

  List<dynamic> getOrdersByStatus(String status) {
    if (status == "ทั้งหมด") {
      return orders;
    }
    return orders
        .where((element) => element['order_status'] == status)
        .toList();
  }

  Future<Map<String, dynamic>> fetchOrders() async {
    final response = await ApiService().getData("orders");
    if (response.data["code"] == "success") {
      orders = response.data["orders"];
      notifyListeners();
    }

    return response.data;
  }
}
