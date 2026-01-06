import 'package:hive/hive.dart';

part 'drill.g.dart';  // This tells Hive where to generate the adapter

// ======================
// DATA MODEL
// ======================
@HiveType(typeId: 0)
class Drill extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String list;

  Drill({required this.name, required this.list});
}