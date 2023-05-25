import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_sk/common/app_theme_data.dart';
import 'package:t_sk/models/task.dart';
import 'package:t_sk/models/task_item.dart';
import 'package:t_sk/presentation/bloc/task/task_bloc.dart';
import 'package:t_sk/presentation/bloc/task/task_event.dart';
import 'package:t_sk/presentation/bloc/task_item/task_item_bloc.dart';
import 'package:t_sk/presentation/bloc/task_item/task_item_event.dart';
import 'package:t_sk/presentation/bloc/task_item/task_item_state.dart';
import 'package:t_sk/presentation/widgets/task_item_create_card.dart';

class TaskCreationPage extends StatelessWidget {
  const TaskCreationPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    TextEditingController dateTimeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text('Create a task', style: appThemeData.textTheme.headlineLarge),
                const SizedBox(height: 16),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                  ),
                ),
                const SizedBox(height: 4),
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
                    dateTimeController.text = val;
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                color: appThemeData.primaryColor,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        final newTaskItem = TaskItem(
                                          title: taskItemTitleController.text,
                                          description: taskItemDescriptionController.text,
                                          isCompleted: false,
                                        );
                                        BlocProvider.of<TaskItemBloc>(context).add(AddTaskItem(newTaskItem));
                                        BlocProvider.of<TaskItemBloc>(context).add(GetTaskItemList());
                                        Navigator.pop(context);
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
                  BlocBuilder<TaskItemBloc, TaskItemState>(
                    builder: (context, state) {
                      if(state is TaskItemInitial) {
                        BlocProvider.of<TaskItemBloc>(context).add(GetTaskItemList());
                      } else if (state is TaskItemLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is TaskItemEmpty) {
                        return const Expanded(child: Center(child: Text('Add more task items')));
                      } else if (state is TaskItemLoaded) {
                        List<TaskItem> taskItems = state.taskItems;
                        return Expanded(
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              TaskItem taskItem = taskItems[index];
                              return TaskItemCreateCard(index: index, taskItem: taskItem);
                            },
                            itemCount: taskItems.length,
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: () {
          final newTask = Task(
            title: titleController.text.isEmpty ? '' : titleController.text,
            description: descriptionController.text.isEmpty ? '' : descriptionController.text,
            category: categoryController.text.isEmpty ? '' : categoryController.text,
            createTime: DateTime.now(),
            finishTime: dateTimeController.text.isEmpty ? DateTime.now() : DateTime.parse(dateTimeController.text),
            items: BlocProvider.of<TaskItemBloc>(context).taskItemsBox.values.toList(),
          );
          BlocProvider.of<TaskBloc>(context).add(AddTask(newTask));
          BlocProvider.of<TaskItemBloc>(context).add(SaveTask());
          BlocProvider.of<TaskItemBloc>(context).add(GetTaskItemList());
          Navigator.pop(context);
        },
        child: const Icon(Icons.save, color: Color(0XFFF6F262)),
      ),
    );
  }
}