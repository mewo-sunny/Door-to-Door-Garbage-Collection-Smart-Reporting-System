import 'package:flutter/material.dart';
import 'package:smart_city_garbage_collection_app/pages/map_screen.dart';
import 'package:smart_city_garbage_collection_app/pages/more_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // The list of screens to be displayed.
  static const List<Widget> _widgetOptions = <Widget>[
    // The "Home" tab content
    Center(
      child: Text(
        'Welcome Home!',
        style: TextStyle(fontSize: 24, color: Colors.black54),
      ),
    ),
    // The "Map" tab content
    MapScreen(),
    // The "More" tab content
    MoreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // A list of titles for the app bar, corresponding to each tab.
  static const List<String> _appBarTitles = <String>[
    'Garbage Tracker',
    'Map View',
    'More Options',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
      ),
    );
  }
}
