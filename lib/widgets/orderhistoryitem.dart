import 'package:flutter/material.dart';
import 'package:kuayteawhatyai/services/apiservice.dart';

class OrderHistoryItem extends StatefulWidget {
  final Map<String, dynamic> order;
  const OrderHistoryItem({super.key, required this.order});

  @override
  State<OrderHistoryItem> createState() => _OrderHistoryItemState();
}

class _OrderHistoryItemState extends State<OrderHistoryItem> {
  bool _toggle = false;
  Map<String, dynamic>? _orderItemCache;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (_orderItemCache == null) {
          final response =
              await ApiService().getData("orders/${widget.order["order_id"]}");
          if (response.data["code"] == "success") {
            _orderItemCache = response.data;
          }
        }

        setState(() {
          _toggle = !_toggle;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.fromLTRB(5, 5, 5, 15),
        decoration: BoxDecoration(
          color:
              _toggle ? const Color(0xFFF8C324).withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _toggle ? const Color(0xFFEDC00F) : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            if (!_toggle)
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(),
            const SizedBox(height: 10),
            _buildOrderDetails(),
            const SizedBox(height: 10),
            if (_toggle) _buildExpandedMenuItems(),
            const SizedBox(height: 8),
            _buildTotalAmount(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Row(
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
        Icon(
          _toggle ? Icons.expand_less : Icons.expand_more,
          color: const Color(0xFFEDC00F),
        ),
      ],
    );
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

  Widget _buildExpandedMenuItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _orderItemCache!["menus"].map<Widget>((data) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.circle,
                    size: 8,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "${data["menu"]["name"]} ${_getPortionText(data["portion"])} x${data["quantity"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              for (var ingredient in data["ingredients"])
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 8,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          ingredient,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                  
                    ],  
                  ),
                ),
            ],
          ),
        );
      }).toList(),
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

  String _getPortionText(dynamic portion) {
    print(portion);

    if (portion == null || portion == "ธรรมดา") return "";
    return "(${portion})";
  }
}
