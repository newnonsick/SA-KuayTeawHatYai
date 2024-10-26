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

  @override
  void initState() {
    super.initState();
    order = Order(
      menu: widget.menu.copyWith(),
      quantity: 1,
      ingredients: [],
      portion: _selectedPortion,
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
                      FutureBuilder(
                        future: _fetchIngredients(widget.menu.name),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError ||
                              (snapshot.hasData &&
                                  (snapshot.data!["code"] != "success"))) {
                            return const Text('Error');
                          }
                          final data = snapshot.data as Map<String, dynamic>;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var ingredient in data['ingredients'])
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          for (var option
                                              in ingredient['options'])
                                            GestureDetector(
                                              onTap: option['is_available']
                                                  ? () {
                                                      setState(() {
                                                        if (option['name'] ==
                                                                "น้ำ" ||
                                                            option['name'] ==
                                                                "แห้ง") {
                                                          _selectedIngredients[
                                                              ingredient[
                                                                  'type']] = [];
                                                        }

                                                        _selectedIngredients[
                                                            ingredient[
                                                                'type']] ??= [];
                                                        if (_selectedIngredients[
                                                                ingredient[
                                                                    'type']]!
                                                            .contains(option[
                                                                'name'])) {
                                                          _selectedIngredients[
                                                                  ingredient[
                                                                      'type']]!
                                                              .remove(option[
                                                                  'name']);
                                                        } else {
                                                          _selectedIngredients[
                                                                  ingredient[
                                                                      'type']]!
                                                              .add(option[
                                                                  'name']);
                                                        }

                                                        order!.ingredients =
                                                            _selectedIngredients
                                                                .values
                                                                .expand(
                                                                    (e) => e)
                                                                .toList();
                                                        order!.extraInfo =
                                                            _extraInfoController
                                                                        .text ==
                                                                    ''
                                                                ? null
                                                                : _extraInfoController
                                                                    .text;
                                                      });
                                                    }
                                                  : null,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 10),
                                                decoration: BoxDecoration(
                                                  color: _selectedIngredients[
                                                                  ingredient[
                                                                      'type']] !=
                                                              null &&
                                                          _selectedIngredients[
                                                                  ingredient[
                                                                      'type']]!
                                                              .contains(option[
                                                                  'name'])
                                                      ? const Color(0xFFF8C324)
                                                      : option['is_available']
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
                                                                    option[
                                                                        'name'])
                                                        ? Colors.orange
                                                        : Colors.grey,
                                                  ),
                                                ),
                                                child: Text(
                                                  option['is_available']
                                                      ? option['name']
                                                      : '${option['name']} (หมด)',
                                                  style: TextStyle(
                                                    color:
                                                        option['is_available']
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
                              const Text(
                                'ปริมาณ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Wrap(
                                spacing: 8.0,
                                children: [
                                  {'name': 'ธรรมดา'},
                                  {'name': 'พิเศษ'},
                                ].map<Widget>(
                                  (option) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (_selectedPortion ==
                                              option['name']) return;

                                          _selectedPortion = option['name']!;
                                          order!.ingredients =
                                              _selectedIngredients.values
                                                  .expand((e) => e)
                                                  .toList();
                                          order!.extraInfo =
                                              _extraInfoController.text == ''
                                                  ? null
                                                  : _extraInfoController.text;
                                          order!.portion = _selectedPortion;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                          color:
                                              _selectedPortion == option['name']
                                                  ? const Color(0xFFF8C324)
                                                  : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: _selectedPortion ==
                                                    option['name']
                                                ? Colors.orange
                                                : Colors.grey,
                                          ),
                                        ),
                                        child: Text(
                                          option['name']!,
                                          style: TextStyle(
                                            color: _selectedPortion ==
                                                    option['name']
                                                ? Colors.black
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                cursorColor: Colors.black,
                                onTapOutside: (event) =>
                                    FocusScope.of(context).unfocus(),
                                controller: _extraInfoController,
                                decoration: const InputDecoration(
                                  labelText: 'ข้อมูลเพิ่มเติม (ถ้ามี)',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value == '') return;
                                  order!.extraInfo = value;
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (order!.menu.category == "ก๋วยเตี๋ยว" &&
                      order!.ingredients!.isEmpty) {
                    return;
                  } else if (order!.menu.category == "ก๋วยเตี๋ยว" &&
                      (!order!.ingredients!.contains("น้ำ") &&
                          !order!.ingredients!.contains("แห้ง"))) {
                    return;
                  }

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
}

Future<Map<String, dynamic>> _fetchIngredients(String menuName) async {
  final response =
      await ApiService().getData('menus/ingredients?name=$menuName');
  return response.data;
}
