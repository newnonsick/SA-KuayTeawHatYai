import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuayteawhatyai/services/apiservice.dart';

class ViewOrderDialog extends StatelessWidget {
  final Map<String, dynamic> order;
  const ViewOrderDialog({super.key, required this.order});

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
              Align(
                alignment: Alignment.center,
                child: Text(
                  'ออร์เดอร์ #${order["order_id"]}',
                  style: const TextStyle(
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
                    'โต๊ะ ${order["table_number"]}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
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
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchMenuInOrder() async {
    final response = await ApiService().getData("orders/${order["order_id"]}");
    return response.data;
  }
}
