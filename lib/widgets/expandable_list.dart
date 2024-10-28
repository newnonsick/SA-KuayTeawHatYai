import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kuayteawhatyai/entities/order_item.dart';

class MenuList extends StatefulWidget {
  final List<OrderItem> orderItems;

  const MenuList({
    Key? key,
    required this.orderItems,
  }) : super(key: key);

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  OrderItem? expandedId;

  void toggleExpand(OrderItem orderItemId) {
    setState(() {
      if (expandedId == orderItemId) {
        expandedId = null;
      } else {
        expandedId = orderItemId;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.orderItems.length,
      itemBuilder: (context, index) {
        final orderItem = widget.orderItems[index];
        return MenuItemCard(
          orderItem: orderItem,
          isExpanded: expandedId == orderItem,
          onToggle: () => toggleExpand(orderItem),
        );
      },
    );
  }
}

class MenuItemCard extends StatefulWidget {
  final OrderItem orderItem;
  final bool isExpanded;
  final VoidCallback onToggle;

  const MenuItemCard({
    Key? key,
    required this.orderItem,
    required this.isExpanded,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(MenuItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderItem = widget.orderItem;

    return GestureDetector(
      onTap: widget.onToggle,
      child: Container(
        decoration: orderItem.orderItemStatus == "เปลี่ยนวัตถุดิบ"
            ? BoxDecoration(
                color: Color.fromARGB(96, 248, 195, 36),
                border: Border.all(color: Color(0xFFF8C324)),
                borderRadius: BorderRadius.circular(8),
              )
            : orderItem.orderItemStatus == "เสร็จสิ้น"
                ? BoxDecoration(
                    color: Color.fromARGB(50, 30, 158, 43),
                    border: Border.all(color: Color(0xFF1E9E2A)),
                    borderRadius: BorderRadius.circular(8),
                  )
                : orderItem.orderItemStatus == "กำลังทำอาหาร"
                    ? BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(orderItem.menu.imageURL),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${orderItem.menu.name} x${orderItem.quantity} (฿${orderItem.menu.price * orderItem.quantity})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        orderItem.ingredients.join(', '),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      if (orderItem.portion != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2, 0, 6),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              orderItem.portion!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          orderItem.orderItemStatus!,
                          style: TextStyle(
                            color: orderItem.orderItemStatus == 'เปลี่ยนวัตถุดิบ'
                                ? Color.fromARGB(255, 255, 115, 0)
                                : orderItem.orderItemStatus == 'เสร็จสิ้น'
                                    ? Colors.green
                                    : orderItem.orderItemStatus == 'กำลังทำอาหาร'
                                        ? Colors.black87
                                        : Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: widget.isExpanded ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: orderItem.orderItemStatus == 'เปลี่ยนวัตถุดิบ'
                            ? Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 223, 172, 4),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.exclamation,
                                  color: Color.fromARGB(255, 255, 115, 0),
                                  size: 16,
                                ),
                              )
                            : orderItem.orderItemStatus == 'เสร็จสิ้น'
                                ? Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  )
                                : orderItem.orderItemStatus == 'กำลังทำอาหาร'
                                    ? Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.access_time_outlined,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            ClipRect(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return SizeTransition(
                    sizeFactor: _heightFactor,
                    child: child,
                  );
                },
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Text(
                            orderItem.extraInfo?.isNotEmpty == true
                                ? orderItem.extraInfo!
                                : 'ไม่มีข้อมูลเพิ่มเติม',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
