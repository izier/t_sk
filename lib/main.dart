import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:t_sk/common/app_theme_data.dart';
import 'package:t_sk/models/task.dart';
import 'package:t_sk/models/task_item.dart';
import 'package:t_sk/presentation/bloc/task/task_bloc.dart';
import 'package:t_sk/presentation/bloc/task_item/task_item_bloc.dart';
import 'package:t_sk/presentation/pages/task_list_page.dart';
import 'package:t_sk/services/task_adapter.dart';
import 'package:t_sk/services/task_item_adapter.dart';
import 'package:t_sk/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  di.init();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TaskItemAdapter());
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<TaskItem>('taskItems');
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<TaskBloc>()),
        BlocProvider(create: (_) => di.locator<TaskItemBloc>()),
      ],
      child: MaterialApp(
        title: 'Task App',
        theme: appThemeData,
        home: const TaskListPage(),
      ),
    );
  }
}