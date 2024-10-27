import 'package:flutter/material.dart';
import 'package:kuayteawhatyai/services/apiservice.dart';

class MenuChangeIngredientProvider with ChangeNotifier {
  List<dynamic> menus = [];

  void addMenu(dynamic menu) {
    menus.insert(0, menu);
    notifyListeners();
  }

  Future<bool> updateMenu(dynamic menu) async {
    final response = await ApiService().putData(
      'orders/update-item',
      {
        "order_item_id": menu['order_item_id'],
        "ingredients": menu['ingredients'],
        "portion": menu['portion'],
        "extraInfo": menu['extraInfo'],
      },
    );

    if (response.data['code'] == 'success') {
      menus.remove(menus[menus.indexWhere(
          (element) => element['order_item_id'] == menu['order_item_id'])]);

      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchMenus() async {
    final response =
        await ApiService().getData("orders/items?status=เปลี่ยนวัตถุดิบ");
    if (response.data["code"] == "success") {
      menus = response.data["order_items"];
      notifyListeners();
    }

    return response.data;
  }

  List<dynamic> getMenus() {
    return menus;
  }
}
