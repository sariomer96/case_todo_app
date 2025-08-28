// edit_task_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/view/home/view_model/home_view_model.dart';
import 'package:spexco_todo_app/view/task_detail/base/base_task_form_page.dart';
import 'package:spexco_todo_app/view/task_detail/view_model/edit_task_view_model.dart';

class EditTaskPage extends StatefulWidget {
  final Task? task;
  const EditTaskPage({
    super.key,
    this.task,
  });

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  @override
  void initState() {
    super.initState(); 
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.task != null) {
        Provider.of<EditTaskViewModel>(context, listen: false).setTask(widget.task!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
      var homeViewModel = context.watch<HomeViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text("Görev Düzenle")),
      body: BaseTaskFormWidget<EditTaskViewModel>(
        buttonText: "Güncelle",
        task: widget.task,
        onSubmit: (vm, updatedTask) async {
          final success = await vm.editTask(updatedTask);
            await homeViewModel.getAllTask();
          if (success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Görev güncellendi")),
            );
          }
          return true;
        },
      ),
    );
  }
}