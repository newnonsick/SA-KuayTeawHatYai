import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuayteawhatyai/utils/responsive_layout.dart';

class MyHomePageTabletLayout extends StatelessWidget {
  const MyHomePageTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2C5364),
              Color(0xFF0F2027),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "เลือกบทบาทของคุณ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        blurRadius: 12.0,
                        color: Colors.black38,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRoleCard(
                      context,
                      title: 'จดออร์เดอร์',
                      onTap: () => Get.toNamed('/takeorder'),
                      icon: Icons.assignment_outlined,
                      width: width * 0.35,
                    ),
                    _buildRoleCard(
                      context,
                      title: 'กุ๊ก',
                      onTap: () => Get.toNamed('/cook'),
                      icon: Icons.restaurant_menu,
                      width: width * 0.35,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
    required IconData icon,
    required double width,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.white.withOpacity(0.2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: width,
        height: width * 1.2,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8E9EAB), Color(0xFFEEF2F3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: Icon(
                icon,
                size: ResponsiveLayout.isPortrait(context) ? 100 : 150,
                color: const Color(0xFF34495E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveLayout.isPortrait(context) ? 30 : 36,
                color: const Color(0xFF2C3E50),
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
