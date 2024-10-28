import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuayteawhatyai/widgets/customnavigationrail.dart';
import 'package:kuayteawhatyai/widgets/customnavigationrailitem.dart';

class OwnerPageTabletLayout extends StatefulWidget {
  const OwnerPageTabletLayout({super.key});

  @override
  State<OwnerPageTabletLayout> createState() => _OwnerPageTabletLayoutState();
}

class _OwnerPageTabletLayoutState extends State<OwnerPageTabletLayout> {
  int _selectedIndex = 0;

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
            if (_selectedIndex == 0) _buildMangeMenuSection()
          ],
        ),
      ),
    );
  }

  Widget _buildMangeMenuSection() {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text("KuayTeawHatYai",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0xFFF8C324),
                )),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("จัดการเมนู",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black,
                )),
          ),
        ],
      ),
    ));
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
