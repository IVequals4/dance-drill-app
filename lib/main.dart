import 'package:demo/pages/references_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/drill_page.dart';
import 'models/drill.dart';
import 'models/reference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); 
  Hive.registerAdapter(DrillAdapter()); 
  Hive.registerAdapter(ReferenceAdapter());

  await Hive.openBox<Drill>('drills'); 
  await Hive.openBox<Reference>('references');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainPager(),
    );
  }
}

class MainPager extends StatelessWidget {
  const MainPager({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const ClampingScrollPhysics(),
      children: const [
        DrillListPage(), 
        ReferencesPage()],
    );
  }
}
