import 'package:flutter/material.dart';
import 'package:smart_city_garabage_collection_app/pages/home_screen.dart';
import 'package:smart_city_garabage_collection_app/pages/map_screen.dart';
import 'package:smart_city_garabage_collection_app/pages/scan_screen.dart';
import 'package:smart_city_garabage_collection_app/pages/garbage_details_screen.dart';
import 'package:smart_city_garabage_collection_app/pages/more_screen.dart'; // New
import 'package:smart_city_garabage_collection_app/pages/attendance_report_screen.dart'; // New
import 'package:smart_city_garabage_collection_app/pages/raise_query_issue_screen.dart'; // New
import 'package:smart_city_garabage_collection_app/pages/feedback_screen.dart'; // New
import 'package:smart_city_garabage_collection_app/pages/contact_technical_support_screen.dart'; // New
import 'package:smart_city_garabage_collection_app/Pages/intro_page.dart';

// Resident Imports
import 'package:smart_city_garabage_collection_app/pages/home_resident_screen.dart';
import 'package:smart_city_garabage_collection_app/pages/issue_reporting_screen.dart';
import 'package:smart_city_garabage_collection_app/pages/collection_schedule_screen.dart';
import 'package:smart_city_garabage_collection_app/pages/segregation_guide_screen.dart';
import 'package:smart_city_garabage_collection_app/pages/receipts_screen.dart';
import 'package:smart_city_garabage_collection_app/pages/notification_screen.dart';


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
        // '/': (context) => const LoginScreen(),
        '/': (context) => const IntroPage(),
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
            // Resident Routes
        '/resident_home': (context) => const HomeResidentScreen(),
        '/resident_issue_report': (context) => const IssueReportingScreen(),
        '/resident_schedule': (context) => const CollectionScheduleScreen(),
        '/resident_segregation_guide': (context) =>
            const SegregationGuideScreen(),
        '/resident_receipts': (context) => const ReceiptsScreen(),
        '/resident_notifications': (context) => const NotificationScreen(),
      },
    );
  }
}
