import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:t_sk/models/task_item.dart';
import 'package:t_sk/presentation/bloc/task_item/task_item_event.dart';
import 'package:t_sk/presentation/bloc/task_item/task_item_state.dart';

class TaskItemBloc extends Bloc<TaskItemEvent, TaskItemState> {
  Box<TaskItem> taskItemsBox = Hive.box<TaskItem>('taskItems');

  TaskItemBloc(this.taskItemsBox) : super(TaskItemInitial()) {
    on<GetTaskItemList>((event, emit) async {
      if(taskItemsBox.values.isEmpty) {
        emit(TaskItemEmpty());
      } else {
        emit(TaskItemLoaded(taskItemsBox.values.toList()));
      }
    });

    on<AddTaskItem>((event, emit) async {
      taskItemsBox.add(event.taskItem);
      emit(TaskItemLoaded(taskItemsBox.values.toList()));
    });

    on<EditTaskItem>((event, emit) async {
      final index = event.index;
      final editedTaskItem = event.taskItem;
      taskItemsBox.putAt(index, editedTaskItem);
      emit(TaskItemLoaded(taskItemsBox.values.toList()));
    });

    on<DeleteTaskItem>((event, emit) async {
      final index = event.index;
      taskItemsBox.deleteAt(index);
      if(taskItemsBox.values.isEmpty) {
        emit(TaskItemEmpty());
      } else {
        emit(TaskItemLoaded(taskItemsBox.values.toList()));
      }
    });

    on<SaveTask>((event, emit) async {
      taskItemsBox.deleteAll(taskItemsBox.keys);
    });
  }
}