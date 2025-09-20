// lib/intro_page.dart

import 'dart:ui'; // Required for the blur effect
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Imports for the different login screens
import 'package:smart_city_garbage_collection_app/pages/login/supervisor/login_screen.dart';
import 'package:smart_city_garbage_collection_app/pages/login/user/resident_login_screen.dart';
import 'package:smart_city_garbage_collection_app/pages/login/staff/staff_login_screen.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
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
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // app name
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Smart Garbage Collector",
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // centered image
                  Center(
                    child: Image.asset(
                      'lib/images/trash-collector.png', // Ensure this file exists
                      height: 150,
                    ),
                  ),

                  // frosted glass container for login section
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
                          children: [
                            Text(
                              "Login As?",
                              style: GoogleFonts.dmSerifDisplay(
                                fontSize: 32,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ResidentLoginScreen(),
                                    ),
                                  );
                                },
                                style: _buttonStyle(),
                                child: const Text("Household"),
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                style: _buttonStyle(),
                                child: const Text("Supervisor"),
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const StaffLoginScreen(),
                                    ),
                                  );
                                },
                                style: _buttonStyle(),
                                child: const Text("Staff"),
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
      padding: const EdgeInsets.symmetric(vertical: 15),
    );
  }
}

