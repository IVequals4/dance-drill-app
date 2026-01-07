import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/drill.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // initialize Hive
  Hive.registerAdapter(DrillAdapter()); // register Drill adapter

  await Hive.openBox<Drill>('drills'); // open a box to store drills

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DrillListScreen(),
    );
  }
}

// [x]: Create 'Add Drill' Button
// [x]: Create 'Remove Drill' Button
// [x]: Create 'Edit Drill' Button

// ======================
// MAIN SCREEN
// ======================
class DrillListScreen extends StatefulWidget {
  const DrillListScreen({super.key});

  @override
  State<DrillListScreen> createState() => _DrillListScreenState();
}

class _DrillListScreenState extends State<DrillListScreen> {
  late Box<Drill> drillBox;
  late List<Drill> drills;

  @override
  void initState() {
    super.initState();

    drillBox = Hive.box<Drill>('drills');

    // Load drills from box, or create defaults if empty
    if (drillBox.isEmpty) {
      final defaultDrills = [
        Drill(name: 'Exercise 1', list: '1. Push Ups\n2. Sit Ups\n3. Squats'),
        Drill(
          name: 'Exercise 2',
          list: '1. Burpees\n2. Jumping Jacks\n3. Plank',
        ),
        Drill(name: 'Exercise 3', list: '1. Pull Ups\n2. Lunges\n3. Crunches'),
      ];

      drillBox.addAll(defaultDrills);
    }

    drills = drillBox.values.toList();
  }

  // ======================
  // RANDOM DRILL
  // ======================
  void openRandomContainer() {
    if (drills.isEmpty) return;

    final random = Random();
    final drill = drills[random.nextInt(drills.length)];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(drill.name),
        content: Text(drill.list),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // ======================
  // ADD DRILL
  // ======================
  void addDrill() {
    final nameController = TextEditingController();
    final listController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Drill'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Drill Name'),
            ),
            TextField(
              controller: listController,
              decoration: const InputDecoration(labelText: 'Drill List'),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty || listController.text.isEmpty)
                return;

              final newDrill = Drill(
                name: nameController.text,
                list: listController.text,
              );

              drillBox.add(newDrill);

              setState(() {
                drills = drillBox.values.toList();
              });

              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // ======================
  // EDIT DRILL
  // ======================
  void editDrill(int index) {
    final drill = drills[index];
    final nameController = TextEditingController(text: drill.name);
    final listController = TextEditingController(text: drill.list);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Drill'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Drill Name'),
            ),
            TextField(
              controller: listController,
              decoration: const InputDecoration(labelText: 'Drill List'),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              drill.name = nameController.text;
              drill.list = listController.text;
              drill.save(); // Save changes in Hive

              setState(() {
                drills = drillBox.values.toList();
              });

              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ======================
  // UI
  // ======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Pathway Drills'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: addDrill,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ElevatedButton.icon(
              onPressed: openRandomContainer,
              icon: const Icon(Icons.shuffle),
              label: const Text('Random Drill'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: drills.length,
              itemBuilder: (context, index) {
                final drill = drills[index];
                return DrillContainer(
                  drill: drill,
                  onEdit: () => editDrill(index),
                  onRemove: () async {
                    await drills[index].delete(); // remove from Hive

                    setState(() {
                      drills = drillBox.values.toList(); // refresh UI
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ======================
// DRILL CARD
// ======================
class DrillContainer extends StatelessWidget {
  final Drill drill;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const DrillContainer({
    super.key,
    required this.drill,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(drill.name),
            content: Text(drill.list),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onEdit();
                },
                child: const Text('Edit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onRemove();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(drill.name),
      ),
    );
  }
}

// TODO: Create tags to sort and search by for each drill
