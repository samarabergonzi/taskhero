// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'task.dart';

class ApiService {
  final String apiUrl = "https://jsonplaceholder.typicode.com/todos";

  Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Task> tasks = body.map((dynamic item) => Task.fromJson(item)).toList();
      return tasks;
    } else {
      throw Exception("Failed to load tasks");
    }
  }
}