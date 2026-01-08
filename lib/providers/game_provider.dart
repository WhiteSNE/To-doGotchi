import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';

class GameProvider extends ChangeNotifier {
  // --- State Variables ---
  double _health = 100.0;
  double _productive = 0.0;
  int _level = 1;
  List<Task> _tasks = [];

  // Getters
  double get health => _health;
  double get productive => _productive;
  int get level => _level;
  List<Task> get tasks => _tasks;

  // --- Methods ---

  /// Memuat data dari database saat aplikasi dijalankan
  Future<void> loadData() async {
    final dbTasks = await DatabaseService.instance.getAllTasks();
    final stats = await DatabaseService.instance.getPetStats();

    _tasks = dbTasks;
    _health = (stats['health'] as num).toDouble();
    _productive = (stats['productive'] as num).toDouble();
    _level = (stats['level'] as int? ?? 1);

    await checkOverdueTasks();
    notifyListeners();
  }

  /// Menambah tugas baru ke list dan database
  Future<void> addTask(String title, DateTime deadline) async {
    final newTask = Task(
      title: title, 
      deadline: deadline,
      isCompleted: false,
      healthDeducted: false,
    );

    final id = await DatabaseService.instance.addTask(newTask);
    newTask.id = id;
    
    _tasks.add(newTask);
    notifyListeners();
  }

  /// Menandai tugas selesai dengan logika Level Up
  Future<void> completeTask(int index) async {
    if (!_tasks[index].isCompleted) {
      _tasks[index].isCompleted = true;
      
      // Tambah poin produktivitas
      _productive += 25; 

      // Logika Level Up: Jika poin mencapai atau lebih dari 100
      if (_productive >= 100) {
        _level++;
        _productive = 0; // Reset bar ke nol
        _health = 100.0; // Heal pet sampai penuh
      }

      await DatabaseService.instance.updateTask(_tasks[index]);
      await _saveStats();
      
      notifyListeners();
    }
  }

  /// Mengecek apakah ada tugas yang melewati deadline H+1
  Future<void> checkOverdueTasks() async {
    final now = DateTime.now();
    bool hasChanges = false;

    for (var task in _tasks) {
      final oneDayAfterDeadline = task.deadline.add(const Duration(days: 1));
      
      if (!task.isCompleted && now.isAfter(oneDayAfterDeadline) && !task.healthDeducted) {
        _health -= 20; 
        task.healthDeducted = true; 
        
        await DatabaseService.instance.updateTask(task);
        hasChanges = true;
      }
    }

    if (_health < 0) _health = 0;

    if (hasChanges) {
      await _saveStats();
      notifyListeners();
    }
  }

  /// FUNGSI REVIVE: Menghidupkan kembali pet (PENTING!)
  Future<void> revivePet() async {
    _health = 100.0;
    _productive = 0.0;
    _level = 1;
    await _saveStats();
    notifyListeners();
  }

  /// Menghapus tugas
  Future<void> removeTask(int index) async {
    final id = _tasks[index].id;
    if (id != null) {
      await DatabaseService.instance.deleteTask(id);
      _tasks.removeAt(index);
      notifyListeners();
    }
  }

  /// Fungsi internal untuk menyimpan statistik ke DB
  Future<void> _saveStats() async {
    await DatabaseService.instance.updatePetStats(_health, _productive, _level);
  }

  Future<void> debugSetHealth(double value) async {
  _health = value;
  if (_health < 0) _health = 0;
  if (_health > 100) _health = 100;
  await _saveStats();
  notifyListeners();
}

/// Fungsi Debug: Tambah EXP secara instan
Future<void> debugAddProductive(double value) async {
  _productive += value;
  if (_productive >= 100) {
    _level++;
    _productive = 0;
    _health = 100;
  }
  await _saveStats();
  notifyListeners();
}

/// Fungsi Debug: Hapus semua tugas (Reset Database)
Future<void> debugClearAllTasks() async {
  for (var task in _tasks) {
    if (task.id != null) {
      await DatabaseService.instance.deleteTask(task.id!);
    }
  }
  _tasks.clear();
  notifyListeners();
}
}