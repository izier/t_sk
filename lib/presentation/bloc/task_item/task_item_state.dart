import 'package:t_sk/models/task_item.dart';

abstract class TaskItemState {
  const TaskItemState();
}

class TaskItemInitial extends TaskItemState {}

class TaskItemLoading extends TaskItemState {}

class TaskItemEmpty extends TaskItemState {}

class TaskItemLoaded extends TaskItemState {
  List<TaskItem> taskItems;

  TaskItemLoaded(this.taskItems);
}