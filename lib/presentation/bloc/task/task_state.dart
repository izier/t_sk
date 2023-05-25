import 'package:t_sk/models/task.dart';

abstract class TaskState {
  const TaskState();
}

class TaskListInitial extends TaskState {}

class TaskListLoading extends TaskState {}

class TaskListEmpty extends TaskState {}

class TaskListLoaded extends TaskState {
  final List<Task> taskList;

  const TaskListLoaded(this.taskList);
}