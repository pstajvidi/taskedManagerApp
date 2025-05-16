import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/models/task_model.dart';
import 'pages/dashboard_page.dart';
import 'pages/task_list_page.dart';
import 'pages/profile_page.dart';
import 'services/task_service.dart';
import 'widgets/bottom_nav_bar.dart';
import 'pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      home: LoginPage(),  // Open with the login page
    );
  }
}

class MainScaffold extends StatefulWidget {
  final String username;  // Accept username from login

  const MainScaffold({super.key, required this.username});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  final TaskService _taskService = TaskService();
  late Stream<List<Task>> _tasksStream;
  String? _userId;
  //final List<Task> tasks = []; // This should be your central task list
  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;
    _tasksStream = _userId != null
        ? _taskService.getTasks(_userId!)
        : Stream.value([]);
  }


  @override
  Widget build(BuildContext context) {
    final pages = [
      StreamBuilder<List<Task>>(
        stream: _tasksStream,
        builder: (context, snapshot) {
          final tasks = snapshot.data ?? [];
          return DashboardPage(tasks: tasks);
        },
      ),
      StreamBuilder<List<Task>>(
        stream: _tasksStream,
        builder: (context, snapshot) {
          final tasks = snapshot.data ?? [];
          return TaskListPage(tasks: tasks);
        },
      ),
      ProfilePage(username: widget.username),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

