import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuayteawhatyai/models/menu.dart';
import 'package:kuayteawhatyai/models/order.dart';
import 'package:kuayteawhatyai/provider/models/orderprovider.dart';
import 'package:kuayteawhatyai/services/apiservice.dart';
import 'package:kuayteawhatyai/utils/responsive_layout.dart';
import 'package:kuayteawhatyai/widgets/customnavigationrail.dart';
import 'package:kuayteawhatyai/widgets/customnavigationrailitem.dart';
import 'package:kuayteawhatyai/widgets/menudialog.dart';
import 'package:kuayteawhatyai/widgets/orderhistoryitem.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TakeOrderPageTabletLayout extends StatefulWidget {
  const TakeOrderPageTabletLayout({super.key});

  @override
  State<TakeOrderPageTabletLayout> createState() =>
      _TakeOrderPageTabletLayoutState();
}

class _TakeOrderPageTabletLayoutState extends State<TakeOrderPageTabletLayout> {
  int _selectedIndex = 4;
  DateTime? _selectedDate;
  bool _haveNotification = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

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
            if (_selectedIndex < 4)
              Expanded(
                child: Row(
                  children: [_buildMenuSection(), _buildOrderListSection()],
                ),
              )
            else if (_selectedIndex == 4)
              _buildOrderManagerSection()
            else if (_selectedIndex == 5)
              _buildOverviewSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewSection() {
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
            Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ประวัติวันที่ ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate!,
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime.now(),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFFF8C324),
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFFF8C324),
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8C324),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // Add some spacing
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: FutureBuilder<Map<String, dynamic>>(
                        future: _fetchOrderByDate(
                            DateFormat('yyyy-MM-dd').format(_selectedDate!)),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFF8C324),
                                ),
                              ),
                            );
                          } else if (snapshot.hasError ||
                              (snapshot.hasData &&
                                  snapshot.data!["code"] != "success")) {
                            return const Center(
                              child: Text(
                                'Error',
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          }

                          final data = snapshot.data!;

                          return Container(
                            height: double.infinity,
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (data["orders"].isNotEmpty)
                                    for (Map<String, dynamic> order
                                        in data["orders"])
                                      OrderHistoryItem(order: order)
                                  else
                                    const Center(
                                      child: Text("No Data"),
                                    )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: FutureBuilder<Map<String, dynamic>>(
                          future: _fetchIncome(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFF8C324),
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError ||
                                (snapshot.hasData &&
                                    snapshot.data!["code"] != "success")) {
                              return const Center(
                                child: Text(
                                  'Error',
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            }

                            final data = snapshot.data!;
                            return Container(
                              padding: const EdgeInsets.all(30),
                              margin: const EdgeInsets.fromLTRB(15, 0, 0, 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Text("฿${data['total_income']}",
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green)),
                                          PieChart(
                                              swapAnimationDuration:
                                                  const Duration(
                                                      milliseconds: 200),
                                              swapAnimationCurve:
                                                  Curves.easeInOutQuint,
                                              PieChartData(sections: [
                                                for (var income
                                                    in data['income'])
                                                  PieChartSectionData(
                                                    color: _getCategoryColor(
                                                        income['category']),
                                                    value:
                                                        income['total_income'],
                                                    title: income['category'],
                                                    radius: 50,
                                                  )
                                              ])),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  Expanded(
                                    flex: ResponsiveLayout.isPortrait(context)
                                        ? 2
                                        : 1,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            _getCategoryColor(
                                                                "อาหาร"),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Text(
                                                    "อาหาร",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            _getCategoryColor(
                                                                "เครื่องดื่ม"),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Text("เครื่องดื่ม",
                                                      style: TextStyle(
                                                          fontSize: 20))
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            _getCategoryColor(
                                                                "ของทานเล่น"),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Text("ของทานเล่น",
                                                      style: TextStyle(
                                                          fontSize: 20))
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 25),
                                          for (var income in data['income'])
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 70,
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                        color: _getCategoryColor(
                                                            income['category']),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                    child: Icon(
                                                      _getCategoryIcon(
                                                          income['category']),
                                                      size: 40,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  SizedBox(
                                                    width: 90,
                                                    child: Column(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "${income['category']}",
                                                            style: const TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "฿ ${income['total_income']}",
                                                            textAlign:
                                                                TextAlign.start,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    "(${income['total_sales']} เซิร์ฟ)",
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.grey),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                      "${(income['total_income'] / data['total_income'] * 100).toStringAsFixed(2)}%",
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.grey),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderManagerSection() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("KuayTeawHatYai",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0xFFF8C324),
                )),
            Text("จัดการออร์เดอร์",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 30,
                  color: Color(0xFF000000),
                )),
            Expanded(
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: Color(0xFFF8C324),
                      tabs: [
                        Tab(
                          child: Text(
                            'ออร์เดอร์ทั้งหมด',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'เมนูในออร์เดอร์',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Center(
                            child: Text('Clubs'),
                          ),
                          Center(
                            child: Text('Search'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded(
                //   child: TextField(
                //     onTapOutside: (event) => FocusScope.of(context).unfocus(),
                //     cursorColor: Colors.black,
                //     decoration: InputDecoration(
                //       fillColor: Colors.white,
                //       filled: true,
                //       prefixIcon: const Icon(
                //         Icons.search,
                //         size: 20,
                //         color: Color(0xFFF8C324),
                //       ),
                //       hintText: 'ค้นหาเมนู',
                //       hintStyle:
                //           const TextStyle(color: Colors.grey, fontSize: 14),
                //       contentPadding: const EdgeInsets.fromLTRB(0, 5, 40, 5),
                //       border: OutlineInputBorder(
                //         borderRadius:
                //             const BorderRadius.all(Radius.circular(30)),
                //         borderSide: BorderSide(color: Colors.grey[400]!),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderRadius:
                //             const BorderRadius.all(Radius.circular(30)),
                //         borderSide: BorderSide(color: Colors.grey[400]!),
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //         borderRadius:
                //             const BorderRadius.all(Radius.circular(30)),
                //         borderSide: BorderSide(color: Colors.grey[400]!),
                //       ),
                //     ),
                //   ),
                // ),
                const Text("KuayTeawHatYai",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color(0xFFF8C324),
                    )),
                Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 4;
                          _haveNotification = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8C324),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (_haveNotification)
                      const Positioned(
                        right: 8,
                        top: 8,
                        child: Icon(
                          Icons.circle,
                          color: Colors.red,
                          size: 15,
                        ),
                      ),
                  ],
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
                        if (menu.category != "อาหาร") {
                          Provider.of<OrderProvider>(context, listen: false)
                              .addOrder(Order(menu: menu, quantity: 1));
                          return;
                        }

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
                          'กรุณาเลือกหมายเลขโต๊ะ',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF8C324),
                          ),
                        ),
                      ),
                      content: FutureBuilder(
                        future: _fetchTables(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFF8C324),
                                  ),
                                ),
                              ),
                            );
                          } else if (snapshot.hasError ||
                              (snapshot.hasData &&
                                  (snapshot.data!["code"] != "success"))) {
                            return const Center(
                              child: Text('Error',
                                  style: TextStyle(color: Colors.red)),
                            );
                          }
                          final data = snapshot.data as Map<String, dynamic>;
                          List tableList = data['tables'] as List;
                          List<String> tables = tableList
                              .map((table) => table['table_number'].toString())
                              .toList();
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (String table in tables)
                                  GestureDetector(
                                    onTap: () async {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              title: Center(
                                                child: Text(
                                                  'ยืนยันการสั่งอาหาร $table',
                                                  style: const TextStyle(
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
                                                      orderProvider
                                                          .setTableNumber(
                                                              table);

                                                      final response =
                                                          await ApiService()
                                                              .postData(
                                                                  'orders/add',
                                                                  orderProvider
                                                                      .toJson());

                                                      if (response
                                                              .data['code'] ==
                                                          'success') {
                                                        orderProvider
                                                            .clearOrder();
                                                        Get.back();
                                                        Get.back();

                                                        if (mounted) {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                  ),
                                                                  title:
                                                                      const Center(
                                                                    child: Text(
                                                                      'สั่งอาหารสำเร็จ',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            22,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Color(
                                                                            0xFFF8C324),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  content:
                                                                      const Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .check_circle,
                                                                        color: Color(
                                                                            0xFFF8C324),
                                                                        size:
                                                                            100,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              });
                                                        }
                                                      } else {
                                                        Get.back();
                                                        if (mounted) {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                  ),
                                                                  title:
                                                                      const Center(
                                                                    child: Text(
                                                                      'สั่งอาหารไม่สำเร็จ',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            22,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Color(
                                                                            0xFFF8C324),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  content:
                                                                      const Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .error_outline,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            100,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              });
                                                        }
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                              0xFFF8C324),
                                                      foregroundColor:
                                                          Colors.black,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    child: const Center(
                                                      child: FittedBox(
                                                        child: Text(
                                                          'ตกลง',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.grey,
                                                      foregroundColor:
                                                          Colors.white,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    child: const Center(
                                                      child: FittedBox(
                                                        child: Text(
                                                          'ยกเลิก',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8C324),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          table,
                                          style: const TextStyle(
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
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back(); // Close the dialog
                          },
                          child: const Text(
                            'ยกเลิก',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
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
                  if (order.menu.category == "อาหาร")
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
    return CustomNavigationRail(children: [
      CustomNavigationRailItem(
        icon: Icons.home,
        label: 'ทั้งหมด',
        index: 0,
        selectedIndex: _selectedIndex,
        onItemTapped: (int value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
      CustomNavigationRailItem(
        icon: Icons.fastfood,
        label: 'อาหาร',
        index: 1,
        selectedIndex: _selectedIndex,
        onItemTapped: (int value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
      CustomNavigationRailItem(
        icon: Icons.local_drink,
        label: 'เครื่องดื่ม',
        index: 2,
        selectedIndex: _selectedIndex,
        onItemTapped: (int value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
      CustomNavigationRailItem(
        icon: Icons.icecream,
        label: 'ของทานเล่น',
        index: 3,
        selectedIndex: _selectedIndex,
        onItemTapped: (int value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
      CustomNavigationRailItem(
        icon: Icons.receipt,
        label: 'จัดการออร์เดอร์',
        index: 4,
        selectedIndex: _selectedIndex,
        onItemTapped: (int value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
      CustomNavigationRailItem(
        icon: Icons.info,
        label: 'ภาพรวม',
        index: 5,
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

  Future<Map<String, dynamic>> _fetchMenus() async {
    final response = await ApiService().getData(_getFetchUrl());
    return response.data;
  }

  String _getFetchUrl() {
    switch (_selectedIndex) {
      case 1:
        return 'menus?category=อาหาร';
      case 2:
        return 'menus?category=เครื่องดื่ม';
      case 3:
        return 'menus?category=ของทานเล่น';
      default:
        return 'menus';
    }
  }

  Future<Map<String, dynamic>> _fetchTables() async {
    final response = await ApiService().getData('tables');
    return response.data;
  }

  Future<Map<String, dynamic>> _fetchIncome() async {
    final response = await ApiService().getData(
        'income?date=${DateFormat('yyyy-MM-dd').format(_selectedDate!)}');
    return response.data;
  }

  Future<Map<String, dynamic>> _fetchOrderByDate(String date) async {
    final response = await ApiService().getData('orders?date=$date');
    return response.data;
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'อาหาร':
        return const Color(0xFFF8C324);
      case 'เครื่องดื่ม':
        return const Color(0xFFE57373);
      case 'ของทานเล่น':
        return const Color(0xFF64B5F6);
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'อาหาร':
        return Icons.fastfood;
      case 'เครื่องดื่ม':
        return Icons.local_drink;
      case 'ของทานเล่น':
        return Icons.icecream;
      default:
        return Icons.error;
    }
  }
}
