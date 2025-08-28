import 'package:flutter/material.dart';
import 'package:spexco_todo_app/view/home/view_model/home_view_model.dart';
import 'package:spexco_todo_app/view/task_detail/base/base_task_form_page.dart';
import 'package:spexco_todo_app/view/task_detail/view_model/task_form_view_model.dart';
 
 

class EditTaskPage extends BaseTaskFormPage {
  const EditTaskPage({super.key});

  @override
  State<EditTaskPage> createState() => _EditTaskFormPageState();
}

class _EditTaskFormPageState extends BaseTaskFormPageState<EditTaskPage> {
  @override
  String get buttonText => 'Güncelle';
 
   @override
  Future<bool> onButtonPressed(
      TaskFormViewModel taskViewModel,
      HomeViewModel homeViewModel) async {
    var updatedTask = createTaskModel(taskViewModel);
    updatedTask.id = taskViewModel.task?.id;  
    return await taskViewModel.editTask(updatedTask);
  }
  @override
  void onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Başarıyla Güncellendi"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void onError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Güncelleme sırasında hata oluştu"),
        backgroundColor: Colors.red,
      ),
    );
  }
}