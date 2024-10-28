import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuayteawhatyai/models/ingredient.dart';
import 'package:kuayteawhatyai/models/menu.dart';
import 'package:kuayteawhatyai/services/apiservice.dart';
import 'package:kuayteawhatyai/utils/responsive_layout.dart';
import 'package:kuayteawhatyai/widgets/customnavigationrail.dart';
import 'package:kuayteawhatyai/widgets/customnavigationrailitem.dart';
import 'package:toastification/toastification.dart';

class OwnerPageTabletLayout extends StatefulWidget {
  const OwnerPageTabletLayout({super.key});

  @override
  State<OwnerPageTabletLayout> createState() => _OwnerPageTabletLayoutState();
}

class _OwnerPageTabletLayoutState extends State<OwnerPageTabletLayout> {
  int _selectedIndex = 0;
  Menu? _selectedMenu;
  Ingredient? _selectedIngredient;
  List<String> _selectedIngredientInMenu = [];
  List<String> _selectedIngredientStatic = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            _buildCustomNavigationRail(),
            if (_selectedIndex == 0)
              _buildManageMenuSection()
            else if (_selectedIndex == 1)
              _buildManageIngredientSection()
            else if (_selectedIndex == 2)
              _buildMangeTableSection()
            else if (_selectedIndex == -2)
              _buildAddOrEditMenuSection(menu: _selectedMenu)
            else if (_selectedIndex == -3)
              _buildAddOrEditIngredientSection(ingredient: _selectedIngredient),
          ],
        ),
      ),
    );
  }

  Widget _buildMangeTableSection() {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("KuayTeawHatYai",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0xFFF8C324),
                )),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("จัดการโต๊ะ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black,
                )),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // put only table number in dialog
                  showDialog(
                      context: context,
                      builder: (context) {
                        TextEditingController tableNumberController =
                            TextEditingController();
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: const Center(
                            child: Text(
                              'เพิ่มโต๊ะ',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF8C324),
                              ),
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: tableNumberController,
                                cursorColor: Colors.black,
                                decoration: const InputDecoration(
                                  labelText: 'เลขโต๊ะ',
                                  labelStyle: TextStyle(
                                    color: Color(0xFFF8C324),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFF8C324)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  final response = await ApiService().postData(
                                      "tables/add", {
                                    "table_number": tableNumberController.text
                                  });

                                  if (response.data['code'] == 'success') {
                                    if (mounted) {
                                      toastification.show(
                                        context: context,
                                        type: ToastificationType.success,
                                        style: ToastificationStyle.flat,
                                        title: const Text("เพิ่มโต๊ะสำเร็จ"),
                                        description:
                                            const Text("เพิ่มโต๊ะสำเร็จแล้ว"),
                                      );
                                    }
                                    Get.back();
                                    setState(() {});
                                  } else {
                                    if (mounted) {
                                      toastification.show(
                                        context: context,
                                        type: ToastificationType.error,
                                        style: ToastificationStyle.flat,
                                        title: const Text("เพิ่มโต๊ะไม่สำเร็จ"),
                                        description: const Text(
                                            "เพิ่มโต๊ะไม่สำเร็จ กรุณาลองใหม่อีกครั้ง"),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF8C324),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Center(
                                  child: FittedBox(
                                    child: Text(
                                      'ยืนยัน',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8C324),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text('เพิ่มโต๊ะ'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FutureBuilder(
              future: _fetchTables(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFF8C324),
                      ),
                    )),
                  );
                } else if (snapshot.hasError ||
                    (snapshot.hasData &&
                        (snapshot.data!["code"] != "success"))) {
                  return const Expanded(child: Center(child: Text('Error')));
                }
                final data = snapshot.data as Map<String, dynamic>;
                List tableList = data['tables'] as List;
                // tableList = [
                //         {
                //             "table_number": "A01"
                //         },
                //         {
                //             "table_number": "A02"
                //         },
                //         {
                //             "table_number": "A03"
                //         },
                //         {
                //             "table_number": "A04"
                //         }
                //     ]
                return Expanded(
                  child: SingleChildScrollView(
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            ResponsiveLayout.isPortrait(context) ? 4 : 5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: tableList.length,
                      itemBuilder: (context, index) {
                        final table = tableList[index];
                        return _buildTableItem(table: table);
                      },
                    ),
                  ),
                );
              })
        ],
      ),
    ));
  }

  Widget _buildTableItem({required Map<String, dynamic> table}) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8C324),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.table_bar,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: Row(
                children: [
                  const Icon(
                    Icons.table_chart,
                    color: Color(0xFFF8C324),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Align(
                        child: Text(
                          table['table_number'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
        Positioned(
          bottom: 13,
          right: 0,
          child: PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFFEDC00F),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (String value) async {
              if (value == "ลบ") {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: const Center(
                            child: Text(
                              'ยืนยันการลบโต๊ะ',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF8C324),
                              ),
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final response = await ApiService()
                                      .deleteData("tables/delete", data: {
                                    "table_number": table['table_number'],
                                  });
                                  if (response.data['code'] == 'success') {
                                    if (mounted) {
                                      toastification.show(
                                        context: context,
                                        type: ToastificationType.success,
                                        style: ToastificationStyle.flat,
                                        title: const Text("ลบโต๊ะสำเร็จ"),
                                        description:
                                            const Text("ลบโต๊ะสำเร็จแล้ว"),
                                      );
                                    }
                                    Get.back();
                                    setState(() {});
                                  } else {
                                    if (mounted) {
                                      toastification.show(
                                        context: context,
                                        type: ToastificationType.error,
                                        style: ToastificationStyle.flat,
                                        title: const Text("ลบโต๊ะไม่สำเร็จ"),
                                        description: const Text(
                                            "ลบโต๊ะไม่สำเร็จ กรุณาลองใหม่อีกครั้ง"),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF8C324),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Center(
                                  child: FittedBox(
                                    child: Text(
                                      'ตกลง',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Center(
                                  child: FittedBox(
                                    child: Text(
                                      'ยกเลิก',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ));
                    });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'ลบ',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Color(0xFFEDC00F)),
                    SizedBox(width: 10),
                    Text(
                      'ลบ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddOrEditIngredientSection({required Ingredient? ingredient}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("KuayTeawHatYai",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color(0xFFF8C324),
                  )),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child:
                  Text(ingredient == null ? "เพิ่มวัตถุดิบ" : "แก้ไขวัตถุดิบ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black,
                      )),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedIngredient = null;
                              _selectedIndex = 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF8C324),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.arrow_back_ios_new,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text('กลับ'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildIngredientForm(ingredient: ingredient),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientForm({required Ingredient? ingredient}) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController typeController = TextEditingController();
    final TextEditingController imageURLController = TextEditingController();
    bool isAvailable = true;
    if (ingredient != null) {
      nameController.text = ingredient.name;
      typeController.text = ingredient.type;
      imageURLController.text = ingredient.imageURL;
      isAvailable = ingredient.isAvailable;
    }
    return Column(
      children: [
        TextField(
          enabled: ingredient == null,
          controller: nameController,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
            labelText: 'ชื่อวัตถุดิบ',
            labelStyle: TextStyle(
              color: Color(0xFFF8C324),
              fontWeight: FontWeight.bold,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF8C324)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: typeController,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
            labelText: 'ประเภท',
            labelStyle: TextStyle(
              color: Color(0xFFF8C324),
              fontWeight: FontWeight.bold,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF8C324)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: imageURLController,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
            labelText: 'URL รูปภาพ',
            labelStyle: TextStyle(
              color: Color(0xFFF8C324),
              fontWeight: FontWeight.bold,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF8C324)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Checkbox(
              value: isAvailable,
              onChanged: (value) {
                setState(() {
                  if (ingredient != null) {
                    ingredient.isAvailable = value!;
                  }
                });
              },
              activeColor: const Color(0xFFF8C324),
            ),
            const Text(
              'วัตถุดิบพร้อมใช้งาน',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            if (nameController.text.isEmpty ||
                typeController.text.isEmpty ||
                imageURLController.text.isEmpty) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                style: ToastificationStyle.flat,
                title: const Text("กรุณากรอกข้อมูลให้ครบถ้วน"),
                description: const Text("กรุณากรอกข้อมูลให้ครบถ้วน"),
              );
              return;
            }
            if (ingredient == null) {
              final response = await ApiService().postData("ingredients/add", {
                "name": nameController.text,
                "ingredient_type": typeController.text,
                "image_url": imageURLController.text,
                "is_available": isAvailable,
              });
              if (response.data['code'] == 'success') {
                if (mounted) {
                  toastification.show(
                    context: context,
                    type: ToastificationType.success,
                    style: ToastificationStyle.flat,
                    title: const Text("เพิ่มวัตถุดิบสำเร็จ"),
                    description: const Text("เพิ่มวัตถุดิบสำเร็จแล้ว"),
                  );
                }
                setState(() {
                  _selectedIngredient = null;
                  _selectedIndex = 1;
                });
              } else {
                if (mounted) {
                  toastification.show(
                    context: context,
                    type: ToastificationType.error,
                    style: ToastificationStyle.flat,
                    title: const Text("เพิ่มวัตถุดิบไม่สำเร็จ"),
                    description: const Text(
                        "เพิ่มวัตถุดิบไม่สำเร็จ กรุณาลองใหม่อีกครั้ง"),
                  );
                }
              }
            } else {
              final response =
                  await ApiService().putData("ingredients/update", {
                "name": nameController.text,
                "ingredient_type": typeController.text,
                "image_url": imageURLController.text,
                "is_available": isAvailable,
              });
              if (response.data['code'] == 'success') {
                if (mounted) {
                  toastification.show(
                    context: context,
                    type: ToastificationType.success,
                    style: ToastificationStyle.flat,
                    title: const Text("แก้ไขวัตถุดิบสำเร็จ"),
                    description: const Text("แก้ไขวัตถุดิบสำเร็จแล้ว"),
                  );
                }
                setState(() {
                  _selectedIngredient = null;
                  _selectedIndex = 1;
                });
              } else {
                if (mounted) {
                  toastification.show(
                    context: context,
                    type: ToastificationType.error,
                    style: ToastificationStyle.flat,
                    title: const Text("แก้ไขวัตถุดิบไม่สำเร็จ"),
                    description: const Text(
                        "แก้ไขวัตถุดิบไม่สำเร็จ กรุณาลองใหม่อีกครั้ง"),
                  );
                }
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF8C324),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Center(
            child: FittedBox(
              child: Text(
                'ยืนยัน',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildManageIngredientSection() {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("KuayTeawHatYai",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0xFFF8C324),
                )),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("จัดการวัตถุดิบ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black,
                )),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedIngredient = null;
                    _selectedIndex = -3;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8C324),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text('เพิ่มวัตถุดิบ'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FutureBuilder(
              future: _fetchIngredients(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFF8C324),
                      ),
                    )),
                  );
                } else if (snapshot.hasError ||
                    (snapshot.hasData &&
                        (snapshot.data!["code"] != "success"))) {
                  return const Expanded(child: Center(child: Text('Error')));
                }
                final data = snapshot.data as Map<String, dynamic>;
                List ingredientList = data['ingredients'] as List;
                List<Ingredient> ingredients = ingredientList
                    .map((ingredient) =>
                        Ingredient.fromJson(ingredient as Map<String, dynamic>))
                    .toList();
                return Expanded(
                  child: SingleChildScrollView(
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            ResponsiveLayout.isPortrait(context) ? 4 : 5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: ingredients.length,
                      itemBuilder: (context, index) {
                        final ingredient = ingredients[index];
                        return _buildIngredientItem(ingredient: ingredient);
                      },
                    ),
                  ),
                );
              })
        ],
      ),
    ));
  }

  Widget _buildIngredientItem({required Ingredient ingredient}) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      Image.network(ingredient.imageURL, fit: BoxFit.fitHeight),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Text(
                        ingredient.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.inventory,
                          color: Color(0xFFF8C324),
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        FittedBox(
                          child: Text(
                            ingredient.type,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color(0xFFF8C324)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
            ],
          ),
        ),
        if (!ingredient.isAvailable)
          Positioned(
            top: 5,
            right: 5,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'ไม่พร้อมใช้งาน',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 5,
          right: 0,
          child: PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFFEDC00F),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (String value) async {
              if (value == "แก้ไข") {
                setState(() {
                  _selectedIngredient = ingredient;
                  _selectedIndex = -3;
                });
              } else if (value == "ลบ") {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: const Center(
                            child: Text(
                              'ยืนยันการลบวัตถุดิบ',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF8C324),
                              ),
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final response = await ApiService()
                                      .deleteData("ingredients/delete", data: {
                                    "name": ingredient.name,
                                  });
                                  if (response.data['code'] == 'success') {
                                    if (mounted) {
                                      toastification.show(
                                        context: context,
                                        type: ToastificationType.success,
                                        style: ToastificationStyle.flat,
                                        title: const Text("ลบเมนูสำเร็จ"),
                                        description:
                                            const Text("ลบเมนูสำเร็จแล้ว"),
                                      );
                                    }
                                    Get.back();
                                    setState(() {});
                                  } else {
                                    if (mounted) {
                                      toastification.show(
                                        context: context,
                                        type: ToastificationType.error,
                                        style: ToastificationStyle.flat,
                                        title: const Text("ลบเมนูไม่สำเร็จ"),
                                        description: const Text(
                                            "ลบเมนูไม่สำเร็จ กรุณาลองใหม่อีกครั้ง"),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF8C324),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Center(
                                  child: FittedBox(
                                    child: Text(
                                      'ตกลง',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Center(
                                  child: FittedBox(
                                    child: Text(
                                      'ยกเลิก',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ));
                    });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'แก้ไข',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Color(0xFFEDC00F)),
                    SizedBox(width: 10),
                    Text(
                      'แก้ไข',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'ลบ',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Color(0xFFEDC00F)),
                    SizedBox(width: 10),
                    Text(
                      'ลบ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddOrEditMenuSection({required Menu? menu}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("KuayTeawHatYai",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color(0xFFF8C324),
                  )),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(menu == null ? "เพิ่มเมนู" : "แก้ไขเมนู",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black,
                  )),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedMenu = null;
                              _selectedIndex = 0;
                              _selectedIngredientInMenu = [];
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF8C324),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.arrow_back_ios_new,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text('กลับ'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildMenuForm(menu: menu),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuForm({required Menu? menu}) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController imageURLController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    if (menu != null) {
      nameController.text = menu.name;
      priceController.text = menu.price.toString();
      imageURLController.text = menu.imageURL;
      categoryController.text = menu.category;
    }

    return Column(
      children: [
        TextField(
          enabled: menu == null,
          controller: nameController,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
            labelText: 'ชื่อเมนู',
            labelStyle: TextStyle(
              color: Color(0xFFF8C324),
              fontWeight: FontWeight.bold,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF8C324)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: categoryController,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
            labelText: 'ประเภท',
            labelStyle: TextStyle(
              color: Color(0xFFF8C324),
              fontWeight: FontWeight.bold,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF8C324)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: priceController,
          cursorColor: Colors.black,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'ราคา',
            labelStyle: TextStyle(
              color: Color(0xFFF8C324),
              fontWeight: FontWeight.bold,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF8C324)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: imageURLController,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
            labelText: 'URL รูปภาพ',
            labelStyle: TextStyle(
              color: Color(0xFFF8C324),
              fontWeight: FontWeight.bold,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF8C324)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (menu != null && menu.category == "อาหาร")
          FutureBuilder(
              future: _fetchIngredientsAndIngredientInMenu(menu: menu),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Color(0xFFF8C324),
                  ));
                } else if (snapshot.hasError ||
                    (snapshot.hasData &&
                        (snapshot.data!["code"] != "success"))) {
                  return const Center(child: Text('Error'));
                }

                final data = snapshot.data as Map<String, dynamic>;

                List ingredientList = data['ingredients'] as List;
                List<Ingredient> ingredients = ingredientList
                    .map((ingredient) =>
                        Ingredient.fromJson(ingredient as Map<String, dynamic>))
                    .toList();

                return DataTable(columns: const [
                  DataColumn(
                    label: Text('เลือกวัตถุดิบ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('รูปวัตถดิบ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('ชื่อวัตุดิบ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('ประเภทวัตถุดิบ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('สถานะวัตถุดิบ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ], rows: [
                  for (Ingredient ingredient in ingredients)
                    DataRow(cells: [
                      DataCell(Checkbox(
                        value:
                            _selectedIngredientInMenu.contains(ingredient.name),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              _selectedIngredientInMenu.add(ingredient.name);
                            } else {
                              _selectedIngredientInMenu.remove(ingredient.name);
                            }
                          });
                        },
                        activeColor: const Color(0xFFF8C324),
                      )),
                      DataCell(
                        Image.network(ingredient.imageURL,
                            width: 50, height: 50, fit: BoxFit.cover),
                      ),
                      DataCell(Text(ingredient.name)),
                      DataCell(Text(ingredient.type)),
                      DataCell(Text(ingredient.isAvailable
                          ? 'พร้อมใช้งาน'
                          : 'ไม่พร้อมใช้งาน')),
                    ]),
                ]);
              }),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            if (nameController.text.isEmpty ||
                priceController.text.isEmpty ||
                imageURLController.text.isEmpty ||
                categoryController.text.isEmpty) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                style: ToastificationStyle.flat,
                title: const Text("กรุณากรอกข้อมูลให้ครบถ้วน"),
                description: const Text("กรุณากรอกข้อมูลให้ครบถ้วน"),
              );
              return;
            }
            try {
              double.parse(priceController.text);
            } catch (e) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                style: ToastificationStyle.flat,
                title: const Text("ราคาต้องเป็นตัวเลข"),
                description: const Text("ราคาต้องเป็นตัวเลข"),
              );
              return;
            }
            if (menu == null) {
              final response = await ApiService().postData("menus/add", {
                "name": nameController.text,
                "price": double.parse(priceController.text),
                "image_url": imageURLController.text,
                "category": categoryController.text,
              });
              if (response.data['code'] == 'success') {
                if (mounted) {
                  toastification.show(
                    context: context,
                    type: ToastificationType.success,
                    style: ToastificationStyle.flat,
                    title: const Text("เพิ่มเมนูสำเร็จ"),
                    description: const Text("เพิ่มเมนูสำเร็จแล้ว"),
                  );
                }
                setState(() {
                  _selectedMenu = null;
                  _selectedIndex = 0;
                });
              } else {
                if (mounted) {
                  toastification.show(
                    context: context,
                    type: ToastificationType.error,
                    style: ToastificationStyle.flat,
                    title: const Text("เพิ่มเมนูไม่สำเร็จ"),
                    description:
                        const Text("เพิ่มเมนูไม่สำเร็จ กรุณาลองใหม่อีกครั้ง"),
                  );
                }
              }
            } else {
              if (menu.category != "อาหาร") {
                final response = await ApiService().putData("menus/update", {
                  "name": nameController.text,
                  "price": double.parse(priceController.text),
                  "image_url": imageURLController.text,
                  "category": categoryController.text,
                });
                if (response.data['code'] == 'success') {
                  if (mounted) {
                    toastification.show(
                      context: context,
                      type: ToastificationType.success,
                      style: ToastificationStyle.flat,
                      title: const Text("แก้ไขเมนูสำเร็จ"),
                      description: const Text("แก้ไขเมนูสำเร็จแล้ว"),
                    );
                  }
                  setState(() {
                    _selectedMenu = null;
                    _selectedIndex = 0;
                  });
                } else {
                  if (mounted) {
                    toastification.show(
                      context: context,
                      type: ToastificationType.error,
                      style: ToastificationStyle.flat,
                      title: const Text("แก้ไขเมนูไม่สำเร็จ"),
                      description:
                          const Text("แก้ไขเมนูไม่สำเร็จ กรุณาลองใหม่อีกครั้ง"),
                    );
                  }
                }
              } else {
                final response = await ApiService().putData("menus/update", {
                  "name": nameController.text,
                  "price": double.parse(priceController.text),
                  "image_url": imageURLController.text,
                  "category": categoryController.text,
                });
                var response2;
                var response3;

                if (!areEqual(
                    _selectedIngredientInMenu, _selectedIngredientStatic)) {
                  response2 = await ApiService()
                      .deleteData('/menu/remove-ingredient', data: {
                    "menu_name": nameController.text,
                    "ingredients": _selectedIngredientStatic
                  });

                  response3 = await ApiService().postData(
                      '/menu/add-ingredient', {
                    "menu_name": nameController.text,
                    "ingredients": _selectedIngredientInMenu
                  });
                }

                if (response.data['code'] == 'success' &&
                    ((response3 == null && response2 == null) ||
                        (response2.data['code'] == 'success' &&
                            response3.data['code'] == 'success'))) {
                  if (mounted) {
                    toastification.show(
                      context: context,
                      type: ToastificationType.success,
                      style: ToastificationStyle.flat,
                      title: const Text("แก้ไขเมนูสำเร็จ"),
                      description: const Text("แก้ไขเมนูสำเร็จแล้ว"),
                    );
                  }
                  setState(() {
                    _selectedMenu = null;
                    _selectedIndex = 0;
                    _selectedIngredientInMenu = [];
                  });
                } else {
                  if (mounted) {
                    toastification.show(
                      context: context,
                      type: ToastificationType.error,
                      style: ToastificationStyle.flat,
                      title: const Text("แก้ไขเมนูไม่สำเร็จ"),
                      description:
                          const Text("แก้ไขเมนูไม่สำเร็จ กรุณาลองใหม่อีกครั้ง"),
                    );
                  }
                }
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF8C324),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Center(
            child: FittedBox(
              child: Text(
                'ยืนยัน',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildManageMenuSection() {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("KuayTeawHatYai",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0xFFF8C324),
                )),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("จัดการเมนู",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black,
                )),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedMenu = null;
                    _selectedIndex = -2;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8C324),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text('เพิ่มเมนู'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FutureBuilder(
              future: _fetchMenus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFF8C324),
                      ),
                    )),
                  );
                } else if (snapshot.hasError ||
                    (snapshot.hasData &&
                        (snapshot.data!["code"] != "success"))) {
                  return const Expanded(child: Center(child: Text('Error')));
                }
                final data = snapshot.data as Map<String, dynamic>;
                List menuList = data['menus'] as List;
                List<Menu> menus = menuList
                    .map((menu) => Menu.fromJson(menu as Map<String, dynamic>))
                    .toList();
                return Expanded(
                  child: SingleChildScrollView(
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            ResponsiveLayout.isPortrait(context) ? 4 : 5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: menus.length,
                      itemBuilder: (context, index) {
                        final menu = menus[index];
                        return _buildMenuItem(menu: menu);
                      },
                    ),
                  ),
                );
              })
        ],
      ),
    ));
  }

  Widget _buildMenuItem({required Menu menu}) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(menu.imageURL, fit: BoxFit.fitHeight),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Text(
                        menu.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FittedBox(
                          child: Text(
                            '฿ ${menu.price}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color(0xFFF8C324)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
            ],
          ),
        ),
        Positioned(
          bottom: 5,
          right: 0,
          child: PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFFEDC00F),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (String value) async {
              if (value == "แก้ไข") {
                setState(() {
                  _selectedMenu = menu;
                  _selectedIndex = -2;
                });
              } else if (value == "ลบ") {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: const Center(
                            child: Text(
                              'ยืนยันการลบเมนู',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF8C324),
                              ),
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final response = await ApiService()
                                      .deleteData("menus/delete", data: {
                                    "name": menu.name,
                                  });
                                  if (response.data['code'] == 'success') {
                                    if (mounted) {
                                      toastification.show(
                                        context: context,
                                        type: ToastificationType.success,
                                        style: ToastificationStyle.flat,
                                        title: const Text("ลบเมนูสำเร็จ"),
                                        description:
                                            const Text("ลบเมนูสำเร็จแล้ว"),
                                      );
                                    }
                                    Get.back();
                                    setState(() {});
                                  } else {
                                    if (mounted) {
                                      toastification.show(
                                        context: context,
                                        type: ToastificationType.error,
                                        style: ToastificationStyle.flat,
                                        title: const Text("ลบเมนูไม่สำเร็จ"),
                                        description: const Text(
                                            "ลบเมนูไม่สำเร็จ กรุณาลองใหม่อีกครั้ง"),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF8C324),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Center(
                                  child: FittedBox(
                                    child: Text(
                                      'ตกลง',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Center(
                                  child: FittedBox(
                                    child: Text(
                                      'ยกเลิก',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ));
                    });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'แก้ไข',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Color(0xFFEDC00F)),
                    SizedBox(width: 10),
                    Text(
                      'แก้ไข',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'ลบ',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Color(0xFFEDC00F)),
                    SizedBox(width: 10),
                    Text(
                      'ลบ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<Map<String, dynamic>> _fetchMenus() async {
    final response = await ApiService().getData("menus");
    return response.data;
  }

  Future<Map<String, dynamic>> _fetchIngredients() async {
    final response = await ApiService().getData("ingredients");
    return response.data;
  }

  Future<Map<String, dynamic>> _fetchTables() async {
    final response = await ApiService().getData("tables");
    return response.data;
  }

  Future<Map<String, dynamic>> _fetchIngredientsAndIngredientInMenu(
      {Menu? menu}) async {
    final response = await ApiService().getData("ingredients");

    var response2;
    if (menu != null && _selectedIngredientInMenu.isEmpty) {
      response2 =
          await ApiService().getData("/menus/ingredients?name=${menu.name}");
    } else {
      response2 = null;
    }

    List<String> allIngredientsInMenu = [];

    if (response2 != null) {
      List ingredients = response2.data['ingredients'] as List;

      // Extract options from each ingredient type and flatten them into a list.
      for (var ingredient in ingredients) {
        List options = ingredient['options'] as List;
        for (var option in options) {
          allIngredientsInMenu.add(option['name']);
        }
      }

      _selectedIngredientInMenu = [...allIngredientsInMenu];
      _selectedIngredientStatic = [...allIngredientsInMenu];
    }

    return response.data;
  }

  Widget _buildCustomNavigationRail() {
    return CustomNavigationRail(children: [
      CustomNavigationRailItem(
        icon: Icons.fastfood,
        label: 'จัดการเมนู',
        index: 0,
        selectedIndex: _selectedIndex,
        onItemTapped: (int value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
      CustomNavigationRailItem(
        icon: Icons.inventory,
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
        icon: Icons.table_bar,
        label: 'จัดการโต๊ะ',
        index: 2,
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

  bool areEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
