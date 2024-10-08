import 'package:flutter/material.dart';
import 'package:kuayteawhatyai/screens/portraitmodepage.dart';
import 'package:kuayteawhatyai/utils/responsive_layout.dart';

class TakeOrderPageTabletLayout extends StatefulWidget {
  const TakeOrderPageTabletLayout({super.key});

  @override
  State<TakeOrderPageTabletLayout> createState() =>
      _TakeOrderPageTabletLayoutState();
}

class _TakeOrderPageTabletLayoutState extends State<TakeOrderPageTabletLayout> {
  int _selectedIndex = 0; // State to manage the selected index

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout.isPortrait(context)
        ? const PortraitModePage()
        : _buildLandScape();
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
                  Container(
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
            ],
          ),
        ));
  }

  Widget _buildOrderListSection() {
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
          const Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [],
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
          const Row(
            children: [
              Text(
                'ราคารวม',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Spacer(),
              Text(
                '฿ 000',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF8C324),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Center(
              child: Text(
                'บันทึกออร์เดอร์',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildCustomNavigationRail() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: Colors.grey[400]!,
            width: 1,
          ),
        ),
      ),
      child: Column(
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
        ],
      ),
    );
  }

  Widget _buildCustomNavigationRailItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
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
              child: Icon(icon),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            if (index != 3)
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
}
