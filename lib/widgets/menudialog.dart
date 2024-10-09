import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuayteawhatyai/models/menu.dart';
import 'package:kuayteawhatyai/provider/orderprovider.dart';
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
  final Map<String, List<String>> _selectedIngredients =
      {}; // Group to selected options

  @override
  void initState() {
    super.initState();
    order = Order(
      menu: widget.menu,
      quantity: 1,
      ingredients: [],
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
                    FutureBuilder(
                      future: _fetchIngredients(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Expanded(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (snapshot.hasError ||
                            (snapshot.hasData &&
                                (snapshot.data!["code"] != "success"))) {
                          return const Expanded(
                              child: Center(child: Text('Error')));
                        }
                        final data = snapshot.data as Map<String, dynamic>;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var ingredient in data['ingredients'])
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
                                      children: [
                                        for (var option in ingredient['options'])
                                          GestureDetector(
                                            onTap: option['isAvailable']
                                                ? () {
                                                    setState(() {
                                                      // Initialize if not yet present
                                                      _selectedIngredients[
                                                          ingredient[
                                                              'type']] ??= [];
                                                      // Add/remove selected option
                                                      if (_selectedIngredients[
                                                              ingredient['type']]!
                                                          .contains(
                                                              option['name'])) {
                                                        _selectedIngredients[
                                                                ingredient[
                                                                    'type']]!
                                                            .remove(
                                                                option['name']);
                                                      } else {
                                                        _selectedIngredients[
                                                                ingredient[
                                                                    'type']]!
                                                            .add(option['name']);
                                                      }
                                                      order = Order(
                                                        menu: widget.menu,
                                                        quantity: 1,
                                                        ingredients:
                                                            _selectedIngredients
                                                                .values
                                                                .expand((e) => e)
                                                                .toList(),
                                                        extraInfo:
                                                            _extraInfoController
                                                                        .text ==
                                                                    ''
                                                                ? null
                                                                : _extraInfoController
                                                                    .text,
                                                      );
                                                    });
                                                  }
                                                : null,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              decoration: BoxDecoration(
                                                color: _selectedIngredients[
                                                                ingredient[
                                                                    'type']] !=
                                                            null &&
                                                        _selectedIngredients[
                                                                ingredient[
                                                                    'type']]!
                                                            .contains(
                                                                option['name'])
                                                    ? const Color(0xFFF8C324)
                                                    : option['isAvailable']
                                                        ? Colors.white
                                                        : Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: _selectedIngredients[
                                                                  ingredient[
                                                                      'type']] !=
                                                              null &&
                                                          _selectedIngredients[
                                                                  ingredient[
                                                                      'type']]!
                                                              .contains(
                                                                  option['name'])
                                                      ? Colors.orange
                                                      : Colors.grey,
                                                ),
                                              ),
                                              child: Text(
                                                option['isAvailable']
                                                    ? option['name']
                                                    : '${option['name']} (หมด)',
                                                style: TextStyle(
                                                  color: option['isAvailable']
                                                      ? Colors.black
                                                      : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _extraInfoController,
                              decoration: const InputDecoration(
                                labelText: 'ข้อมูลเพิ่มเติม',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                if (value == '') return;

                                order = Order(
                                  menu: widget.menu,
                                  quantity: 1,
                                  ingredients: _selectedIngredients.values
                                      .expand((e) => e)
                                      .toList(),
                                  extraInfo: value,
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Provider.of<OrderProvider>(context, listen: false)
                      .addOrder(order!);
                  Get.back();
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

  Future<Map<String, dynamic>> _fetchIngredients() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      'code': 'success',
      'ingredients': [
        {
          "type": "เส้น",
          "options": [
            {"name": "เส้นเล็ก", "isAvailable": true},
            {"name": "เส้นใหญ่", "isAvailable": true},
            {"name": "เส้นหมี่", "isAvailable": true},
            {"name": "เส้นบะหมี่", "isAvailable": true},
            {"name": "วุ้นเส้น", "isAvailable": false},
          ],
        },
        {
          'type': 'เนื้อสัตว์',
          'options': [
            {'name': 'หมูชิ้น', 'isAvailable': true},
            {'name': 'หมูเด้ง', 'isAvailable': true},
            {'name': 'เนื้อ', 'isAvailable': true},
            {'name': 'ไก่ฉีก', 'isAvailable': false},
          ]
        }
      ],
    };
  }
}
