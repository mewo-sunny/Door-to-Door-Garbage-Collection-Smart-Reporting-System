import 'package:flutter/material.dart';

class MoreStaffScreen extends StatelessWidget {
  const MoreStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'More Options',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Future functionality for exception logging
              },
              child: const Text('Log an Exception'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Future functionality for offline job queue
              },
              child: const Text('View Offline Jobs'),
            ),
          ],
        ),
      ),
    );
  }
}
