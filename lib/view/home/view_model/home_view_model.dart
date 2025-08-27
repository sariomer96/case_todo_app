
import 'package:flutter/material.dart';
import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/repository/task_repository.dart';

final class HomeViewModel extends ChangeNotifier {

  final TaskRepository _taskRepository;
    List<Task> _tasks = [];
    List<Task> get tasks => _tasks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  HomeViewModel(this._taskRepository);

   Future<void> removeTask(int id) async {
    await _taskRepository.removeTask(id);   
  }
  
  Future<void> filterByCategory(String category) async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _taskRepository.getTasksByCategory(category);

    _isLoading = false;
    notifyListeners();
  }

   Future<void> filterByPriority(String priority) async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _taskRepository.getTasksByPriority(priority);

    _isLoading = false;
    notifyListeners();
  }
}