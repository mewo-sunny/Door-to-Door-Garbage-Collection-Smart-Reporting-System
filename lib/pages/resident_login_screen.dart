import 'package:flutter/material.dart';
import 'package:smart_city_garabage_collection_app/pages/home_resident_screen.dart';

class ResidentLoginScreen extends StatefulWidget {
  const ResidentLoginScreen({super.key});

  @override
  State<ResidentLoginScreen> createState() => _ResidentLoginScreenState();
}

class _ResidentLoginScreenState extends State<ResidentLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    // In a real application, you would perform authentication here (e.g., API call, database check).
    // For this example, we'll simply check if the fields are not empty.
    if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      // Navigate to the resident home screen after successful login.
      // pushReplacement is used to prevent the user from navigating back to the login screen.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeResidentScreen(),
        ),
      );
    } else {
      // Show an error message if the fields are empty.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a username and password.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resident Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Sign in to your household account',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 32),
            // Username field
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Username',
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            // Password field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24),
            // Login button
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
