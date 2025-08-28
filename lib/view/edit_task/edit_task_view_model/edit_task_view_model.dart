import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/repository/task_repository.dart';
import '../../base_task_detail/base_view_model/base_task_view_model.dart';

final class EditTaskViewModel extends BaseTaskViewModel {
  final TaskRepository _taskRepository;
  Task? _task;

  EditTaskViewModel(this._taskRepository);

  Task? get task => _task;

  void setTask(Task? task) {
    _task = task;
    if (task != null) {
      setCategory(task.category ?? "Varsayılan");
      setPriority(task.priority ?? "Düşük");
      var date = DateTime.tryParse(task.lastDate);

      if (date != null) {
        setDate(date);
      }
    }
  }

  Future<bool> editTask(Task updatedTask) async {
    return await runWithLoading(() async {
      await _taskRepository.editTask(updatedTask);
      return true;
    });
  }
}
