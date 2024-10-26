import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuayteawhatyai/entities/order.dart';
import 'package:kuayteawhatyai/models/ingredient.dart';
import 'package:kuayteawhatyai/provider/models/ingredientprovider.dart';
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
  bool _isLoading = true;
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
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'เกิดข้อผิดพลาด';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'เกิดข้อผิดพลาด';
        _isLoading = false;
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
    if (_isLoading) {
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
          crossAxisCount: ResponsiveLayout.isPortrait(context) ? 3 : 5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
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
          ingredient.isAvailable
              ? Expanded(
                  child: Image.asset(
                    ingredient.imageURL,
                    fit: BoxFit.cover,
                    opacity: ingredient.isAvailable
                        ? null
                        : const AlwaysStoppedAnimation(.6),
                  ),
                )
              : Expanded(
                  child: Stack(fit: StackFit.expand, children: [
                    Image.asset(
                      ingredient.imageURL,
                      fit: BoxFit.cover,
                      opacity: ingredient.isAvailable
                          ? null
                          : const AlwaysStoppedAnimation(.6),
                    ),
                    Center(
                      child: Image.asset(
                        "assets/images/out_of_stock.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  ]),
                ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              ingredient.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: InkWell(
                  splashColor: Colors.transparent,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  onTap: () {
                    setState(() {
                      ingredient.isAvailable = !ingredient.isAvailable;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                    decoration: BoxDecoration(
                      color: ingredient.isAvailable
                          ? const Color(0xFFDE2E42)
                          : const Color(0xFF1E9E2A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ingredient.isAvailable
                              ? 'ปิดวัตถุดิบ'
                              : 'เปิดวัตถุดิบ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )))
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
  bool _isLoading = true;
  String? _errorMessage;
  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final data = await ApiService().getData('orders');

      if (data.data["code"] == "success") {
        setState(() {
          _orderList = (data.data['orders'] as List)
              .map((orderJson) => Order.fromJson(orderJson))
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'เกิดข้อผิดพลาด';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'เกิดข้อผิดพลาด';
        _isLoading = false;
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
    if (_isLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Expanded(
        child: Center(child: Text(_errorMessage!)),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _orderList.length,
        itemBuilder: (context, index) {
          final order = _orderList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Handle order selection
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
      ),
    );
  }

  Widget _buildOrderManagerSection() {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Text(
              'ออเดอร์ #6510405466 / โต๊ะ 22',
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
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: _orderList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: _buildMenuItem(
                            image: 'assets/images/mock.png',
                            title: 'ก๋วยเตี๋ยวน้ำใส',
                            subtitle: 'ประเภทเส้น : เส้นเล็ก',
                            note: 'ไม่ใส่ผักดอง, ไม่เอาน้ำ',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String image,
    required String title,
    String? subtitle,
    String? note,
    bool isCompleted = false,
    bool isHighlighted = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.amber : Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Food image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(image),
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
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                if (note != null)
                  Text(
                    note,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),

          // Completed checkmark
          if (isCompleted)
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
