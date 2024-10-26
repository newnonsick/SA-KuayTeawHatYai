import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuayteawhatyai/models/menu.dart';
import 'package:kuayteawhatyai/provider/orderprovider.dart';
import 'package:kuayteawhatyai/services/apiservice.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';

class MenuDialog extends StatefulWidget {
  final Menu menu;
  const MenuDialog({super.key, required this.menu});

  @override
  State<MenuDialog> createState() => _MenuDialogState();
}

class _MenuDialogState extends State<MenuDialog> {
  Order? order;
  final TextEditingController _extraInfoController = TextEditingController();
  final Map<String, List<String>> _selectedIngredients = {};
  String _selectedPortion = 'ธรรมดา'; // ธรรมดา พิเศษ
  Map<String, dynamic>? _ingredientsCache;

  @override
  void initState() {
    super.initState();
    order = Order(
      menu: widget.menu.copyWith(),
      quantity: 1,
      ingredients: [],
      portion: _selectedPortion,
    );
    _fetchAndCacheIngredients();
  }

  Future<void> _fetchAndCacheIngredients() async {
    if (_ingredientsCache != null) return;

    try {
      final response = await ApiService()
          .getData('menus/ingredients?name=${widget.menu.name}');
      if (response.data['code'] == 'success') {
        setState(() {
          _ingredientsCache = response.data;
        });
      }
    } catch (error) {
      setState(() {
        _ingredientsCache = {'error': true};
      });
    }
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
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 25,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child:
                    Image.network(widget.menu.imageURL, fit: BoxFit.fitHeight),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.menu.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildIngredientsSection(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_isValidOrder()) {
                    Provider.of<OrderProvider>(context, listen: false)
                        .addOrder(order!);
                    Get.back();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFFF8C324),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const FittedBox(
                  child: Text(
                    'เพิ่มเมนูนี้',
                    style: TextStyle(
                      fontSize: 18,
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
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Color(0xFFF8C324),
        ),
      );
    } else if (_ingredientsCache!['error'] == true) {
      return const Text('Error loading ingredients');
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
                    fontSize: 16,
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
        const SizedBox(height: 10),
        _buildPortionSelection(),
        const SizedBox(height: 20),
        _buildExtraInfoField(),
      ],
    );
  }

  Widget _buildIngredientOption(String type, Map<String, dynamic> option) {
    final isSelected =
        _selectedIngredients[type]?.contains(option['name']) ?? false;

    return GestureDetector(
      onTap: option['is_available']
          ? () {
              setState(() {
                _toggleIngredientSelection(type, option['name']);
              });
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF8C324) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey,
          ),
        ),
        child: Text(
          option['is_available'] ? option['name'] : '${option['name']} (หมด)',
          style: TextStyle(
            color: option['is_available'] ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  void _toggleIngredientSelection(String type, String name) {
    _selectedIngredients[type] ??= [];
    if (name == "น้ำ" || name == "แห้ง") {
      _selectedIngredients[type]!.clear();
    }

    if (_selectedIngredients[type]!.contains(name)) {
      _selectedIngredients[type]!.remove(name);
    } else {
      _selectedIngredients[type]!.add(name);
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
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: _selectedPortion == option
                  ? const Color(0xFFF8C324)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _selectedPortion == option ? Colors.orange : Colors.grey,
              ),
            ),
            child: Text(option),
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
      ),
      onChanged: (value) {
        _updateOrder();
      },
    );
  }

  void _updateOrder() {
    order!.ingredients = _selectedIngredients.values.expand((e) => e).toList();
    order!.extraInfo =
        _extraInfoController.text.isEmpty ? null : _extraInfoController.text;
    order!.portion = _selectedPortion;
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
