import 'package:kuayteawhatyai/provider/models/orderprovider.dart';

class Order {
  DateTime? date;
  String? orderID;
  String? tableNumber;
  String? orderStatus;
  double? totalAmount;
  OrderProvider? orderProvider;

  Order({
    this.date,
    this.orderID,
    this.tableNumber,
    this.totalAmount,
    this.orderStatus,
    this.orderProvider,
  });

  Order.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        orderID = json['order_id'],
        tableNumber = json['table_number'],
        orderStatus = json['order_status'],
        totalAmount = json['total_amount'];
}
