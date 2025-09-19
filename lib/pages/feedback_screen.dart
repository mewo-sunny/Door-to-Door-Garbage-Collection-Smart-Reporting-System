// feedback_screen.dart
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();

  void _submitFeedback() {
    if (_feedbackController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide your feedback.')),
      );
      return;
    }
    // Implement actual submission logic here (e.g., API call)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Feedback submitted: ${_feedbackController.text}')),
    );
    _feedbackController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Describe your feedback:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _feedbackController,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Share your thoughts here...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _submitFeedback,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}