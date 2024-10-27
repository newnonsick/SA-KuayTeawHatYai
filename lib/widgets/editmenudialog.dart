import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuayteawhatyai/models/menu.dart';
import 'package:kuayteawhatyai/services/apiservice.dart';
import 'package:toastification/toastification.dart';
import '../models/order.dart';

class EditMenuDialog extends StatefulWidget {
  final Map<String, dynamic> menu;
  final Function? onApply;
  const EditMenuDialog({super.key, required this.menu, this.onApply});

  @override
  State<EditMenuDialog> createState() => _EditMenuDialogState();
}

class _EditMenuDialogState extends State<EditMenuDialog> {
  Order? order;
  final TextEditingController _extraInfoController = TextEditingController();
  Map<String, List<String>>? _selectedIngredients;
  String? _selectedPortion;
  Map<String, dynamic>? _ingredientsCache;

  @override
  void initState() {
    super.initState();
    _fetchAndCacheIngredients();
  }

  Future<void> _fetchAndCacheIngredients() async {
    if (_ingredientsCache != null) return;

    try {
      final response = await ApiService()
          .getData('menus/ingredients?name=${widget.menu['menu']['name']}');
      print(response.data['code']);
      if (response.data['code'] == 'success') {
        setState(() {
          _ingredientsCache = response.data;
          _initData();
        });
      }
    } catch (error) {
      print(error);
      setState(() {
        _ingredientsCache = {'error': true};
      });
    }
  }

