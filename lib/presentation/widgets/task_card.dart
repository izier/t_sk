import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:t_sk/common/app_theme_data.dart';
import 'package:t_sk/models/task.dart';
import 'package:t_sk/presentation/bloc/task/task_bloc.dart';
import 'package:t_sk/presentation/bloc/task/task_event.dart';
import 'package:t_sk/presentation/pages/task_detail_page.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final int index;

  const TaskCard({super.key, required this.task, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskDetailPage(task: task, index: index)),
        );
      },
      child: Card(
        color: appThemeData.primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.category, style: appThemeData.textTheme.bodySmall),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(task.title, style: appThemeData.textTheme.headlineLarge),
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<TaskBloc>(context).add(DeleteTask(index));
                    },
                    icon: const Icon(Icons.delete),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(task.items.where((element) => element.isCompleted == true).length.toString(), style: appThemeData.textTheme.headlineLarge),
                  Text("/${task.items.length} tasks completed", style: appThemeData.textTheme.titleSmall),
                ],
              ),
              const SizedBox(height: 4),
              LinearPercentIndicator(
                lineHeight: 8.0,
                percent: task.items.where((element) => element.isCompleted == true).length / task.items.length,
                progressColor: Colors.black87,
                barRadius: const Radius.circular(16),
              )
            ],
          ),
        ),
      ),
    );
  }
}