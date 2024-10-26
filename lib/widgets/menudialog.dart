import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuayteawhatyai/models/menu.dart';
import 'package:kuayteawhatyai/provider/models/orderprovider.dart';
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
                      widget.menu.name,
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
                  child: Image.network(widget.menu.imageURL, fit: BoxFit.cover),
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
                onPressed: () {
                  if (_isValidOrder()) {
                    Provider.of<OrderProvider>(context, listen: false)
                        .addOrder(order!);
                    Get.back();
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
                    'เพิ่มเมนูนี้',
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
