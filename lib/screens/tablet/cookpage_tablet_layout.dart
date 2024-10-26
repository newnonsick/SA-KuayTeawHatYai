import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuayteawhatyai/models/ingredient.dart';
import 'package:kuayteawhatyai/provider/ingredientprovider.dart';
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

  //หน้าของการจัดการออเดอร์
  Widget _orderPage() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          'จัดการออเดอร์',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  //หน้าของการจัดการวัตถุดิบ
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
          selectedCategory == null
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
          Flexible(
            child: ingredient.isAvailable
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
                  onTap: () {
                    setState(() {
                      ingredient.isAvailable = !ingredient.isAvailable;
                      print(ingredient.isAvailable);
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                            fontSize: 16,
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
  final List<OrderModel> orders = [
    OrderModel(id: "#6510405466", table: "22"),
    OrderModel(id: "#6510405491", table: "22"),
    OrderModel(id: "#6510405440", table: "22"),
    OrderModel(id: "#6510405466", table: "22"),
    OrderModel(id: "#6510405466", table: "22"),
  ];
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final isFirst = index == 0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isFirst ? Colors.amber : Colors.grey[100],
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
                              'ออเดอร์${order.id}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'โต๊ะ: ${order.table}',
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
          ),
        ],
      ),
    ));
  }

  Widget _buildOrderManagerSection() {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: const Column(
          children: [
            Text(
              'จัดการออเดอร์',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderModel {
  final String id;
  final String table;

  OrderModel({
    required this.id,
    required this.table,
  });
}
