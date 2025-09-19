// attendance_report_screen.dart
import 'package:flutter/material.dart';
// For a real calendar, consider a package like:
// import 'package:table_calendar/table_calendar.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Report'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Calendar Placeholder ---
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_left),
                        onPressed: () {
                          setState(() {
                            _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
                          });
                        },
                      ),
                      Text(
                        '${_focusedDay.monthName} ${_focusedDay.year}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_right),
                        onPressed: () {
                          setState(() {
                            _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
                          });
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  // Weekday headers
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Sun'), Text('Mon'), Text('Tue'), Text('Wed'),
                      Text('Thu'), Text('Fri'), Text('Sat'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Days of the month (simplified grid)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: 30, // Example: for a month
                    itemBuilder: (context, index) {
                      final day = index + 1; // Simple day numbering
                      bool isToday = day == DateTime.now().day &&
                                     _focusedDay.month == DateTime.now().month &&
                                     _focusedDay.year == DateTime.now().year;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDay = DateTime(_focusedDay.year, _focusedDay.month, day);
                          });
                          // Handle day selection
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Selected: Day $day')),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isToday ? Colors.green.shade100 : Colors.transparent,
                            border: Border.all(color: _selectedDay?.day == day &&
                                                           _selectedDay?.month == _focusedDay.month &&
                                                           _selectedDay?.year == _focusedDay.year
                                ? Colors.green
                                : Colors.transparent, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$day',
                            style: TextStyle(
                              color: isToday ? Colors.green.shade800 : Colors.black,
                              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // --- End Calendar Placeholder ---
            const SizedBox(height: 20),
            const Text(
              'Download Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: 'From: DD/MM/YYYY',
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      // Show date picker for 'From' date
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      // Update state with selected date
                      if (selectedDate != null) {
                        // For demonstration:
                        print('From Date: ${selectedDate.toLocal().toString().split(' ')[0]}');
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: 'To: DD/MM/YYYY',
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      // Show date picker for 'To' date
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      // Update state with selected date
                      if (selectedDate != null) {
                        // For demonstration:
                        print('To Date: ${selectedDate.toLocal().toString().split(' ')[0]}');
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle report download
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading Report...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Download'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension to get month name (for calendar placeholder)
extension DateTimeExtension on DateTime {
  String get monthName {
    const List<String> monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }
}