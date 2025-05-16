// services/task_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Task>> getTasks(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Task.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  Future<void> addTask(String userId, Task task) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .add(task.toFirestore());
  }

  Future<void> updateTask(String userId, String taskId, Task task) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .update(task.toFirestore());
  }

  Future<void> deleteTask(String userId, String taskId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }
}