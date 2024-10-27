import 'package:kuayteawhatyai/provider/entities/orderitemprovider.dart';
import 'package:kuayteawhatyai/services/apiservice.dart';
class Order {
  DateTime? date;
  String? orderID;
  String? tableNumber;
  String? orderStatus;
  double? totalAmount;
  OrderItemProvider? orderItemProvider;

  Order({
    this.date,
    this.orderID,
    this.tableNumber,
    this.totalAmount,
    this.orderStatus,
    this.orderItemProvider,
  });

  Order.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        orderID = json['order_id'],
        tableNumber = json['table_number'],
        orderStatus = json['order_status'],
        totalAmount = json['total_amount'];
  
  Future<void> updateOrderStatus(String status) async{
    orderStatus = status;
    await ApiService().putData("orders/update-status", {
      "order_id": orderID,
      "order_status": status,
    });
  }
}

