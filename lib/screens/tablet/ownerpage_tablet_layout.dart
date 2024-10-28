import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  int _selectedIndex = -2;
  Menu? _selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            _buildCustomNavigationRail(),
            // if (_selectedIndex < 4)
            //   Expanded(
            //     child: Row(
            //       children: [_buildMenuSection(), _buildOrderListSection()],
            //     ),
            //   )
            // else if (_selectedIndex == 4)
            //   _buildOrderManagerSection()
            // else if (_selectedIndex == 5)
            //   _buildOverviewSection(),
            if (_selectedIndex == 0)
              _buildMangeMenuSection()
            else if (_selectedIndex == -2)
              _buildAddOrEditMenuSection(menu: _selectedMenu)
          ],
        ),
      ),
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

  Widget _buildMangeMenuSection() {
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
              // if (value == "เสิร์ฟอาหาร") {
              //   await _handleServeOrder(widget.order);
              // } else if (value == "ยกเลิก") {
              //   await _handleCancelOrder();
              // } else if (value == "แก้ไข") {
              //   _handleEditOrder();
              // } else if (value == "ดูรายการอาหาร") {
              //   _handleViewOrderItems();
              // }
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
}
