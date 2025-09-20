import 'package:flutter/material.dart';
import 'package:smart_city_garbage_collection_app/pages/issue_reporting_screen.dart';
import 'package:smart_city_garbage_collection_app/pages/collection_schedule_screen.dart';
import 'package:smart_city_garbage_collection_app/pages/segregation_guide_screen.dart';
import 'package:smart_city_garbage_collection_app/pages/notification_screen.dart';
import 'package:smart_city_garbage_collection_app/pages/garbage_details_screen.dart'; // Import the GarbageDetailsScreen

class HomeResidentScreen extends StatefulWidget {
  const HomeResidentScreen({super.key});

  @override
  State<HomeResidentScreen> createState() => _HomeResidentScreenState();
}

class _HomeResidentScreenState extends State<HomeResidentScreen> {
  int _selectedIndex = 0;

  // This list contains the screens that will be displayed in the body.
  // The number of items here MUST match the number of items in the BottomNavigationBar.
  static final List<Widget> _widgetOptions = <Widget>[
    const _DashboardScreen(),
    const IssueReportingScreen(),
    const CollectionScheduleScreen(),
    const SegregationGuideScreen(),
    const GarbageDetailsScreen(), // Replaced ReceiptsScreen with GarbageDetailsScreen
  ];

  // A list of titles for the AppBar, corresponding to each screen.
  static const List<String> _appBarTitles = <String>[
    'Dashboard',
    'Report an Issue',
    'Collection Schedule',
    'Segregation Guide',
    'Garbage Details', // Replaced "Receipts" with "Garbage Details"
  ];

  // This method updates the selected index when a bottom navigation bar item is tapped.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigates to a separate notifications screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
          ),
        ],
      ),
      // Displays the correct screen based on the selected index.
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_problem),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Guide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete), // Updated icon for Garbage Details
            label: 'Garbage Details', // Updated label
          ),
        ],
        currentIndex: _selectedIndex,
        // Updated colors to match the supervisor's home screen
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Use fixed type for more than 3 items
      ),
    );
  }
}

// A simple dashboard placeholder
class _DashboardScreen extends StatelessWidget {
  const _DashboardScreen();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, Resident!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Use the navigation bar to report issues, check schedules, or view guides.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
