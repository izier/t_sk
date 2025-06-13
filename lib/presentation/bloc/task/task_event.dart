import 'package:t_sk/models/task.dart';

abstract class TaskEvent {
  const TaskEvent();
}

class GetTaskList extends TaskEvent {}


class AddTask extends TaskEvent {
  final Task task;

  const AddTask(this.task);
}

class EditTask extends TaskEvent {
  final Task task;
  final int index;

  const EditTask(this.task, this.index);
}

class DeleteTask extends TaskEvent {
  final int index;

  const DeleteTask(this.index);
}
