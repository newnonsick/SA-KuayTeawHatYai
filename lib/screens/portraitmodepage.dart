import 'package:flutter/material.dart';
import 'dart:async'; // Import the dart:async package

class PortraitModePage extends StatefulWidget {
  const PortraitModePage({super.key});

  @override
  State<PortraitModePage> createState() => _PortraitModePageState();
}

class _PortraitModePageState extends State<PortraitModePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(seconds: 2), () {
            _animationController.reverse();
          });
        } else if (status == AnimationStatus.dismissed) {
          Future.delayed(const Duration(seconds: 2), () {
            _animationController.forward();
          });
        }
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8C324),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(5, 5),
                  )
                ],
              ),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animationController.value * 2.0 * 3.14159,
                    child: child,
                  );
                },
                child: const Icon(
                  Icons.screen_rotation,
                  size: 70,
                  color: Color(0xFFF8C324),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Please switch to landscape mode',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}