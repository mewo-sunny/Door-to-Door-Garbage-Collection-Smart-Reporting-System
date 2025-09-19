// lib/home_screen.dart

import 'package:flutter/material.dart';
import 'package:smart_city_garabage_collection_app/map_screen.dart';
import 'package:smart_city_garabage_collection_app/scan_screen.dart';
import 'package:smart_city_garabage_collection_app/more_screen.dart'; // 1. Import the MoreScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // 2. Add MoreScreen to the list of available screens
  static const List<Widget> _widgetOptions = <Widget>[
    Center(
      child: Text(
        'Welcome Home!',
        style: TextStyle(fontSize: 24, color: Colors.black54),
      ),
    ),
    MapScreen(),
    ScanScreen(),
    MoreScreen(), // Added here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Optional: Update the AppBar title based on the selected screen
  static const List<String> _appBarTitles = <String>[
    'Garbage Tracker',
    'Map View',
    'Scan QR Code',
    'More Options',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]), // Title now changes
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // 3. Set type to fixed for consistent styling with 4+ items
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey[600], // Makes inactive icons visible
        onTap: _onItemTapped,
      ),
    );
  }
}
