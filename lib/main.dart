import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text('Pathway Drills'),
        ),
        body: Center(
          child: ListView(
            children: [
              DrillContainer(child: Text('Oath')),
              DrillContainer(child: Text('Oath')),
              ],
          ),
        ),
      ),
    );
  }
}

class DrillContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final VoidCallback? onTap;

  const DrillContainer({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.orange, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}
