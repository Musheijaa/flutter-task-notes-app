import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_notes_manager/models/task_item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        priority TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL DEFAULT 0
      )
    ''');
    
    // Insert sample data
    await db.insert('tasks', {'title': 'Complete Flutter assignment', 'priority': 'High', 'description': 'Implement task manager app', 'isCompleted': 0});
    await db.insert('tasks', {'title': 'Buy groceries', 'priority': 'Low', 'description': 'Milk, bread, fruits', 'isCompleted': 1});
    await db.insert('tasks', {'title': 'Plan weekend activities', 'priority': 'Medium', 'description': 'Research local events', 'isCompleted': 0});
  }

  Future<int> insertTask(TaskItem task) async {
    final db = await database;
    final taskMap = task.toJson();
    taskMap.remove('id'); // Remove id to let SQLite auto-generate
    return await db.insert('tasks', taskMap);
  }

  Future<List<TaskItem>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks', orderBy: 'id DESC');
    return maps.map((map) => TaskItem.fromJson(map)).toList();
  }

  Future<int> updateTask(TaskItem task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}