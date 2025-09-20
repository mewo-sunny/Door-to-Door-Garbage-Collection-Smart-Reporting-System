import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For photo upload
import 'package:geolocator/geolocator.dart'; // For GPS location
import 'dart:io';

class IssueReportingScreen extends StatefulWidget {
  const IssueReportingScreen({super.key});

  @override
  State<IssueReportingScreen> createState() => _IssueReportingScreenState();
}

class _IssueReportingScreenState extends State<IssueReportingScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;
  Position? _currentPosition;
  final ImagePicker _picker = ImagePicker();
  bool _isLoadingLocation = false;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled. Please enable them.')),
      );
      setState(() {
        _isLoadingLocation = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')),
      );
      setState(() {
        _isLoadingLocation = false;
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      _isLoadingLocation = false;
    });
  }

  void _submitReport() {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe the issue.')),
      );
      return;
    }
    
    // In a real app, you would send this data to your backend.
    // The data would include:
    // - _descriptionController.text
    // - _image (if not null)
    // - _currentPosition (if not null)
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Issue reported! Location: ${_currentPosition?.latitude}, ${_currentPosition?.longitude}')),
    );
    
    _descriptionController.clear();
    setState(() {
      _image = null;
      _currentPosition = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report an Issue'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Describe the issue:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'e.g., "Overflowing bin at Main Street park."',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: _image == null
                  ? OutlinedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Add Photo'),
                      onPressed: _pickImage,
                    )
                  : Image.file(_image!, height: 150),
            ),
            const SizedBox(height: 20),
            Center(
              child: _currentPosition == null
                  ? ElevatedButton.icon(
                      icon: _isLoadingLocation
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Icon(Icons.location_on),
                      label: const Text('Get My Location'),
                      onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                    )
                  : Text('Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}'),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _submitReport,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Submit Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
