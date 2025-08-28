import 'package:flutter/material.dart';
import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/repository/task_repository.dart';

final class EditTaskViewModel extends ChangeNotifier {
 final TaskRepository _taskRepository;
  
  EditTaskViewModel(this._taskRepository);

  Task? get task => _task;
  bool isLoading = false;
  Task? _task;
  String? _selectedCategory;
  String? _selectedPriority;
  DateTime? _selectedDate;

   String? get selectedCategory => _selectedCategory;
  String? get selectedPriority => _selectedPriority;
  DateTime? get selectedDate => _selectedDate;
 
 
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
  
Task createModel(String taskName, String? taskComment, String? lastDate, String priority, String category) {
    return Task(
      taskName: taskName,
      taskComment: taskComment,
      lastDate: lastDate,
      priority: priority,
      category: category,
    );
  }

  void setTask(Task? task) {
    _task = task;
    notifyListeners();
  }
void setCategory(String? category) {
  _selectedCategory = category;
  notifyListeners();
}

void setPriority(String? priority) {
  _selectedPriority = priority;
  notifyListeners();
}

  void setDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }
}