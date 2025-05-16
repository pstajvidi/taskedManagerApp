import 'package:flutter/material.dart';
import '../main.dart';
import '../services/auth_service.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLogin = true; // Toggle between login and signup

  LoginPage({super.key});

  Future<void> _authAction(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password.')),
      );
      return;
    }

    final result = isLogin
        ? await AuthService.signIn(email, password)
        : await AuthService.signUp(email, password);

    if (result.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScaffold(username: email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.error ?? 'Authentication failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLogin ? 'Welcome Back!' : 'Create Account',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _authAction(context),
              child: Text(isLogin ? 'Login' : 'Sign Up'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                isLogin = !isLogin;
                (context as Element).markNeedsBuild();
              },
              child: Text(
                isLogin
                    ? 'Need an account? Sign Up'
                    : 'Already have an account? Login',
              ),
            ),
          ],
        ),
      ),
    );
  }
}