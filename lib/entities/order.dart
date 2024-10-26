class Order {
  DateTime? date;
  String? orderID;
  String? tableNumber;
  String? orderStatus;
  int? totalAmount;

  Order({
    this.date,
    this.orderID,
    this.tableNumber,
    this.totalAmount,
  });

  Order.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        orderID = json['order_id'],
        tableNumber = json['table_number'],
        orderStatus = json['order_status'],
        totalAmount = json['total_amount'];
}
