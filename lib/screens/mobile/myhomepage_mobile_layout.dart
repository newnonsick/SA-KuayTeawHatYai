import 'package:flutter/material.dart';

class MyHomePageMobileLayout extends StatelessWidget {
  const MyHomePageMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mobile'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Text('Mobile'),
        ),
      ),
    );
  }
}
