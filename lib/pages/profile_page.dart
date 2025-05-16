import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart'; // Import your login page

class ProfilePage extends StatelessWidget {
  final String username;

  const ProfilePage({super.key, required this.username});

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to login page using the actual class
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue[100],
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              username,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (user?.email != null)
              Text(
                user!.email!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(user?.email ?? 'Not available'),
            ),
            ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text('Verification'),
              subtitle: Text(
                user?.emailVerified ?? false
                    ? 'Verified'
                    : 'Not verified',
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _signOut(context),
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}