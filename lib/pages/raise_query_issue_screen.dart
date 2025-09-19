// raise_query_issue_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import for image picking
import 'dart:io'; // For File

class RaiseQueryIssueScreen extends StatefulWidget {
  const RaiseQueryIssueScreen({super.key});

  @override
  State<RaiseQueryIssueScreen> createState() => _RaiseQueryIssueScreenState();
}

class _RaiseQueryIssueScreenState extends State<RaiseQueryIssueScreen> {
  final TextEditingController _queryController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitQuery() {
    if (_queryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your query/issue.')),
      );
      return;
    }
    // Implement actual submission logic here (e.g., API call)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Query submitted: ${_queryController.text}, Image: ${_image?.path ?? "None"}')),
    );
    // Clear fields after submission
    _queryController.clear();
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raise Query/Issue'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Describe your query/issue:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _queryController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Type your issue here...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Upload image (if any):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _image == null
                ? OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Choose Image'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  )
                : Column(
                    children: [
                      Image.file(_image!, height: 150),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _image = null; // Clear selected image
                          });
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Remove Image'),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                      ),
                    ],
                  ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _submitQuery,
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