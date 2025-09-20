import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_city_garbage_collection_app/pages/login.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback?
  onPressed; // Add this parameter

  const MyButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onPressed ??
          () {
            // Default action if onPressed is not provided
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const LoginPage(),
              ),
            );
          },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 25,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
