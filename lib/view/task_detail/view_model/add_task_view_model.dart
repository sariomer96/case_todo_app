import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/repository/task_repository.dart';
import 'base_task_view_model.dart';

final class AddTaskViewModel extends BaseTaskViewModel {
  final TaskRepository _taskRepository;

  AddTaskViewModel(this._taskRepository);

  Future<bool> addTask(Task task) async {
    return await runWithLoading(() async {
      await _taskRepository.addTask(task);

      return true;
    });
  }
}
