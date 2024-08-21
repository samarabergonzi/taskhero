// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_hero/preferences_service.dart';
import 'package:task_hero/task_provider.dart';
import 'task_provider.dart';
import 'preferences_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PreferencesService _preferencesService = PreferencesService();
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    bool isDarkMode = await _preferencesService.getUserPreference();
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      _preferencesService.saveUserPreference(_isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
        home: TaskScreen(toggleTheme: _toggleTheme),
      ),
    );
  }
}

class TaskScreen extends StatelessWidget {
  final VoidCallback toggleTheme;

  TaskScreen({required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Task List"),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: taskProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  trailing: Icon(
                    task.completed ? Icons.check_circle : Icons.circle,
                    color: task.completed ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => taskProvider.fetchTasks(),
        child: Icon(Icons.refresh),
      ),
    );
  }
}