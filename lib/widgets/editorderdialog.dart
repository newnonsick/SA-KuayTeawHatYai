import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuayteawhatyai/provider/entities/manageorderprovider.dart';
import 'package:kuayteawhatyai/services/apiservice.dart';
import 'package:kuayteawhatyai/widgets/editmenudialog.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class EditOrderDialog extends StatefulWidget {
  final Map<String, dynamic> order;
  const EditOrderDialog({super.key, required this.order});

  @override
  State<EditOrderDialog> createState() => _EditOrderDialogState();
}

class _EditOrderDialogState extends State<EditOrderDialog> {
  Map<String, dynamic>? order;

  @override
  void initState() {
    order = widget.order;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFFF8C324),
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Header
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'แก้ไขออร์เดอร์',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  const Icon(Icons.event_seat, color: Colors.grey, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'โต๊ะ ${order!["table_number"]}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: const Center(
                                child: Text(
                                  'กรุณาเลือกหมายเลขโต๊ะ',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF8C324),
                                  ),
                                ),
                              ),
                              content: FutureBuilder(
                                future: _fetchTables(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox(
                                      height: 200,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Color(0xFFF8C324),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.hasError ||
                                      (snapshot.hasData &&
                                          (snapshot.data!["code"] !=
                                              "success"))) {
                                    return const Center(
                                      child: Text('Error',
                                          style: TextStyle(color: Colors.red)),
                                    );
                                  }
                                  final data =
                                      snapshot.data as Map<String, dynamic>;
                                  List tableList = data['tables'] as List;
                                  List<String> tables = tableList
                                      .map((table) =>
                                          table['table_number'].toString())
                                      .toList();
                                  return SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        for (String table in tables)
                                          GestureDetector(
                                            onTap: () async {
                                              bool success = await Provider.of<
                                                          ManageOrderProvider>(
                                                      context,
                                                      listen: false)
                                                  .updateOrderTable(
                                                      widget.order, table);
                                              if (success) {
                                                if (mounted){
                                                  toastification.show(
                                                    context: context,
                                                    type: ToastificationType
                                                        .success,
                                                    style: ToastificationStyle
                                                        .flat,
                                                    title: const Text(
                                                        "เปลี่ยนโต๊ะสำเร็จ"),
                                                    description: const Text(
                                                        "อัพเดทโต๊ะสำเร็จ"),
                                                  );
                                                }
                                                Get.back();
                                                setState(() {
                                                  order!["table_number"] =
                                                      table;
                                                });
                                              } else {
                                                if (mounted) {
                                                  toastification.show(
                                                    context: context,
                                                    type: ToastificationType
                                                        .error,
                                                    style: ToastificationStyle
                                                        .flat,
                                                    title: const Text(
                                                        "เกิดข้อผิดพลาด"),
                                                    description: const Text(
                                                        "ไม่สามารถอัพเดทโต๊ะได้"),
                                                  );
                                                }
                                              }
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF8C324),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: const Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  table,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text(
                                    'ยกเลิก',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.edit,
                          color: Color(0xFFEDC00F), size: 20)),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                "รายการอาหาร",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              FutureBuilder(
                future: _fetchMenuInOrder(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFF8C324),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('เกิดข้อผิดพลาด'));
                  }

                  final menuInOrder = snapshot.data as Map<String, dynamic>;

                  return Expanded(
                    child: ListView.builder(
                      itemCount: menuInOrder["menus"].length,
                      itemBuilder: (context, index) {
                        final menu = menuInOrder["menus"][index];
                        return _buildMenuCard(menu);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to Build Each Menu Item Card
  Widget _buildMenuCard(Map<String, dynamic> menu) {
    final menuInfo = menu["menu"];
    final ingredients = menu["ingredients"].join(", ");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            // Menu Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                menuInfo["image_url"],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 80),
              ),
            ),
            const SizedBox(width: 15),

            // Menu Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        menuInfo["name"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${menuInfo["price"]} ฿",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Ingredients
                  if (ingredients.isNotEmpty)
                    Text(
                      "ส่วนประกอบ: $ingredients",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  const SizedBox(height: 8),

                  // Portion and Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (menu["portion"] != null)
                        Text(
                          "ขนาด: ${menu["portion"]}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      Text(
                        "จำนวน: ${menu["quantity"]}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFFF8C324)),
                onPressed: () {
                  showDialog(
                          context: context,
                          builder: (context) => EditMenuDialog(menu: menu))
                      .then((value) {
                    setState(() {});
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchMenuInOrder() async {
    final response = await ApiService().getData("orders/${order!["order_id"]}");
    return response.data;
  }

  Future<Map<String, dynamic>> _fetchTables() async {
    final response = await ApiService().getData('tables');
    return response.data;
  }
}
