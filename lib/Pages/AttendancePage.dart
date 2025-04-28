import 'package:flutter/material.dart';
import '../globals.dart' as globals; // Import the globals
import '../screens/user_data.dart'; // Import the UserData model
import 'SeatAvailabilityPage.dart'; // <-- Import SeatAvailabilityPage

class AttendancePage extends StatefulWidget {
  final UserData user;

  const AttendancePage({Key? key, required this.user}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String? selectedAttendance;
  bool canSubmitMorning = true;
  bool canSubmitEvening = true;

  @override
  void initState() {
    super.initState();

    // Check user's previous attendance time
    if (widget.user.lastAttendanceTime != null) {
      Duration difference = DateTime.now().difference(
        widget.user.lastAttendanceTime!,
      );

      // Check if 20 hours have passed since last attendance submission
      if (difference.inHours >= 20) {
        widget.user.isPresent = false;
        widget.user.lastAttendanceTime = null;
        canSubmitMorning = true;
        canSubmitEvening = true;
      } else {
        DateTime lastTime = widget.user.lastAttendanceTime!;

        // Check if the user has already submitted in the morning window
        if (lastTime.hour >= 4 && lastTime.hour <= 7) {
          canSubmitMorning = false;
        }

        // Check if the user has already submitted in the evening window
        if (lastTime.hour >= 13 && lastTime.hour <= 20) {
          canSubmitEvening = false;
        }
      }
    }
  }

  // Check if the current time is within the allowed morning and evening window
  bool isInTimeWindow(DateTime currentTime, {required bool isMorning}) {
    if (isMorning) {
      // Morning time: 4 AM - 7 AM
      return currentTime.hour >= 4 && currentTime.hour <= 7;
    } else {
      // Evening time: 1 PM - 6 PM
      return currentTime.hour >= 13 && currentTime.hour <= 20;
    }
  }

  // Submit attendance
  void submitAttendance() {
    if (selectedAttendance != null) {
      setState(() {
        widget.user.isPresent = selectedAttendance!.contains(
          'Present',
        ); // <-- Fixed
        widget.user.lastAttendanceTime = DateTime.now();
      });

      // Decrease available seats if present
      if (widget.user.isPresent && globals.availableSeats > 0) {
        globals.availableSeats--;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance marked as $selectedAttendance')),
      );

      DateTime lastTime = widget.user.lastAttendanceTime!;
      if (lastTime.hour >= 4 && lastTime.hour <= 7) {
        canSubmitMorning = false;
      } else if (lastTime.hour >= 13 && lastTime.hour <= 20) {
        canSubmitEvening = false;
      }

      // Navigate to SeatAvailabilityPage after submit
      Future.delayed(Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SeatAvailabilityPage()),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Present or Absent')),
      );
    }
  }

  // Build attendance option container
  Widget buildAttendanceOption(String title, Color color, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAttendance = title;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              selectedAttendance == title
                  ? color.withOpacity(0.9)
                  : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
              color: selectedAttendance == title ? Colors.white : color,
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: selectedAttendance == title ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    bool isMorningTime = isInTimeWindow(now, isMorning: true);
    bool isEveningTime = isInTimeWindow(now, isMorning: false);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Mark Attendance'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              '${widget.user.name}',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            if (isMorningTime && canSubmitMorning)
              buildAttendanceOption(
                'Present (Morning)',
                Colors.green,
                Icons.check_circle_outline,
              ),
            if (isMorningTime && canSubmitMorning)
              buildAttendanceOption(
                'Absent (Morning)',
                Colors.red,
                Icons.cancel_outlined,
              ),
            if (isEveningTime && canSubmitEvening)
              buildAttendanceOption(
                'Present (Evening)',
                Colors.green,
                Icons.check_circle_outline,
              ),
            if (isEveningTime && canSubmitEvening)
              buildAttendanceOption(
                'Absent (Evening)',
                Colors.red,
                Icons.cancel_outlined,
              ),

            const Spacer(),

            if ((isMorningTime && canSubmitMorning) ||
                (isEveningTime && canSubmitEvening))
              ElevatedButton(
                onPressed: () {
                  if ((isMorningTime && canSubmitMorning) ||
                      (isEveningTime && canSubmitEvening)) {
                    submitAttendance();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Not in allowed time window for submission',
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
