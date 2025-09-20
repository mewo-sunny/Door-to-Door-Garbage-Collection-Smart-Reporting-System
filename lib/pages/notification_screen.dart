import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This is a static example. In a real app, notifications would be fetched dynamically.
    final List<Map<String, String>> notifications = [
      {'title': 'Schedule Update', 'body': 'The collection schedule for tomorrow has been updated. Check the app for details.', 'date': '5 min ago'},
      {'title': 'Receipt Ready', 'body': 'Your latest garbage collection receipt is now available for download.', 'date': '2 hours ago'},
      {'title': 'Special E-Waste Drive', 'body': 'This Saturday there will be a special e-waste collection drive in your area.', 'date': '1 day ago'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const Icon(Icons.notifications_active, color: Colors.amber),
              title: Text(notification['title']!),
              subtitle: Text('${notification['body']}\n\n${notification['date']}'),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
