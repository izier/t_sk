import 'package:hive/hive.dart';
import 'package:t_sk/models/task_item.dart';

class Task extends HiveObject{
  String title;
  String description;
  String category;
  DateTime createTime;
  DateTime? finishTime;
  List<TaskItem> items;

  Task({
    required this.title,
    required this.description,
    required this.category,
    required this.createTime,
    required this.finishTime,
    required this.items,
  });
}