
import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/data/Sqlite/db_manager.dart';

class TaskRepository {
   final _db = DbManager.instance;

   Future<List<Task>> getAllTasks() async {
    return await _db.getAllTask();
  }
 
  Future<int> addTask(Task task) async {
  
    return await _db.addTask(task);
  }

  Future<int> editTask(Task task) async {
    return await _db.editTask(task);
  }

  Future<int> removeTask(int id) async {
    return await _db.removeTask(id);
  }

  Future<List<Task>> getTasksByCategory(String category) async { 
    return await _db.getbyCategory(category);
  }

Future<List<Task>> getTasksByPriority(String priority) async { 
    return await _db.getbyPriority(priority);
  }

}