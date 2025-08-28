import 'package:flutter/material.dart';
import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/view/home/home_page/home_page.dart';
import 'package:spexco_todo_app/view/task_detail/task_page/add_task_page.dart';
import 'package:spexco_todo_app/view/task_detail/task_page/edit_task_page.dart';

class TaskFormBottomSheet extends StatelessWidget {
  final Task? task;
  final TaskPageEnum selectedFormPage;
  const TaskFormBottomSheet(
      {super.key, this.task, required this.selectedFormPage});

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (selectedFormPage) {
      case TaskPageEnum.addForm:
        content = const AddTaskPage();
        break;
      case TaskPageEnum.editForm:
        if (task != null) {
          content = EditTaskPage(task: task!);
        } else {
          throw Exception('Task null error');
        }
        break;
    }
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.25,
      maxChildSize: 0.75,
      expand: false,
      builder: (context, scrollController) {
        return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: content);
      },
    );
  }
}
