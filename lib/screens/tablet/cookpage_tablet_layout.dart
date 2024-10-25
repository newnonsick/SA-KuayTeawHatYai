import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuayteawhatyai/models/ingredient.dart';
import 'package:kuayteawhatyai/utils/responsive_layout.dart';

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
                children: [
                  _orderPage(),
                  const _MaterialManagementPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomNavigationRail() {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: Colors.grey[400]!,
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildCustomNavigationRailItem(
              icon: Icons.article,
              label: 'ออเดอร์',
              index: 0,
            ),
            _buildCustomNavigationRailItem(
              icon: Icons.edit,
              label: 'จัดการวัตถุดิบ',
              index: 1,
            ),
            _buildCustomNavigationRailItem(
              icon: Icons.arrow_back_ios_new,
              label: 'กลับ',
              index: -1,
              onTap: (_) => Get.back(),
            ),
          ],
        ),
      ),
    );
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
          FutureBuilder(
            future: _fetchIngredients(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError ||
                  (snapshot.hasData && (snapshot.data!["code"] != "success"))) {
                return const Expanded(
                    child: Center(child: Text('เกิดข้อผิดพลาด')));
              }
              final ingredients = snapshot.data!['ingredients'] as List;
              _ingredientList = ingredients.map((ingredientJson) {
                return Ingredient.fromJson(ingredientJson);
              }).toList();
              print(_ingredientList);
              final filteredIngredientList = _buildFilteredFoodItems();
              return Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveLayout.isPortrait(context) ? 4 : 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filteredIngredientList.length,
                  itemBuilder: (context, index) {
                    final ingredient = filteredIngredientList[index];
                    return _buildFoodItem(ingredient.name, ingredient.imageURL);
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedCategory = label;
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

  List<Ingredient> _buildFilteredFoodItems() {
    if (selectedCategory == null) {
      return _ingredientList;
    }
    return _ingredientList.where((ingredient) {
      return ingredient.type == selectedCategory;
    }).toList();
  }

  Widget _buildFoodItem(String name, String imagePath) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchIngredients() async {
    await Future.delayed(const Duration(microseconds: 1));
    return {
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
  }
}
