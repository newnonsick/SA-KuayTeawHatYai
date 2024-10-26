import 'package:flutter/material.dart';
import 'package:kuayteawhatyai/widgets/customnavigationrailitem.dart';

class CustomNavigationRail extends StatelessWidget {
  final List<CustomNavigationRailItem> children;
  const CustomNavigationRail({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
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
            ...children,
          ],
        ),
      ),
    );
  }
}
