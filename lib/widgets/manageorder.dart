import 'package:flutter/material.dart';
import 'package:kuayteawhatyai/provider/entities/manageorderprovider.dart';
import 'package:kuayteawhatyai/utils/responsive_layout.dart';
import 'package:kuayteawhatyai/widgets/manageorderitem.dart';
import 'package:provider/provider.dart';

class ManageOrder extends StatefulWidget {
  const ManageOrder({super.key});

  @override
  State<ManageOrder> createState() => _ManageOrderState();
}

class _ManageOrderState extends State<ManageOrder> {
  String status = "ทั้งหมด";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<ManageOrderProvider>(context, listen: false)
            .fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFF8C324),
              ),
            );
          } else if (snapshot.hasError ||
              (snapshot.hasData && (snapshot.data!["code"] != "success"))) {
            return const Center(
              child: Text('เกิดข้อผิดพลาด'),
            );
          }
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                    value: status,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFFF8C324),
                    ),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    items: <String>[
                      'ทั้งหมด',
                      'รอทำอาหาร',
                      'กำลังทำอาหาร',
                      'รอเสิร์ฟ',
                      'เสร็จสิ้น'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        status = newValue!;
                      });
                    },
                  ))
                ],
              ),
              const SizedBox(height: 10),
              Consumer(builder: (context, ManageOrderProvider provider, child) {
                if (provider.getOrdersByStatus(status).isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text('ไม่มีรายการอาหาร'),
                    ),
                  );
                }

                List orders = provider.getOrdersByStatus(status);

                return Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              ResponsiveLayout.isPortrait(context) ? 3 : 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: ResponsiveLayout.isPortrait(context)
                              ? 0.88
                              : 0.92,
                        ),
                        shrinkWrap: true,
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return ManageOrderItem(order: order);
                        }));
              }),
            ],
          );
        });
  }
}
