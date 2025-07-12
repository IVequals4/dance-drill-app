import 'dart:math';
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
        body: DrillListScreen(
          drillContainers: [
            DrillContainer(
              drillName: Text('Exercise 1'),
              drillList: Text('1. Push Ups\n2. Sit Ups\n3. Squats\n'),
            ),
            DrillContainer(
              drillName: Text('Exercise 2'),
              drillList: Text('1. Burpees\n2. Jumping Jacks\n3. Plank\n'),
            ),
            DrillContainer(
              drillName: Text('Exercise 3'),
              drillList: Text('1. Pull Ups\n2. Lunges\n3. Crunches\n'),
            ),
          ],
        ),
      ),
    );
  }
}

class DrillListScreen extends StatefulWidget {
  final List<DrillContainer> drillContainers;

  const DrillListScreen({super.key, required this.drillContainers});

  @override
  State<DrillListScreen> createState() => _DrillListScreenState();
}

class _DrillListScreenState extends State<DrillListScreen> {
  // Store all DrillContainers in a list

  void openRandomContainer() {
    if (widget.drillContainers.isEmpty) return;

    final random = Random();
    final randomIndex = random.nextInt(widget.drillContainers.length);
    final randomContainer = widget.drillContainers[randomIndex];

    // Show dialog using the same method as DrillContainer
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: randomContainer.drillName,
          content: randomContainer.drillList,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: ElevatedButton.icon(
            onPressed: openRandomContainer,
            icon: Icon(Icons.shuffle),
            label: Text('Random Drill'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        Expanded(child: ListView(children: widget.drillContainers)),
      ],
    );
  }
}

class DrillContainer extends StatelessWidget {
  final Widget drillName;
  final Widget drillList;
  final Color color;

  const DrillContainer({
    super.key,
    required this.drillName,
    required this.drillList,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: drillName,
              content: drillList,
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.orange, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: drillName,
      ),
    );
  }
}
