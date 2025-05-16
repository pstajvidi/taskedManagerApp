import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import 'task_details_page.dart';
import 'add_edit_task_page.dart';
import '../widgets/task_card.dart';

class TaskListPage extends StatefulWidget {
  final List<Task> tasks;
  const TaskListPage({super.key, required this.tasks});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final TaskService _taskService = TaskService();
  String? _userId;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> addOrEditTask([Task? existingTask, int? index]) async {
    final result = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskPage(task: existingTask),
      ),
    );

    if (result != null && _userId != null) {
      if (existingTask != null && existingTask.id != null) {
        // Update existing task
        await _taskService.updateTask(_userId!, existingTask.id!, result);
      } else {
        // Add new task
        await _taskService.addTask(_userId!, result);
      }
    }
  }

  Future<void> deleteTask(String taskId) async {
    if (_userId != null) {
      await _taskService.deleteTask(_userId!, taskId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tasks")),
      body: ListView.builder(
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          final task = widget.tasks[index];
          return Dismissible(
            key: Key(task.id ?? '${task.title}$index'),
            background: Container(color: Colors.red),
            onDismissed: (direction) => deleteTask(task.id!),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetailsPage(
                      task: task,
                      onTaskUpdated: (updatedTask) {
                        if (_userId != null && task.id != null) {
                          _taskService.updateTask(_userId!, task.id!, updatedTask);
                        }
                      },
                    ),
                  ),
                );
              },
              child: TaskCard(
                task: task,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailsPage(
                        task: task,
                        onTaskUpdated: (updatedTask) {
                          if (_userId != null && task.id != null) {
                            _taskService.updateTask(_userId!, task.id!, updatedTask);
                          }
                        },
                      ),
                    ),
                  );
                },
                onEdit: () => addOrEditTask(task, index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addOrEditTask(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
