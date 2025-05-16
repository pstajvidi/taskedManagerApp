import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onEdit,
  });

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.arrow_upward;
      case 'medium':
        return Icons.remove;
      case 'low':
        return Icons.arrow_downward;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Priority, Date & Tags Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(_getPriorityIcon(task.priority), color: _getPriorityColor(task.priority)),
                    const SizedBox(width: 4),
                    Text(
                      task.date,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
                Row(
                  children: task.tags.map((tag) => _buildTagChip(tag)).toList(),
                )
              ],
            ),
            const SizedBox(height: 6),
            // Title
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Assignees Row (Replace with actual avatar logic if available)
           
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    Color color = Colors.blue;
    if (tag.toLowerCase() == 'on track') color = Colors.green;
    if (tag.toLowerCase() == 'at risk') color = Colors.red;
    if (tag.toLowerCase() == 'meeting') color = Colors.orange;

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Chip(
        backgroundColor: color.withOpacity(0.4),
        label: Text(tag, style: TextStyle(color: color)),
      ),
    );
  }
}
