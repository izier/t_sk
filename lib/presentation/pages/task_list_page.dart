import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_sk/presentation/bloc/task/task_bloc.dart';
import 'package:t_sk/presentation/bloc/task/task_event.dart';
import 'package:t_sk/presentation/bloc/task/task_state.dart';
import 'package:t_sk/presentation/pages/task_creation_page.dart';
import 'package:t_sk/presentation/widgets/task_card.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        BlocProvider.of<TaskBloc>(context).add(GetTaskList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('t _ s k'),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskListInitial) {
            BlocProvider.of<TaskBloc>(context).add(GetTaskList());
          } else if (state is TaskListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TaskListLoaded) {
            final taskList = state.taskList;
            return ListView.builder(
              itemBuilder: (context, index) {
                final task = taskList[index];
                return TaskCard(task: task, index: index);
              },
              itemCount: taskList.length,
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.black87),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskCreationPage()));
        },
      ),
    );
  }
}
