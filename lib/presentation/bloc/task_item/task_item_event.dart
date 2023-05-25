import 'package:t_sk/models/task_item.dart';

abstract class TaskItemEvent {
  const TaskItemEvent();
}

class GetTaskItemList extends TaskItemEvent {}

class AddTaskItem extends TaskItemEvent {
  final TaskItem taskItem;

  const AddTaskItem(this.taskItem);
}

class EditTaskItem extends TaskItemEvent {
  final TaskItem taskItem;
  final int index;

  const EditTaskItem(this.taskItem, this.index);
}

class DeleteTaskItem extends TaskItemEvent {
  final int index;

  const DeleteTaskItem(this.index);
}

class SaveTask extends TaskItemEvent {}