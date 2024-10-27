import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kuayteawhatyai/entities/order.dart';
import 'package:kuayteawhatyai/entities/order_item.dart';
import 'package:kuayteawhatyai/models/ingredient.dart';
import 'package:kuayteawhatyai/models/menu.dart';
import 'package:kuayteawhatyai/provider/entities/orderitemprovider.dart';
import 'package:kuayteawhatyai/provider/entities/orderlistprovider.dart';
import 'package:kuayteawhatyai/provider/entities/orderprovider.dart';
import 'package:kuayteawhatyai/services/apiservice.dart';
import 'package:kuayteawhatyai/utils/responsive_layout.dart';
import 'package:kuayteawhatyai/widgets/customnavigationrail.dart';
import 'package:kuayteawhatyai/widgets/customnavigationrailitem.dart';
import 'package:provider/provider.dart';

class CookPageTabletLayout extends StatefulWidget {
  const CookPageTabletLayout({super.key});

  @override
  State<CookPageTabletLayout> createState() => _CookPageTabletLayoutState();
}

class _CookPageTabletLayoutState extends State<CookPageTabletLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // return ResponsiveLayout.isPortrait(context)
    //     ? const PortraitModePage()
    //     : _buildLandScape();
    return _buildLandScape();
  }

  Widget _buildLandScape() {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            _buildCustomNavigationRail(),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: const [
                  _OrderPage(),
                  _MaterialManagementPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomNavigationRail() {
    return CustomNavigationRail(children: [
      CustomNavigationRailItem(
        icon: Icons.article,
        label: 'ออเดอร์',
        index: 0,
        selectedIndex: _selectedIndex,
        onItemTapped: (int value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
      CustomNavigationRailItem(
        icon: Icons.edit,
        label: 'จัดการวัตถุดิบ',
        index: 1,
        selectedIndex: _selectedIndex,
        onItemTapped: (int value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
      CustomNavigationRailItem(
        icon: Icons.arrow_back_ios_new,
        label: 'กลับ',
        index: -1,
        selectedIndex: _selectedIndex,
        onItemTapped: (int value) {
          Get.back();
        },
      ),
    ]);
  }

  Widget _buildCustomNavigationRailItem({
    required IconData icon,
    required String label,
    required int index,
    ValueChanged<void>? onTap,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap(null);
        } else {
          setState(() {
            _selectedIndex = index;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF8C324) : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                  child: Icon(
                icon,
                color: Colors.black,
                size: 25,
              )),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            if (index != -1)
              Container(
                height: 2,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class _MaterialManagementPage extends StatefulWidget {
  const _MaterialManagementPage({super.key});

  @override
  State<_MaterialManagementPage> createState() =>
      _MaterialManagementPageState();
}

class _MaterialManagementPageState extends State<_MaterialManagementPage> {
  String? selectedCategory;
  List<Ingredient> _ingredientList = [];
  bool _isOrderLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchIngredients();
  }

  Future<void> _fetchIngredients() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final data = {
        'code': 'success',
        "ingredients": [
          {
            "name": "ไข่ไก่",
            "imageURL": "assets/images/mock.png",
            "isAvailable": true,
            "type": "หมวดเนื้อสัตว์"
          },
          {
            "name": "เส้นก๋วยเตี๋ยว",
            "imageURL": "assets/images/mock.png",
            "isAvailable": true,
            "type": "หมวดเส้น"
          },
          {
            "name": "ผักชี",
            "imageURL": "assets/images/mock.png",
            "isAvailable": true,
            "type": "หมวดผัก"
          },
          {
            "name": "เนื้อวัว",
            "imageURL": "assets/images/mock.png",
            "isAvailable": true,
            "type": "หมวดเนื้อสัตว์"
          },
          {
            "name": "เส้นเล็ก",
            "imageURL": "assets/images/mock.png",
            "isAvailable": true,
            "type": "หมวดเส้น"
          },
          {
            "name": "ผักกาดหอม",
            "imageURL": "assets/images/mock.png",
            "isAvailable": true,
            "type": "หมวดผัก"
          },
          {
            "name": "เนื้อหมู",
            "imageURL": "assets/images/mock.png",
            "isAvailable": true,
            "type": "หมวดเนื้อสัตว์"
          },
          {
            "name": "เส้นใหญ่",
            "imageURL": "assets/images/mock.png",
            "isAvailable": true,
            "type": "หมวดเส้น"
          },
          {
            "name": "ผักชีลาว",
            "imageURL": "assets/images/mock.png",
            "isAvailable": true,
            "type": "หมวดผัก"
          },
        ]
      };

      if (data["code"] == "success") {
        setState(() {
          _ingredientList = (data['ingredients'] as List)
              .map((ingredientJson) => Ingredient.fromJson(ingredientJson))
              .toList();
          _isOrderLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'เกิดข้อผิดพลาด';
          _isOrderLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'เกิดข้อผิดพลาด';
        _isOrderLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'จัดการวัตถุดิบ',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryItem(Icons.egg, 'หมวดเนื้อสัตว์'),
                _buildCategoryItem(Icons.restaurant, 'หมวดเส้น'),
                _buildCategoryItem(Icons.grass, 'หมวดผัก'),
              ],
            ),
          ),
          _buildIngredientSection(),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedCategory != label
              ? selectedCategory = label
              : selectedCategory = null;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  selectedCategory == label ? Colors.amber : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  List<Ingredient> _buildFilteredIngredientItems() {
    if (selectedCategory == null) {
      return _ingredientList;
    }
    return _ingredientList.where((ingredient) {
      return ingredient.type == selectedCategory;
    }).toList();
  }

  Widget _buildIngredientSection() {
    if (_isOrderLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Expanded(
        child: Center(child: Text(_errorMessage!)),
      );
    }

    final filteredIngredientList = _buildFilteredIngredientItems();

    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveLayout.isPortrait(context) ? 3 : 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7811,
        ),
        itemCount: filteredIngredientList.length,
        itemBuilder: (context, index) {
          final ingredient = filteredIngredientList[index];
          return _buildIngredientItem(ingredient);
        },
      ),
    );
  }

  Widget _buildIngredientItem(Ingredient ingredient) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    ingredient.name,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GFToggle(
                  key: ValueKey(ingredient.name),
                  onChanged: (value) {
                    setState(() {
                      ingredient.isAvailable = !ingredient.isAvailable;
                    });
                  },
                  value: ingredient.isAvailable,
                  enabledThumbColor: Colors.white,
                  enabledTrackColor: Color(0xFF1E9E2A),
                  disabledTrackColor: Color(0xFFDE2E42),
                  type: GFToggleType.ios,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                ingredient.imageURL,
                fit: BoxFit.cover,
                opacity: ingredient.isAvailable
                    ? null
                    : const AlwaysStoppedAnimation(.5),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _OrderPage extends StatefulWidget {
  const _OrderPage({super.key});

  @override
  State<_OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<_OrderPage> {
  List<Order> _orderList = [];
  bool _isOrderLoading = true;
  bool _isMenuLoading = false;
  String? _errorOrderMessage;
  String? _errorMenuMessage;
  Order? _selectedOrder;
  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchMenus() async {
    _isMenuLoading = true;
    try {
      var data =
          await ApiService().getData('orders/${_selectedOrder!.orderID}');
      if (data.data['code'] == 'success') {
        _selectedOrder!.orderItemProvider = OrderItemProvider();
        for (var item in data.data['menus']) {
          OrderItem orderItem = OrderItem(
              orderItemId: item['order_item_id'],
              menu: Menu.fromJson(item['menu']),
              quantity: item['quantity'],
              price: item['order_price'],
              ingredients: item['ingredients'],
              portion: item['portion'],
              extraInfo: item['extraInfo']);
          _selectedOrder!.orderItemProvider!.addOrder(orderItem);
        }
        setState(() {
          _isMenuLoading = false;
        });
      } else {
        setState(() {
          _errorMenuMessage = 'เกิดข้อผิดพลาด';
          _isMenuLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMenuMessage = 'เกิดข้อผิดพลาด';
        _isMenuLoading = false;
      });
    }
  }

  Future<void> _fetchOrders() async {
    try {
      print(_errorMenuMessage);
      var data = await ApiService().getData('orders');
      if (data.data['code'] == 'success') {
        setState(() {
          _orderList = (data.data['orders'] as List)
              .map((orderJson) => Order.fromJson(orderJson))
              .toList();
          _isOrderLoading = false;
        });
      } else {
        setState(() {
          _errorOrderMessage = 'เกิดข้อผิดพลาด';
          _isOrderLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorOrderMessage = 'เกิดข้อผิดพลาด';
        _isOrderLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildPendingOrderSection(),
        _buildOrderManagerSection(),
      ],
    );
  }

  Widget _buildPendingOrderSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Text(
              'ออเดอร์คงเหลือ',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'All orders',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Order list
                  _buildPendingOrderItem()
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPendingOrderItem() {
    if (_isOrderLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorOrderMessage != null) {
      return Expanded(
        child: Center(child: Text(_errorOrderMessage!)),
      );
    }

    return Consumer<OrderListProvider>(
      builder: (context, orderListProvider, child) {
        orderListProvider.orderList = _orderList;
        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orderListProvider.orderList.length,
            itemBuilder: (context, index) {
              return Consumer<OrderProvider>(
                builder: (context, orderProvider, child) {
                  orderProvider.order = orderListProvider.orderList[index];
                  final order = orderProvider.order!;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: _selectedOrder == order
                          ? Colors.amber
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedOrder = order;
                            _fetchMenus();
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ออเดอร์${order.orderID}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'โต๊ะ: ${order.tableNumber}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildOrderManagerSection() {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: _selectedOrder == null
                ? const Text(" ",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ))
                : Text("โต๊ะ ${_selectedOrder!.tableNumber}",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'รายละเอียดเมนู',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Order list
                  if (_isMenuLoading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_errorMenuMessage != null)
                    Expanded(
                      child: Center(child: Text(_errorMenuMessage!)),
                    )
                  else if (_selectedOrder?.orderItemProvider?.orderItems !=
                      null)
                    Expanded(
                        child: Column(
                      children: [
                        // รายการเมนู
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: _selectedOrder!
                                .orderItemProvider!.orderItems.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: _buildMenuItem(_selectedOrder!
                                    .orderItemProvider!.orderItems[index]),
                              );
                            },
                          ),
                        ),
                        // ปุ่มเริ่มทำอาหาร
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text(
                                'เริ่มทำอาหาร',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
                  else
                    const Expanded(
                      child: Center(child: Text('กรุณาเลือกออเดอร์')),
                    )
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMenuItem(OrderItem orderItem) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Food image
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

          // Menu details
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
                if (orderItem.extraInfo != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      orderItem.extraInfo!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Completed checkmark
          if (true)
            Container(
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
            ),
        ],
      ),
    );
  }
}
