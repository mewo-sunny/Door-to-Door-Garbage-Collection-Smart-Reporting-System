import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For picking images from gallery/camera
import 'dart:io'; // For the File class
import 'package:url_launcher/url_launcher.dart'; // For launching URLs, calls, etc.

class ContactTechnicalSupportScreen extends StatefulWidget {
  const ContactTechnicalSupportScreen({super.key});

  @override
  State<ContactTechnicalSupportScreen> createState() => _ContactTechnicalSupportScreenState();
}

class _ContactTechnicalSupportScreenState extends State<ContactTechnicalSupportScreen> {
  // Controller to manage the text input for the issue description
  final TextEditingController _issueController = TextEditingController();
  
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

  // Function to initiate a phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Show an error message if the phone dialer cannot be launched
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone dialer.')),
      );
    }
  }

  // Function to handle the "Connect Now" button press
  void _connectNow() {
    // Get the issue description text
    final String issueDescription = _issueController.text;

    // Show a SnackBar with the captured information
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Attempting to connect to support... Issue: "$issueDescription", Image: ${_image?.path ?? "None"}')),
    );

    // For demonstration, we'll try to initiate a phone call.
    // In a real app, this might send data to a backend or open a chat.
    _makePhoneCall('1234567890'); // Replace with the actual support number
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Technical Support'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Describe your issue (optional):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // The TextField is now controlled and non-const
            TextField(
              controller: _issueController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Briefly explain your problem...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Upload screenshot/image (if any):',
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
                onPressed: _connectNow,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Connect Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
