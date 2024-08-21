// lib/providers/task_provider.dart
import 'package:flutter/material.dart';
import 'task.dart';
import 'api_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  final ApiService _apiService = ApiService();

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();
    _tasks = await _apiService.fetchTasks();
    _isLoading = false;
    notifyListeners();
  }
}