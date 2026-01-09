import 'package:hive/hive.dart';

part 'reference.g.dart';  

@HiveType(typeId: 1)
class Reference extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<String> tags;

  @HiveField(2)
  String description;

  Reference({
    required this.name, 
    required this.tags, 
    required this.description
  });
}