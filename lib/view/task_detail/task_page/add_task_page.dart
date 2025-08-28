 

import 'package:flutter/material.dart';
import 'package:spexco_todo_app/view/home/view_model/home_view_model.dart';
import 'package:spexco_todo_app/view/task_detail/base/base_task_form_page.dart';
import 'package:spexco_todo_app/view/task_detail/view_model/task_form_view_model.dart';

class AddTaskPage extends BaseTaskFormPage {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends BaseTaskFormPageState<AddTaskPage> {
  @override
  String get buttonText => 'Oluştur';

 @override
Future<bool> onButtonPressed(
    TaskFormViewModel taskViewModel,
    HomeViewModel homeViewModel) async {
  var newTask = createTaskModel(taskViewModel);
  return await taskViewModel.addTask(newTask);
}


  @override
void onSuccess() {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Başarıyla oluşturuldu"),
      backgroundColor: Colors.green,
    ),
  );
}

@override
void onError() {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Oluşturma sırasında hata oluştu"),
      backgroundColor: Colors.red,
    ),
  );
}

}