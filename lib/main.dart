import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuayteawhatyai/screens/mobile/myhomepage_mobile_layout.dart';
import 'package:kuayteawhatyai/screens/teblet/cookpage_tablet_layout.dart';
import 'package:kuayteawhatyai/screens/teblet/myhomepage_tablet_layout.dart';
import 'package:kuayteawhatyai/screens/teblet/takeorderpage_tablet_layout.dart';
import 'package:kuayteawhatyai/utils/responsive_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(
            name: '/',
            page: () => const ResponsiveLayout(
                  mobile: MyHomePageMobileLayout(),
                  tablet: MyHomePageTabletLayout(),
                )),
        GetPage(
            name: '/takeorder',
            page: () => const ResponsiveLayout(
                  mobile: MyHomePageMobileLayout(),
                  tablet: TakeOrderPageTabletLayout(),
                )),
        GetPage(
            name: '/cook',
            page: () => const ResponsiveLayout(
                  mobile: MyHomePageMobileLayout(),
                  tablet: CookPageTabletLayout(),
                ))
      ],
      home: const ResponsiveLayout(
        mobile: MyHomePageMobileLayout(),
        tablet: TakeOrderPageTabletLayout(),
      ),
      theme: ThemeData(fontFamily: 'Kanit'),
      debugShowCheckedModeBanner: false,
    );
  }
}
