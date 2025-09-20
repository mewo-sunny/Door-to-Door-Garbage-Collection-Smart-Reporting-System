import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_city_garbage_collection_app/pages/home_resident_screen.dart';
import 'package:smart_city_garbage_collection_app/pages/login/user/user_registration.dart';

class ResidentLoginScreen extends StatefulWidget {
  const ResidentLoginScreen({super.key});

  @override
  State<ResidentLoginScreen> createState() => _ResidentLoginScreenState();
}

class _ResidentLoginScreenState extends State<ResidentLoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _color1 = ColorTween(
      begin: Colors.green.shade800,
      end: Colors.teal.shade700,
    ).animate(_controller);

    _color2 = ColorTween(
      begin: Colors.lightGreen.shade400,
      end: Colors.green.shade900,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeResidentScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a username and password.'),
        ),
      );
    }
  }

  void _goToRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserRegistrationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _color1.value ?? Colors.green,
                  _color2.value ?? Colors.teal,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Resident Login',
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Sign in to your household account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Username field
                            TextField(
                              controller: _usernameController,
                              style: const TextStyle(color: Colors.white),
                              decoration:
                                  _inputDecoration('Username', Icons.person),
                            ),
                            const SizedBox(height: 16),
                            // Password field
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration:
                                  _inputDecoration('Password', Icons.lock),
                            ),
                            const SizedBox(height: 24),
                            // Login button
                            ElevatedButton(
                              onPressed: _login,
                              style: _buttonStyle(),
                              child: const Text('Login'),
                            ),
                            const SizedBox(height: 16),
                            // Registration button
                            TextButton(
                              onPressed: _goToRegistration,
                              child: Text(
                                "Don't have an account? Register here",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper method for consistent TextField styling
  InputDecoration _inputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.8)),
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
    );
  }

  // Helper method for consistent button styling
  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white.withOpacity(0.2),
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withOpacity(0.4)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      minimumSize: const Size(double.infinity, 50),
    );
  }
}