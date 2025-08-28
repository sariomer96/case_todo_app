
import 'package:flutter/material.dart';
import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/repository/task_repository.dart';

final class TaskFormViewModel extends ChangeNotifier {
    final TaskRepository _taskRepository;
    
  bool isLoading = false;
  TaskFormViewModel(this._taskRepository);
   Task? _task;
  Task? get task => _task;

  void setTask(Task? task) {
    _task = task;
    notifyListeners();
  }
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
   Future<bool> editTask(Task task) async {
     try {
      isLoading = true;
      notifyListeners();

      await _taskRepository.editTask(task);
             
      return true; 
    } catch (e) {
      print("edit task error: $e");
      return false;  
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

   Task createModel( String taskName, String taskComment,String lastDate, String priority, String category ) { 
       return Task(taskName: taskName, taskComment: taskComment, lastDate: lastDate, priority: priority, category: category);
   }
}