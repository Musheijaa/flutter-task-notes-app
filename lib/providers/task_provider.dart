import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_notes_manager/models/task_item.dart';
import 'package:task_notes_manager/database/database_helper.dart';
import 'package:task_notes_manager/constants.dart';

class TaskProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  
  List<TaskItem> _tasks = [];
  bool _isLoading = false;
  String? _error;
  bool _isDarkMode = false;

  List<TaskItem> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isDarkMode => _isDarkMode;

  int get completedTasksCount => _completedTasksCount;
  int get pendingTasksCount => _pendingTasksCount;

  int _completedTasksCount = 0;
  int _pendingTasksCount = 0;

  Future<void> initialize() async {
    try {
      await _loadThemePreference();
      await loadTasks();
    } catch (e) {
      debugPrint('${ErrorMessages.genericError}: $e');
    }
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(AppConstants.themePreferenceKey) ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('${ErrorMessages.genericError}: $e');
      _isDarkMode = false;
    }
  }

  Future<void> _saveThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.themePreferenceKey, _isDarkMode);
    } catch (e) {
      debugPrint('${ErrorMessages.genericError}: $e');
    }
  }

  Future<void> toggleTheme() async {
    try {
      _isDarkMode = !_isDarkMode;
      await _saveThemePreference();
      notifyListeners();
    } catch (e) {
      _isDarkMode = !_isDarkMode;
      debugPrint('${ErrorMessages.genericError}: $e');
      notifyListeners();
    }
  }

  Future<void> loadTasks() async {
    _setLoading(true);
    _error = null;

    try {
      _tasks = await _databaseHelper.getAllTasks();
      _updateTaskCounts();
    } catch (e) {
      _error = ErrorMessages.taskLoadError;
      debugPrint('$_error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addTask(TaskItem task) async {
    try {
      final taskId = await _databaseHelper.insertTask(task);
      final newTask = task.copyWith(id: taskId);
      _tasks.insert(0, newTask);
      _updateTaskCounts();
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = ErrorMessages.taskCreationError;
      debugPrint('$_error: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask(TaskItem task) async {
    try {
      await _databaseHelper.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        _updateTaskCounts();
      }
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = ErrorMessages.taskUpdateError;
      debugPrint('$_error: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleTaskCompletion(TaskItem task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    return await updateTask(updatedTask);
  }

  Future<bool> deleteTask(int taskId) async {
    try {
      await _databaseHelper.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      _updateTaskCounts();
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = ErrorMessages.taskDeletionError;
      debugPrint('$_error: $e');
      notifyListeners();
      return false;
    }
  }

  List<TaskItem> getTasksByStatus({required bool completed}) {
    return _tasks.where((task) => task.isCompleted == completed).toList();
  }

  List<TaskItem> getTasksByPriority(String priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  List<TaskItem> searchTasks(String query) {
    if (query.isEmpty) return _tasks;
    
    final lowercaseQuery = query.toLowerCase();
    return _tasks.where((task) {
      return task.title.toLowerCase().contains(lowercaseQuery) ||
             task.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _updateTaskCounts() {
    _completedTasksCount = _tasks.where((task) => task.isCompleted).length;
    _pendingTasksCount = _tasks.where((task) => !task.isCompleted).length;
  }

  @override
  void dispose() {
    _databaseHelper.close();
    super.dispose();
  }
}