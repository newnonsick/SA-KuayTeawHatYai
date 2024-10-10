import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuayteawhatyai/models/menu.dart';
import 'package:kuayteawhatyai/models/order.dart';
import 'package:kuayteawhatyai/provider/orderprovider.dart';
import 'package:kuayteawhatyai/screens/portraitmodepage.dart';
import 'package:kuayteawhatyai/utils/responsive_layout.dart';
import 'package:kuayteawhatyai/widgets/menudialog.dart';
import 'package:provider/provider.dart';

class TakeOrderPageTabletLayout extends StatefulWidget {
  const TakeOrderPageTabletLayout({super.key});

  @override
  State<TakeOrderPageTabletLayout> createState() =>
      _TakeOrderPageTabletLayoutState();
}

class _TakeOrderPageTabletLayoutState extends State<TakeOrderPageTabletLayout> {
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
              child: Row(
                children: [_buildMenuSection(), _buildOrderListSection()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Expanded(
      flex: 3,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 20,
                        color: Color(0xFFF8C324),
                      ),
                      hintText: 'ค้นหาเมนู',
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
                      contentPadding: const EdgeInsets.fromLTRB(0, 5, 40, 5),
                      border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8C324),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'รายการอาหาร',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
                future: _fetchMenus(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError ||
                      (snapshot.hasData &&
                          (snapshot.data!["code"] != "success"))) {
                    return const Expanded(child: Center(child: Text('Error')));
                  }
                  final data = snapshot.data as Map<String, dynamic>;
                  List menuList = data['menus'] as List;
                  List<Menu> menus = menuList
                      .map(
                          (menu) => Menu.fromJson(menu as Map<String, dynamic>))
                      .toList();
                  return Expanded(
                    child: SingleChildScrollView(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              ResponsiveLayout.isPortrait(context) ? 3 : 4,
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
      ),
    );
  }

