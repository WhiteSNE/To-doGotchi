import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todo_gotchi.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Tabel untuk Tugas
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        deadline TEXT,
        isCompleted INTEGER,
        healthDeducted INTEGER
      )
    ''');

    await db.execute('''
    CREATE TABLE pet_stats (
      id INTEGER PRIMARY KEY,
      health REAL,
      productive REAL,
      level INTEGER
    )
  ''');
  
  // Inisialisasi awal dengan level 1
  await db.insert('pet_stats', {
    'id': 1, 
    'health': 100.0, 
    'productive': 0.0, 
    'level': 1
  });
  }

  // --- Fungsi CRUD untuk Task ---
  Future<int> addTask(Task task) async {
    final db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getAllTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');
    return result.map((json) => Task.fromMap(json)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  // --- Fungsi untuk Pet Stats ---
  Future<Map<String, dynamic>> getPetStats() async {
    final db = await instance.database;
    final result = await db.query('pet_stats', where: 'id = ?', whereArgs: [1]);
    return result.first;
  }

  // Update fungsi updatePetStats untuk menyertakan level
Future<void> updatePetStats(double health, double productive, int level) async {
  final db = await instance.database;
  await db.update(
    'pet_stats', 
    {
      'health': health, 
      'productive': productive, 
      'level': level
    }, 
    where: 'id = ?', 
    whereArgs: [1]
  );
}

Future<int> deleteTask(int id) async {
  final db = await instance.database;
  return await db.delete(
    'tasks', 
    where: 'id = ?', 
    whereArgs: [id],
  );
}
}