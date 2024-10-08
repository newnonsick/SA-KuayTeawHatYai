import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHomePageTabletLayout extends StatelessWidget {
  const MyHomePageTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("เลือกบทบาทของคุณ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.toNamed('/takeorder');
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset('assets/images/mock.png', fit: BoxFit.fill),
                                )),
                            const Expanded(child: Text('จดออร์เดอร์',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30)))
                          ],
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed('/cook');
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset('assets/images/mock.png',
                                      fit: BoxFit.fill),
                                )),
                            const Expanded(child: Text('กุ๊ก',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30)))
                          ],
                        )),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
