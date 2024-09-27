import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;
  // && MediaQuery.of(context).size.width < 1200;

  @override
  Widget build(BuildContext context) {
    if (isTablet(context)) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
