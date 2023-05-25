import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:t_sk/models/task.dart';
import 'package:t_sk/models/task_item.dart';
import 'package:t_sk/presentation/bloc/task/task_bloc.dart';
import 'package:t_sk/presentation/bloc/task_item/task_item_bloc.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(() => TaskBloc(locator()));
  locator.registerFactory(() => TaskItemBloc(locator()));

  // hive box
  locator.registerLazySingleton(() => Hive.box<Task>('tasks'));
  locator.registerLazySingleton(() => Hive.box<TaskItem>('taskItems'));
}