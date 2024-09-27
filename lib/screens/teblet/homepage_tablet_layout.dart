import 'package:flutter/material.dart';

class HomePageTabletLayout extends StatelessWidget {
  const HomePageTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tablet'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Text('Tablet'),
        ),
      ),
    );
  }
}
