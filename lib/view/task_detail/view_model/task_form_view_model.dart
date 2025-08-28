import 'package:flutter/material.dart';
import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/repository/task_repository.dart';

 class TaskFormViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;

  bool isLoading = false;
  Task? _task;
  Task? get task => _task;

  String? _selectedCategory;
  String? _selectedPriority;
  DateTime? _selectedDate;
  DateTime? _tempSelectedDate;  

  String? get selectedCategory => _selectedCategory;
  String? get selectedPriority => _selectedPriority;
  DateTime? get selectedDate => _selectedDate;
  DateTime? get tempSelectedDate => _tempSelectedDate;

  TaskFormViewModel(this._taskRepository);

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

  void setTempDate(DateTime? date) {
    _tempSelectedDate = date;
    notifyListeners();
  }

  void confirmDate() {
    _selectedDate = _tempSelectedDate;
    _tempSelectedDate = null;
    notifyListeners();
  }

  void cancelTempDate() {
    _tempSelectedDate = null;
    notifyListeners();
  }

  Task createModel(String taskName, String taskComment, String lastDate, String priority, String category) {
    return Task(
      taskName: taskName,
      taskComment: taskComment,
      lastDate: lastDate,
      priority: priority,
      category: category,
    );
  }
}
