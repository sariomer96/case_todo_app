
import 'package:path/path.dart';
import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

final class DbManager { 
 
  static final DbManager instance = DbManager._init();
  
  static Database? _database;
    DbManager._init(); 

    Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db',1);
    return _database!;
  }

     Future _createDB(Database db,int version) async {

      try {
        await db.execute('''
              CREATE TABLE tasks(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                task_name TEXT NOT NULL,
                task_comment TEXT  NULL,
                last_date TEXT  NULL,
                priority TEXT NOT NULL,
                category TEXT NOT NULL,
                is_finished INTEGER NOT NULL
              )
            ''');
      } catch(e) {
        print('Create db error $e');
      }
   
  } 
    Future<Database> _initDB(String filePath, int version ) async {
      try {
        final dbPath = await getDatabasesPath();
        final path = join(dbPath, filePath);

        return await openDatabase(
          path,
          version: version,
          onCreate: _createDB,
        );
      } catch (e) {
        print("initDB error: $e");
        rethrow;
      }
    }

    Future<int> addTask(Task task) async {
      try {
        final db = await instance.database;
        print(db.database);
        return await db.insert('tasks', task.toMap());
      } catch (e) {
        print("add task error: $e");
        return -1;  
      }
    }

  Future<int> editTask(Task task) async {
    try {
        final db = await instance.database;
       return await db.update(
          'tasks',
           task.toMap(),         
           where: 'id = ?',
           whereArgs: [task.id],
        
        );
    } catch(e) {
       print("edit task error: $e");
       return -1;
    }
  }

  Future<int> removeTask(int id) async { 
    try {
        final db = await instance.database;
       return await db.delete(
          'tasks',
           where: 'id = ?',
           whereArgs: [id],
        
        );
    } catch(e) {
       print("delete task error: $e");
       return -1;
    }
  }
 
 Future<List<Task>> getAllTask() async{ 
          try {
      final db = await instance.database;
      final result = await db.query('tasks', orderBy: 'id DESC');
      return result.map((json) => Task.fromMap(json)).toList();
    } catch (e) {
      print("getAllTasks error: $e");
      return [];
    }
 }

  Future<List<Task>> getbyCategory(String category) async{ 
          try {
      final db = await instance.database;
      final result = await db.query(
        'tasks',
         orderBy: 'id DESC',
         where: 'category = ?',
         whereArgs: [category],
         );
      return result.map((json) => Task.fromMap(json)).toList();
    } catch (e) {
      print("getByCategory error: $e");
      return [];
    } 
 } 
Future<List<Task>> getbyCategoryWithPriority({String? category, String? priority}) async {
  try {
    final db = await instance.database;
    String whereClause = '';
    List<String> whereArgs = [];
 
    if (category != null && category.isNotEmpty) {
      whereClause += 'category = ?';
      whereArgs.add(category);
    }

    if (priority != null && priority.isNotEmpty) {
      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      whereClause += 'priority = ?';
      whereArgs.add(priority);
    }
 
    if (whereClause.isEmpty) {
      final result = await db.query('tasks', orderBy: 'id DESC');
      return result.map((json) => Task.fromMap(json)).toList();
    } else {
      final result = await db.query(
        'tasks',
        orderBy: 'id DESC',
        where: whereClause,
        whereArgs: whereArgs,
      );
      return result.map((json) => Task.fromMap(json)).toList();
    }
  } catch (e) {
    print("getTasksByFilter error: $e");
    return [];
  }
}
  Future<List<Task>> getbyPriority(String priority) async{ 
          try {
      final db = await instance.database;
      final result = await db.query(
        'tasks',
         orderBy: 'id DESC',
         where: 'priority = ?',
         whereArgs: [priority],
         );
      return result.map((json) => Task.fromMap(json)).toList();
    } catch (e) {
      print("getAllTasks error: $e");
      return [];
    } 
 }
 Future close() async {
    final db = await instance.database;
    db.close();
  }
}


