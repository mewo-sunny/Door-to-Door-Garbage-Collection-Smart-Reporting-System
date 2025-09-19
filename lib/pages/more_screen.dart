// more_screen.dart
import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          _buildListItem(context, Icons.bar_chart, 'Attendance Report', '/attendance_report'),
          _buildListItem(context, Icons.help_outline, 'Raise Query/Issue', '/raise_query_issue'),
          _buildListItem(context, Icons.feedback_outlined, 'Feedback', '/feedback'),
          _buildListItem(context, Icons.support_agent, 'Contact Technical Support', '/contact_technical_support'),
          // Potentially other items like "Logout"
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle emergency logic
              },
              icon: const Icon(Icons.emergency),
              label: const Text('SOS EMERGENCY'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, IconData icon, String title, String routeName) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700]),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
      ),
    );
  }
}