  Widget _buildMenuItem({required Menu menu}) {
    return Container(
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
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => MenuDialog(menu: menu));
                      },
                      child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8C324),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              SizedBox(width: 5),
                              FittedBox(
                                child: Icon(Icons.add,
                                    color: Colors.white, size: 13),
                              ),
                              SizedBox(width: 5),
                              FittedBox(
                                child: Text(
                                  'เพิ่ม',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                            ],
                          )),
                    ),
                  ],
                ),
              )
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildOrderListSection() {
    return Consumer<OrderProvider>(builder: (context, orderProvider, child) {
      return Expanded(
          child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Colors.grey[400]!,
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'เมนูที่เลือก',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  for (Order order in orderProvider.orders)
                    _buildOrderItem(
                      order: order,
                    ),
                ],
              ),
            )),
            Container(
              height: 2,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'ราคารวม',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '฿ ${orderProvider.getTotalPrice()}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (orderProvider.orders.isEmpty) {
                  return;
                }
                TextEditingController tableNumberController =
                    TextEditingController();

                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text('กรุณากรอกหมายเลขโต๊ะ'),
                        content: TextField(
                          controller: tableNumberController,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.black,
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              try {
                                int.parse(value);
                              } catch (e) {
                                tableNumberController.clear();
                              }

                              if (int.parse(value) > 20 ||
                                  int.parse(value) < 1) {
                                tableNumberController.clear();
                              }
                            }
                          },
                          decoration: const InputDecoration(
                            fillColor: Colors.black,
                            focusColor: Colors.black,
                            hintText: 'หมายเลขโต๊ะ (1-20)',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              'ยกเลิก',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (tableNumberController.text.isEmpty) {
                                return;
                              }
                              int tableNumber;
                              try {
                                tableNumber =
                                    int.parse(tableNumberController.text);
                              } catch (e) {
                                return;
                              }
                              if (tableNumber < 1 || tableNumber > 20) {
                                return;
                              }
                              orderProvider.setTableNumber(tableNumber);
                              print(orderProvider.toJson()); //wait for api
                              orderProvider.clearOrder();
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF8C324),
                              foregroundColor: Colors.black,
                            ),
                            child: const Text('ยืนยัน'),
                          ),
                        ],
                      );
                    });
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
                    'บันทึกออร์เดอร์',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ));
    });
  }

  Widget _buildOrderItem({required Order order}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(order.menu.imageURL,
                      fit: BoxFit.fitHeight))),
          const SizedBox(width: 5),
          Expanded(
              flex: ResponsiveLayout.isPortrait(context) ? 2 : 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            order.menu.name,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (ResponsiveLayout.isLandscape(context))
                        Row(
                          children: [
                            FittedBox(
                              child: InkWell(
                                onTap: () {
                                  if (order.quantity > 1) {
                                    Provider.of<OrderProvider>(context,
                                            listen: false)
                                        .decrementQuantity(order);
                                  } else {
                                    Provider.of<OrderProvider>(context,
                                            listen: false)
                                        .removeOrder(order);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.black,
                                    size: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            FittedBox(
                              child: Text(
                                order.quantity.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            FittedBox(
                              child: InkWell(
                                onTap: () {
                                  Provider.of<OrderProvider>(context,
                                          listen: false)
                                      .incrementQuantity(order);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8C324),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Flexible(
                        child: FittedBox(
                          child: Text(
                            '฿ ${(order.portion == "พิเศษ" ? order.menu.price + 10 : order.menu.price)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFFF8C324),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: FittedBox(
                          child: Text(
                            '(${(order.portion == "พิเศษ" ? order.menu.price + 10 : order.menu.price) * order.quantity})',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  if (ResponsiveLayout.isPortrait(context))
                    Row(
                      children: [
                        FittedBox(
                          child: InkWell(
                            onTap: () {
                              if (order.quantity > 1) {
                                Provider.of<OrderProvider>(context,
                                        listen: false)
                                    .decrementQuantity(order);
                              } else {
                                Provider.of<OrderProvider>(context,
                                        listen: false)
                                    .removeOrder(order);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                Icons.remove,
                                color: Colors.black,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        FittedBox(
                          child: Text(
                            order.quantity.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        FittedBox(
                          child: InkWell(
                            onTap: () {
                              Provider.of<OrderProvider>(context, listen: false)
                                  .incrementQuantity(order);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8C324),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (order.ingredients != null)
                    for (String ingredient in order.ingredients!)
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 5,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              ingredient,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                  if (order.menu.category == "ก๋วยเตี๋ยว")
                    Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 5,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            order.portion!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (order.extraInfo != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '--เพิ่มเติม--',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          order.extraInfo!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                ],
              ))
        ],
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
              icon: Icons.fastfood,
              label: 'อาหาร',
              index: 0,
            ),
            _buildCustomNavigationRailItem(
              icon: Icons.local_drink,
              label: 'เครื่องดื่ม',
              index: 1,
            ),
            _buildCustomNavigationRailItem(
              icon: Icons.icecream,
              label: 'ของทานเล่น',
              index: 2,
            ),
            _buildCustomNavigationRailItem(
              icon: Icons.receipt,
              label: 'จัดการออร์เดอร์',
              index: 3,
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

  Future<Map<String, dynamic>> _fetchMenus() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      'code': 'success',
      'menus': [
        {
          'name': 'ก๋วยเตี๋ยวน้ำใส',
          'imageURL':
              "https://cdn.discordapp.com/attachments/1041014713816977471/1293532972984832020/cattt.jpg?ex=670860b5&is=67070f35&hm=2eaf26149ec1b229d7a113e5d11a0e28cdc568a65edd6778214e0a92a0b09fe6&",
          'price': 45.0,
          'category': 'ก๋วยเตี๋ยว',
        },
        {
          'name': 'ก๋วยเตี๋ยวเส้นปลา',
          'imageURL':
              "https://cdn.discordapp.com/attachments/1041014713816977471/1293532972984832020/cattt.jpg?ex=670860b5&is=67070f35&hm=2eaf26149ec1b229d7a113e5d11a0e28cdc568a65edd6778214e0a92a0b09fe6&",
          'price': 55.0,
          'category': 'ก๋วยเตี๋ยว',
        },
        {
          'name': 'ก๋วยเตี๋ยวต้มยำ',
          'imageURL':
              "https://cdn.discordapp.com/attachments/1041014713816977471/1293532972984832020/cattt.jpg?ex=670860b5&is=67070f35&hm=2eaf26149ec1b229d7a113e5d11a0e28cdc568a65edd6778214e0a92a0b09fe6&",
          'price': 45.0,
          'category': 'ก๋วยเตี๋ยว',
        },
        {
          'name': 'ก๋วยเตี๋ยวเย็นตาโฟ',
          'imageURL':
              "https://cdn.discordapp.com/attachments/1041014713816977471/1293532972984832020/cattt.jpg?ex=670860b5&is=67070f35&hm=2eaf26149ec1b229d7a113e5d11a0e28cdc568a65edd6778214e0a92a0b09fe6&",
          'price': 45.0,
          'category': 'ก๋วยเตี๋ยว',
        },
        {
          'name': 'เกาเหลาทรงเครื่อง',
          'imageURL':
              "https://cdn.discordapp.com/attachments/1041014713816977471/1293532972984832020/cattt.jpg?ex=670860b5&is=67070f35&hm=2eaf26149ec1b229d7a113e5d11a0e28cdc568a65edd6778214e0a92a0b09fe6&",
          'price': 55.0,
          'category': 'ก๋วยเตี๋ยว',
        },
        {
          'name': 'ก๋วยเตี๋ยวน้ำตก',
          'imageURL':
              "https://cdn.discordapp.com/attachments/1041014713816977471/1293532972984832020/cattt.jpg?ex=670860b5&is=67070f35&hm=2eaf26149ec1b229d7a113e5d11a0e28cdc568a65edd6778214e0a92a0b09fe6&",
          'price': 45.0,
          'category': 'ก๋วยเตี๋ยว',
        },
      ]
    };
  }
}
