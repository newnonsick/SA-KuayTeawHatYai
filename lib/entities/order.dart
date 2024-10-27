import 'package:kuayteawhatyai/provider/entities/orderitemprovider.dart';
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
  
  updateOrder(Order order) {
    date = order.date;
    orderID = order.orderID;
    tableNumber = order.tableNumber;
    orderStatus = order.orderStatus;
    totalAmount = order.totalAmount;
    orderItemProvider = order.orderItemProvider;
  }
}

