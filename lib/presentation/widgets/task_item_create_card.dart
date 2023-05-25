import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_sk/common/app_theme_data.dart';
import 'package:t_sk/models/task_item.dart';
import 'package:t_sk/presentation/bloc/task_item/task_item_bloc.dart';
import 'package:t_sk/presentation/bloc/task_item/task_item_event.dart';

class TaskItemCreateCard extends StatefulWidget {
  final TaskItem taskItem;
  final int index;

  const TaskItemCreateCard({super.key, required this.taskItem, required this.index});

  @override
  State<TaskItemCreateCard> createState() => _TaskItemCreateCardState();
}

class _TaskItemCreateCardState extends State<TaskItemCreateCard> {
  @override
  Widget build(BuildContext context) {
    bool isCompleted = false;

    if(widget.taskItem.isCompleted) {
      isCompleted = true;
    }

    return Card(
      elevation: 0,
      color: const Color(0XFFFFFD9B),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  isCompleted = !isCompleted;
                  widget.taskItem.isCompleted = isCompleted;
                  BlocProvider.of<TaskItemBloc>(context).add(EditTaskItem(widget.taskItem, widget.index));
                },
                icon: Icon(
                  isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                  color: isCompleted ? Colors.green : Colors.grey,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: widget.taskItem.description.isNotEmpty ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.taskItem.title, style: appThemeData.textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(widget.taskItem.description, style: appThemeData.textTheme.bodyMedium),
                  ],
                ) :
                Text(widget.taskItem.title, style: appThemeData.textTheme.titleLarge),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    BlocProvider.of<TaskItemBloc>(context).add(EditTaskItem(widget.taskItem, widget.index));
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController taskItemTitleController = TextEditingController();
                          taskItemTitleController.text = widget.taskItem.title;
                          TextEditingController taskItemDescriptionController = TextEditingController();
                          taskItemDescriptionController.text = widget.taskItem.description;
                          return AlertDialog(
                            title: const Text('Edit Task Item'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: taskItemTitleController,
                                  decoration: const InputDecoration(labelText: 'TItle'),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: taskItemDescriptionController,
                                  decoration: const InputDecoration(hintText: 'Description'),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: const Text('Save'),
                                onPressed: () {
                                  final editedTaskItem = TaskItem(
                                    title: taskItemTitleController.text,
                                    description: taskItemDescriptionController.text,
                                    isCompleted: false,
                                  );
                                  BlocProvider.of<TaskItemBloc>(context).add(EditTaskItem(editedTaskItem, widget.index));
                                  BlocProvider.of<TaskItemBloc>(context).add(GetTaskItemList());
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    BlocProvider.of<TaskItemBloc>(context).add(DeleteTaskItem(widget.index));
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}