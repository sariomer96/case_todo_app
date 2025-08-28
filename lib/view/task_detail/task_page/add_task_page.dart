import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spexco_todo_app/view/home/view_model/home_view_model.dart';
import 'package:spexco_todo_app/view/task_detail/base/base_task_form_page.dart';
import 'package:spexco_todo_app/view/task_detail/view_model/add_task_view_model.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  @override
  Widget build(BuildContext context) {
    var homeViewModel = context.watch<HomeViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni Görev"),
        centerTitle: true,
      ),
      body: BaseTaskFormWidget<AddTaskViewModel>(
        buttonText: "Oluştur",
        onSubmit: (vm, task) async {
          final success = await vm.addTask(task);
          await homeViewModel.getAllTask();
          if (success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Görev oluşturuldu")),
            );
          }
          return success;
        },
      ),
    );
  }
}
