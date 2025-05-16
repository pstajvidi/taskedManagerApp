// models/task_model.dart
class Task {
  final String? id; // Add Firestore document ID
  final String title;
  final String priority;
  final String date;
  final List<String> tags;
  final String description;
  final String status;
  final DateTime createdAt; // Add creation timestamp

  Task({
    this.id,
    required this.title,
    required this.priority,
    required this.date,
    required this.tags,
    required this.description,
    required this.status,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'priority': priority,
      'date': date,
      'tags': tags,
      'description': description,
      'status': status,
      'createdAt': createdAt,
    };
  }

  // Create from Firestore
  factory Task.fromFirestore(Map<String, dynamic> data, String id) {
    return Task(
      id: id,
      title: data['title'] ?? '',
      priority: data['priority'] ?? 'Medium',
      date: data['date'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      description: data['description'] ?? '',
      status: data['status'] ?? 'In Progress',
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

// Copy with method remains the same
}