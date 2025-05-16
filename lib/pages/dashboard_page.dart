
import 'package:flutter/material.dart';
import '../pages/ptimer_page.dart';
import '../models/task_model.dart';

class DashboardPage extends StatelessWidget {
  final List<Task> tasks;

  const DashboardPage({
    super.key,
    required this.tasks,
  });

  int _getCountByStatus(String status) {
    return tasks.where((task) => task.status == status).length;
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              children: [
                SummaryCard(
                  title: "In Progress", 
                  count: _getCountByStatus('In Progress'), 
                  color: Colors.blue
                ),
                SummaryCard(
                  title: "In Review", 
                  count: _getCountByStatus('In Review'), 
                  color: Colors.purple
                ),
                SummaryCard(
                  title: "On Hold", 
                  count: _getCountByStatus('On Hold'), 
                  color: Colors.orange
                ),
                SummaryCard(
                  title: "Completed", 
                  count: _getCountByStatus('Completed'), 
                  color: Colors.green
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PomodoroTimerPage(),
                  ),
                );
              },
              icon: const Icon(Icons.timer),
              label: const Text('Start Pomodoro Timer'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const SummaryCard({super.key, required this.title, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            Text('$count', style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
