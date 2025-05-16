import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'add_edit_task_page.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;
  final Function(Task)? onTaskUpdated;

  const TaskDetailsPage({super.key, required this.task, this.onTaskUpdated});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late Task task;

  @override
  void initState() {
    super.initState();
    task = widget.task;
  }

  void _navigateToEditTaskPage() async {
    final editedTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskPage(task: task),
      ),
    );

    if (editedTask != null) {
      setState(() {
        task = editedTask;  // Update local task in details page

        // Notify parent (TaskListPage) about the update
        if (widget.onTaskUpdated != null) {
          widget.onTaskUpdated!(editedTask);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Priority: ${task.priority}", style: const TextStyle(fontSize: 16)),
            Text("Date: ${task.date}", style: const TextStyle(fontSize: 16)),
            Text("Description: ${task.description}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: task.tags.map((tag) => Chip(label: Text(tag))).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _navigateToEditTaskPage,
              child: const Text("Edit Task"),
            )
          ],
        ),
      ),
    );
  }
}
