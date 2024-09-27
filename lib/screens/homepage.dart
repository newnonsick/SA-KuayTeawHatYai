import 'package:flutter/material.dart';
import 'package:kuayteawhatyai/screens/mobile/homepage_mobile_layout.dart';
import 'package:kuayteawhatyai/screens/teblet/homepage_tablet_layout.dart';
import 'package:kuayteawhatyai/utils/responsive_layout.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: HomePageMobileLayout(),
      tablet: HomePageTabletLayout(),
    );
  }
}
