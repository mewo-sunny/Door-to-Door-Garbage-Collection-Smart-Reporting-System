import 'package:flutter/material.dart';

class GarbageDetailsScreen extends StatelessWidget {
  final String details;

  const GarbageDetailsScreen({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Garbage Details')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.delete_forever, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                'Scanned Details:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                details,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
