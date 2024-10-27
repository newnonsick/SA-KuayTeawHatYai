import 'package:flutter/material.dart';
import 'package:kuayteawhatyai/provider/entities/manageorderprovider.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class ManageOrderItem extends StatefulWidget {
  final Map<String, dynamic> order;
  const ManageOrderItem({super.key, required this.order});

  @override
  State<ManageOrderItem> createState() => _ManageOrderItemState();
}

class _ManageOrderItemState extends State<ManageOrderItem> {
  // Example order structure
  // {
  //   "order_datetime": "2024-10-27 23:13:36",
  //   "order_id": "fb9bcdfc-73f4-4bc2-9060-d22b671f01d1",
  //   "order_status": "กำลังทำอาหาร",
  //   "table_number": "A04",
  //   "total_amount": 315.0
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildOrderHeader(),
          const SizedBox(height: 10),
          _buildOrderDetails(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTotalAmount(),
              _buildOrderStatus(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHeader() {
    return SizedBox(
      height: 125,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              "Order #${widget.order["order_id"]}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFFEDC00F),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (String value) async {
              if (value == "เสิร์ฟอาหาร") {
                await _handleServeOrder(widget.order);
              } else if (value == "ยกเลิก") {
                await _handleCancelOrder();
              } else if (value == "แก้ไข") {
                // _handleEditOrder();
              } else if (value == "ดูรายการอาหาร") {
                // _handleViewOrderItems();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              ..._getPopupMenuItem(widget.order["order_status"]),
            ],
          ),
        ],
      ),
    );
  }

  List<PopupMenuEntry<String>> _getPopupMenuItem(String status) {
    // รอทำอาหาร
    // กำลังทำอาหาร
    // รอเสิร์ฟ
    // เสร็จสิ้น

    if (status == "เสร็จสิ้น" || status == "กำลังทำอาหาร") {
      return [
        const PopupMenuItem<String>(
          value: 'ดูรายการอาหาร',
          child: Row(
            children: [
              Icon(Icons.list_alt, color: Color(0xFFEDC00F)),
              SizedBox(width: 10),
              Text(
                'ดูรายการอาหาร',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ];
    } else if (status == "รอเสิร์ฟ") {
      return [
        const PopupMenuItem<String>(
          value: 'ดูรายการอาหาร',
          child: Row(
            children: [
              Icon(Icons.list_alt, color: Color(0xFFEDC00F)),
              SizedBox(width: 10),
              Text(
                'ดูรายการอาหาร',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'เสิร์ฟอาหาร',
          child: Row(
            children: [
              Icon(Icons.delivery_dining, color: Color(0xFFEDC00F)),
              SizedBox(width: 10),
              Text(
                'เสิร์ฟอาหาร',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ];
    } else {
      return [
        const PopupMenuItem<String>(
          value: 'ดูรายการอาหาร',
          child: Row(
            children: [
              Icon(Icons.list_alt, color: Color(0xFFEDC00F)),
              SizedBox(width: 10),
              Text(
                'ดูรายการอาหาร',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'ยกเลิก',
          child: Row(
            children: [
              Icon(Icons.cancel, color: Color(0xFFEDC00F)),
              SizedBox(width: 10),
              Text(
                'ยกเลิก',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'แก้ไข',
          child: Row(
            children: [
              Icon(Icons.edit, color: Color(0xFFEDC00F)),
              SizedBox(width: 10),
              Text(
                'แก้ไข',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ];
    }
  }

  Widget _buildOrderDetails() {
    return Row(
      children: [
        const Icon(
          Icons.event_seat,
          color: Colors.grey,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          "Table ${widget.order["table_number"]}",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalAmount() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "฿ ${widget.order["total_amount"]}",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildOrderStatus() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _getStatusColor(widget.order["order_status"]),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        widget.order["order_status"],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "รอทำอาหาร":
        return Colors.red;
      case "กำลังทำอาหาร":
        return Colors.orange;
      case "รอเสิร์ฟ":
        return Colors.blue;
      case "เสร็จสิ้น":
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  Future<void> _handleServeOrder(Map<String, dynamic> order) async {
    bool isSuccess =
        await Provider.of<ManageOrderProvider>(context, listen: false)
            .changeOrderStatus(order, "เสร็จสิ้น");

    if (isSuccess && mounted) {
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        title: const Text("เสิร์ฟสำเร็จ"),
        description: const Text("Order ถูกเสิร์ฟแล้ว"),
      );
    } else if (!isSuccess && mounted) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: const Text("เกิดข้อผิดพลาด"),
        description: const Text("ไม่สามารถเสิร์ฟ Order ได้"),
      );
    }
  }

  Future<void> _handleCancelOrder() async {
    bool isSuccess =
        await Provider.of<ManageOrderProvider>(context, listen: false)
            .removeOrder(widget.order);

    if (isSuccess && mounted) {
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        title: const Text("ยกเลิกสำเร็จ"),
        description: const Text("Order ถูกยกเลิกแล้ว"),
      );
    } else if (!isSuccess && mounted) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: const Text("เกิดข้อผิดพลาด"),
        description: const Text("ไม่สามารถยกเลิก Order ได้"),
      );
    }
  }
}
