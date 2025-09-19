import 'package:flutter/material.dart';
import 'package:smart_city_garabage_collection_app/login_screen.dart';
import 'package:smart_city_garabage_collection_app/home_screen.dart';
import 'package:smart_city_garabage_collection_app/map_screen.dart';
import 'package:smart_city_garabage_collection_app/scan_screen.dart';
import 'package:smart_city_garabage_collection_app/garbage_details_screen.dart';
import 'package:smart_city_garabage_collection_app/more_screen.dart'; // New
import 'package:smart_city_garabage_collection_app/attendance_report_screen.dart'; // New
import 'package:smart_city_garabage_collection_app/raise_query_issue_screen.dart'; // New
import 'package:smart_city_garabage_collection_app/feedback_screen.dart'; // New
import 'package:smart_city_garabage_collection_app/contact_technical_support_screen.dart'; // New

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garbage Tracker App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/map': (context) => const MapScreen(),
        '/scan': (context) => const ScanScreen(),
        '/details': (context) =>
            const GarbageDetailsScreen(details: 'No details provided'),
        '/more': (context) => const MoreScreen(), // New
        '/attendance_report': (context) =>
            const AttendanceReportScreen(), // New
        '/raise_query_issue': (context) => const RaiseQueryIssueScreen(), // New
        '/feedback': (context) => const FeedbackScreen(), // New
        '/contact_technical_support': (context) =>
            const ContactTechnicalSupportScreen(), // New
      },
    );
  }
}
