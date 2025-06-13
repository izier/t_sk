import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:t_sk/common/app_theme_data.dart';
import 'package:t_sk/models/task.dart';
import 'package:t_sk/models/task_item.dart';
import 'package:t_sk/presentation/bloc/task/task_bloc.dart';
import 'package:t_sk/presentation/bloc/task/task_event.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;
  final int index;

  const TaskDetailPage({
    super.key,
    required this.task,
    required this.index,
  });

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.task.category),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: appThemeData.primaryColor,
                      ),
                      child: Text("Deadline: ${DateFormat.MMMMd().format(widget.task.finishTime!)}"),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(widget.task.title, style: appThemeData.textTheme.headlineLarge),
                const SizedBox(height: 8),
                Text(widget.task.description),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                color: Color(0XFFF6F262),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Goals", style: appThemeData.textTheme.headlineLarge),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                TextEditingController taskItemTitleController = TextEditingController();
                                TextEditingController taskItemDescriptionController = TextEditingController();
                                return AlertDialog(
                                  title: const Text('Add Goal'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                        controller: taskItemTitleController,
                                        decoration: const InputDecoration(
                                            labelText: 'Title'
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: taskItemDescriptionController,
                                        decoration: const InputDecoration(
                                            labelText: 'Description'
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                    TextButton(
                                      child: const Text('Add'),
                                      onPressed: () {
                                        setState(() {
                                          final newTaskItem = TaskItem(
                                            title: taskItemTitleController.text,
                                            description: taskItemDescriptionController.text,
                                            isCompleted: false,
                                          );
                                          widget.task.items.add(newTaskItem);
                                          BlocProvider.of<TaskBloc>(context).add(EditTask(widget.task, widget.index));
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                  ],
                                );
                              }
                          );
                        },
                        icon: const Icon(Icons.add, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  widget.task.items.isEmpty ?
                  Container() :
                  Expanded(
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        TaskItem taskItem = widget.task.items[index];bool isCompleted = false;

                        if(taskItem.isCompleted) {
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
                                      setState(() {
                                        isCompleted = !isCompleted;
                                        taskItem.isCompleted = isCompleted;
                                        widget.task.items[index].isCompleted = isCompleted;
                                        BlocProvider.of<TaskBloc>(context).add(EditTask(widget.task, widget.index));
                                      });
                                    },
                                    icon: Icon(
                                      isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                                      color: isCompleted ? Colors.green : Colors.grey,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: taskItem.description.isNotEmpty ?
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(taskItem.title, style: appThemeData.textTheme.titleLarge),
                                      const SizedBox(height: 4),
                                      Text(taskItem.description, style: appThemeData.textTheme.bodyMedium),
                                    ],
                                  ) :
                                  Text(taskItem.title, style: appThemeData.textTheme.titleLarge),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              TextEditingController taskItemTitleController = TextEditingController();
                                              taskItemTitleController.text = taskItem.title;
                                              TextEditingController taskItemDescriptionController = TextEditingController();
                                              taskItemDescriptionController.text = taskItem.description;
                                              return AlertDialog(
                                                title: const Text('Edit Task Item'),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    TextField(
                                                      controller: taskItemTitleController,
                                                      decoration: const InputDecoration(labelText: 'Title'),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    TextField(
                                                      controller: taskItemDescriptionController,
                                                      decoration: const InputDecoration(labelText: 'Description'),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: const Text('Cancel'),
                                                    onPressed: () => Navigator.of(context).pop(),
                                                  ),
                                                  TextButton(
                                                    child: const Text('Edit'),
                                                    onPressed: () {
                                                      setState(() {
                                                        taskItem.title = taskItemTitleController.text;
                                                        taskItem.description = taskItemDescriptionController.text;
                                                        widget.task.items[index].title = taskItemTitleController.text;
                                                        widget.task.items[index].description = taskItemDescriptionController.text;
                                                        BlocProvider.of<TaskBloc>(context).add(EditTask(widget.task, widget.index));
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        });
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.task.items.removeAt(index);
                                          BlocProvider.of<TaskBloc>(context).add(EditTask(widget.task, widget.index));
                                        });
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: widget.task.items.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        child: const Icon(Icons.edit, color: Color(0XFFF6F262)),
        onPressed: () {
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  TextEditingController titleController = TextEditingController();
                  TextEditingController descriptionController = TextEditingController();
                  TextEditingController categoryController = TextEditingController();
                  TextEditingController finishTimeController = TextEditingController();

                  titleController.text = widget.task.title;
                  descriptionController.text = widget.task.description;
                  categoryController.text = widget.task.category;
                  finishTimeController.text = widget.task.finishTime.toString();

                  return AlertDialog(
                    title: const Text('Edit Task'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                              labelText: 'Title'
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                              labelText: 'Description'
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: categoryController,
                          decoration: const InputDecoration(
                              labelText: 'Category'
                          ),
                        ),
                        const SizedBox(height: 8),
                        DateTimePicker(
                          type: DateTimePickerType.dateTimeSeparate,
                          dateMask: 'd MMM, yyyy',
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          dateLabelText: 'Finish date',
                          timeLabelText: 'Time',
                          selectableDayPredicate: (date) {
                            if (date.weekday == 6 || date.weekday == 7) {
                              return false;
                            }
                            return true;
                          },
                          onChanged: (val) {
                            finishTimeController.text = val;
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('SaFve'),
                        onPressed: () {
                          setState(() {
                            widget.task.title = titleController.text;
                            widget.task.description = descriptionController.text;
                            widget.task.category = categoryController.text;
                            widget.task.finishTime = DateTime.parse(finishTimeController.text);
                            BlocProvider.of<TaskBloc>(context).add(EditTask(widget.task, widget.index));
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  );
                }
            );
          });
        },
      ),
    );
  }
}