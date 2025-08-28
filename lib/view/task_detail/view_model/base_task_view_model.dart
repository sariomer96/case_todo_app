import 'package:flutter/material.dart';
import 'package:spexco_todo_app/data/Models/task_model.dart';

abstract class BaseTaskViewModel extends ChangeNotifier {
  bool isLoading = false;

  String _selectedCategory = "Varsayılan";
  String _selectedPriority = "Düşük";
  DateTime _selectedDate = DateTime.now();

  String get selectedCategory => _selectedCategory;
  String get selectedPriority => _selectedPriority;
  DateTime get selectedDate => _selectedDate;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setPriority(String priority) {
    _selectedPriority = priority;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Task createModel(String taskName, String? taskComment, {int? id}) {
    return Task(
      id: id,
      taskName: taskName,
      taskComment: taskComment,
      lastDate: _selectedDate.toIso8601String(),
      priority: _selectedPriority,
      category: _selectedCategory,
    );
  }

  Future<T> runWithLoading<T>(Future<T> Function() action) async {
    try {
      isLoading = true;
      notifyListeners();
      return await action();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
