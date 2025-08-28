import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/repository/task_repository.dart';
import 'base_task_view_model.dart';

final class EditTaskViewModel extends BaseTaskViewModel {
  final TaskRepository _taskRepository;
  Task? _task;

  EditTaskViewModel(this._taskRepository);

  Task? get task => _task;

  void setTask(Task? task) {
    _task = task;
    if (task != null) {
      // Formu doldur
      setCategory(task.category ?? "Varsayılan");
      setPriority(task.priority ?? "Düşük");
      setDate(task.lastDate != null ? DateTime.tryParse(task.lastDate!) : null);
    }
  }

  Future<bool> editTask(Task updatedTask) async {
    return await runWithLoading(() async {
      await _taskRepository.editTask(updatedTask);
      return true;
    });
  }
}
