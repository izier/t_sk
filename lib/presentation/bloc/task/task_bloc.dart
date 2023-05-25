import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:t_sk/models/task.dart';
import 'package:t_sk/presentation/bloc/task/task_event.dart';
import 'package:t_sk/presentation/bloc/task/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  Box<Task> taskBox = Hive.box<Task>('tasks');
  TaskBloc(this.taskBox) : super(TaskListInitial()) {
    on<GetTaskList>((event, emit) async {
      emit(TaskListLoading());
      if(taskBox.values.isEmpty) {
        emit(TaskListEmpty());
      } else {
        emit(TaskListLoaded(taskBox.values.toList()));
      }
    });

    on<AddTask>((event, emit) async {
      final task = event.task;
      taskBox.add(task);
      emit(TaskListLoaded(taskBox.values.toList()));
    });

    on<EditTask>((event, emit) async {
      final index = event.index;
      final editedTask = event.task;
      taskBox.putAt(index, editedTask);
      emit(TaskListLoaded(taskBox.values.toList()));
    });

    on<DeleteTask>((event, emit) async {
      final index = event.index;
      taskBox.deleteAt(index);
      if(taskBox.values.isEmpty) {
        emit(TaskListEmpty());
      } else {
        emit(TaskListLoaded(taskBox.values.toList()));
      }
    });
  }
}