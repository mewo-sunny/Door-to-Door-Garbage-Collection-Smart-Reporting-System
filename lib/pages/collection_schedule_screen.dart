import 'package:flutter/material.dart';

class CollectionScheduleScreen extends StatelessWidget {
  const CollectionScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This is a static example. In a real app, this data would come from an API.
    final Map<String, List<String>> schedule = {
      'Monday': ['Organic Waste'],
      'Tuesday': ['Recyclable Waste'],
      'Wednesday': ['Organic Waste', 'E-Waste'],
      'Thursday': ['Recyclable Waste'],
      'Friday': ['Organic Waste'],
      'Saturday': ['Special Collection'],
      'Sunday': ['No Collection'],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection Schedule'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: schedule.entries.map((entry) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(
                entry.key,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(entry.value.join(', ')),
              leading: const Icon(Icons.schedule, color: Colors.blueGrey),
            ),
          );
        }).toList(),
      ),
    );
  }
}
