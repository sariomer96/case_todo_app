
import 'package:flutter/material.dart';
import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/repository/task_repository.dart';

final class TaskFormViewModel extends ChangeNotifier {
    final TaskRepository _taskRepository;
  bool isLoading = false;
  TaskFormViewModel(this._taskRepository);
  
   Future<bool> addTask(Task task) async {
     try {
      isLoading = true;
      notifyListeners();

      await _taskRepository.addTask(task);
            

      return true; 
    } catch (e) {
      print("addTask error: $e");
      return false;  
    } finally {
      isLoading = false;
      notifyListeners();
    }
 
  } 
   Future<void> editTask(Task task) async {
    await _taskRepository.editTask(task);
  }

   Task createModel( String taskName, String taskComment,String lastDate, String priority, String category ) { 
       return Task(taskName: taskName, taskComment: taskComment, lastDate: lastDate, priority: priority, category: category);
   }
}