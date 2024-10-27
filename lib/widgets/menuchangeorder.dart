import 'package:flutter/material.dart';
import 'package:kuayteawhatyai/provider/entities/menuchangeingredientprovider.dart';
import 'package:kuayteawhatyai/widgets/editmenudialog.dart';
import 'package:provider/provider.dart';

class MenuChangeOrder extends StatefulWidget {
  const MenuChangeOrder({super.key});

  @override
  State<MenuChangeOrder> createState() => _MenuChangeOrderState();
}

class _MenuChangeOrderState extends State<MenuChangeOrder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            Provider.of<MenuChangeIngredientProvider>(context, listen: false)
                .fetchMenus(),
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
          return Consumer(
              builder: (context, MenuChangeIngredientProvider provider, child) {
            return ListView.builder(
              itemCount: provider.getMenus().length,
              itemBuilder: (context, index) {
                final menu = provider.getMenus()[index];
                return _buildMenuCard(menu);
              },
            );
          });
        });
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
                      builder: (context) => EditMenuDialog(menu: menu, onApply: (order) {
                        Provider.of<MenuChangeIngredientProvider>(context, listen: false).updateMenu(order);
                      },));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
