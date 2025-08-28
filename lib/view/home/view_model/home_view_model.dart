import 'package:flutter/material.dart';
import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/repository/task_repository.dart';
import 'package:spexco_todo_app/view/task_detail/base/base_task_form_page.dart';

final class HomeViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  List<Task> _allTasks = [];
  List<Task> get allTasks => _allTasks;

  String? _selectedCategory;
  String? _selectedPriority;

  String? get selectedCategory => _selectedCategory;
  String? get selectedPriority => _selectedPriority;
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

  Future<void> searchTask(String query) async {
    if (query.isEmpty) {
      _tasks = _allTasks;
    } else {
      _tasks = _allTasks
          .where((task) =>
              task.taskName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> filterByCategoryWithPriority() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _taskRepository.getTasksByCategoryWithPriority(
        _selectedCategory ?? '', _selectedPriority ?? '');

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getAllTask() async {
    try {
      _isLoading = true;
      notifyListeners();

      _tasks = await _taskRepository.getAllTasks();
      _allTasks = _tasks;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('allTask error $e');
    }
  }

  Future<void> filterByPriority(String priority) async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _taskRepository.getTasksByPriority(priority);

    _isLoading = false;
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
}
