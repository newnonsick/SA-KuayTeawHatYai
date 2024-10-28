import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuayteawhatyai/provider/entities/manageorderprovider.dart';
import 'package:kuayteawhatyai/provider/entities/menuchangeingredientprovider.dart';
import 'package:kuayteawhatyai/provider/models/ingredientprovider.dart';
import 'package:kuayteawhatyai/provider/models/orderprovider.dart';
import 'package:kuayteawhatyai/screens/mobile/myhomepage_mobile_layout.dart';
import 'package:kuayteawhatyai/screens/tablet/cookpage_tablet_layout.dart';
import 'package:kuayteawhatyai/screens/tablet/myhomepage_tablet_layout.dart';
import 'package:kuayteawhatyai/screens/tablet/ownerpage_tablet_layout.dart';
import 'package:kuayteawhatyai/screens/tablet/takeorderpage_tablet_layout.dart';
import 'package:kuayteawhatyai/utils/responsive_layout.dart';
import 'package:provider/provider.dart';
import 'package:kuayteawhatyai/provider/entities/orderitemprovider.dart';
import 'package:kuayteawhatyai/provider/entities/orderlistprovider.dart';
import 'package:kuayteawhatyai/provider/entities/orderprovider.dart'
    as entities;

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(
          create: (context) => OrderListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => Ingredientprovider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderItemProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => entities.OrderProvider(),
        ),
        ChangeNotifierProvider(create: (context) => ManageOrderProvider()),
        ChangeNotifierProvider(
            create: (context) => MenuChangeIngredientProvider())
      ],
      child: GetMaterialApp(
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
                  ),
              transition: Transition.topLevel),
          GetPage(
              name: '/cook',
              page: () => const ResponsiveLayout(
                    mobile: MyHomePageMobileLayout(),
                    tablet: CookPageTabletLayout(),
                  ),
              transition: Transition.topLevel),
          GetPage(
              name: '/owner',
              page: () => const ResponsiveLayout(
                    mobile: MyHomePageMobileLayout(),
                    tablet: OwnerPageTabletLayout(),
                  ),
              transition: Transition.topLevel),
        ],
        home: const ResponsiveLayout(
          mobile: MyHomePageMobileLayout(),
          tablet: MyHomePageTabletLayout(),
        ),
        theme: ThemeData(fontFamily: 'Kanit'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