  void _initData() {
    final menuIngredients = widget.menu['ingredients'] ?? [];

    if (_ingredientsCache != null &&
        _ingredientsCache!['ingredients'] != null) {
      _selectedIngredients = {};

      // Loop through each ingredient type (e.g., "เนื้อสัตว์", "เส้น")
      for (var ingredientType in _ingredientsCache!['ingredients']) {
        final String type = ingredientType['type'];

        // Ensure options are treated as List<Map<String, dynamic>>
        final List<Map<String, dynamic>> options =
            List<Map<String, dynamic>>.from(ingredientType['options']);

        // Filter options that match menu ingredients and are available
        final List<String> selected = options
            .where((option) =>
                menuIngredients.contains(option['name']) &&
                option['is_available'] == true) // Check for availability
            .map((option) => option['name'] as String)
            .toList();

        // If any matching ingredient exists, store it under the correct type
        if (selected.isNotEmpty) {
          _selectedIngredients![type] = selected;
        }
      }
    }

    _selectedPortion = widget.menu['portion'];
    _extraInfoController.text = widget.menu['extraInfo'] ?? '';

    order = Order(
      menu: Menu.fromJson(widget.menu['menu']),
      ingredients: _selectedIngredients!.values.expand((e) => e).toList(),
      portion: _selectedPortion,
      extraInfo:
          _extraInfoController.text.isEmpty ? null : _extraInfoController.text,
      quantity: widget.menu['quantity'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: const EdgeInsets.all(50),
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
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.close,
                    color: Colors.transparent,
                    size: 30,
                  ),
                  const SizedBox(height: 10),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.menu['menu']['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Color(0xFFF8C324),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFFF8C324),
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(widget.menu['menu']['image_url'],
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildIngredientsSection(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_isValidOrder()) {
                    if (widget.onApply != null) {
                      widget.onApply!({
                        "order_item_id": widget.menu['order_item_id'],
                        "ingredients": order!.ingredients,
                        "portion": order!.portion,
                        "extraInfo": order!.extraInfo,
                      });
                      Get.back();
                      return;
                    }

                    final response = await ApiService().putData(
                      'orders/update-item',
                      {
                        "order_item_id": widget.menu['order_item_id'],
                        "ingredients": order!.ingredients,
                        "portion": order!.portion,
                        "extraInfo": order!.extraInfo,
                      },
                    );

                    if (response.data['code'] == 'success') {
                      if (mounted) {
                        toastification.show(
                          context: context,
                          type: ToastificationType.success,
                          style: ToastificationStyle.flat,
                          title: const Text("อัพเดทสำเร็จ"),
                          description: const Text("อัพเดทรายการสำเร็จแล้ว"),
                        );
                      }
                      Get.back();
                    } else {
                      if (mounted) {
                        toastification.show(
                          context: context,
                          type: ToastificationType.error,
                          style: ToastificationStyle.flat,
                          title: const Text("เกิดข้อผิดพลาด"),
                          description: const Text("ไม่สามารถอัพเดทรายการได้"),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  backgroundColor: const Color(0xFFF8C324),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: const FittedBox(
                  child: Text(
                    'บันทึก',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientsSection() {
    if (_ingredientsCache == null) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF8C324)),
        ),
      );
    } else if (_ingredientsCache!['error'] == true) {
      return const Center(
          child: Text('Error loading ingredients',
              style: TextStyle(color: Colors.red)));
    }

    final ingredients = _ingredientsCache!['ingredients'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var ingredient in ingredients)
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient['type'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFFF8C324),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: ingredient['options']
                      .map<Widget>((option) => _buildIngredientOption(
                            ingredient['type'],
                            option,
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        const Text(
          'ขนาด',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFFF8C324),
          ),
        ),
        const SizedBox(height: 10),
        _buildPortionSelection(),
        const SizedBox(height: 20),
        const Text(
          'ข้อมูลเพิ่มเติม',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFFF8C324),
          ),
        ),
        const SizedBox(height: 10),
        _buildExtraInfoField(),
      ],
    );
  }

  Widget _buildIngredientOption(String type, Map<String, dynamic> option) {
    final isSelected =
        _selectedIngredients![type]?.contains(option['name']) ?? false;

    return GestureDetector(
      onTap: option['is_available']
          ? () {
              setState(() {
                _toggleIngredientSelection(type, option['name']);
              });
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(169, 248, 195, 36)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey,
          ),
        ),
        child: Text(
          option['is_available'] ? option['name'] : '${option['name']} (หมด)',
          style: TextStyle(
            color: option['is_available'] ? Colors.black : Colors.red,
          ),
        ),
      ),
    );
  }

  void _toggleIngredientSelection(String type, String name) {
    _selectedIngredients![type] ??= [];
    if (name == "น้ำ" || name == "แห้ง") {
      _selectedIngredients![type]!.clear();
    }

    if (_selectedIngredients![type]!.contains(name)) {
      _selectedIngredients![type]!.remove(name);
    } else {
      _selectedIngredients![type]!.add(name);
    }
    _updateOrder();
  }

  Widget _buildPortionSelection() {
    return Wrap(
      spacing: 8.0,
      children: ['ธรรมดา', 'พิเศษ'].map<Widget>((option) {
        return InkWell(
          onTap: () {
            setState(() {
              _selectedPortion = option;
              _updateOrder();
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: _selectedPortion == option
                  ? const Color.fromARGB(169, 248, 195, 36)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _selectedPortion == option ? Colors.orange : Colors.grey,
              ),
            ),
            child: Text(
              option,
              style: TextStyle(
                color: _selectedPortion == option ? Colors.black : Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExtraInfoField() {
    return TextField(
      cursorColor: Colors.black,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      controller: _extraInfoController,
      decoration: const InputDecoration(
        labelText: 'ข้อมูลเพิ่มเติม (ถ้ามี)',
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF8C324), width: 2.0),
        ),
      ),
      onChanged: (value) {
        _updateOrder();
      },
    );
  }

  void _updateOrder() {
    order!.ingredients = _selectedIngredients!.values.expand((e) => e).toList();
    order!.extraInfo =
        _extraInfoController.text.isEmpty ? null : _extraInfoController.text;
    order!.portion = _selectedPortion;

    print(order!.ingredients);
    print(order!.portion);
    print(order!.extraInfo);
  }

  bool _isValidOrder() {
    if (order!.menu.category == "ก๋วยเตี๋ยว" &&
        (order!.ingredients!.isEmpty ||
            (!order!.ingredients!.contains("น้ำ") &&
                !order!.ingredients!.contains("แห้ง")))) {
      return false;
    }
    return true;
  }
}
