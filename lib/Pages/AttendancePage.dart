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

    if (widget.user.lastAttendanceTime != null) {
      Duration difference = DateTime.now().difference(
        widget.user.lastAttendanceTime!,
      );

      if (difference.inHours >= 24) {
        widget.user.isPresent = false;
        widget.user.lastAttendanceTime = null;
        canSubmitMorning = true;
        canSubmitEvening = true;
      } else {
        DateTime lastTime = widget.user.lastAttendanceTime!;

        if (lastTime.hour >= 4 && lastTime.hour <= 7) {
          canSubmitMorning = false;
        }
        if (lastTime.hour >= 13 && lastTime.hour <= 15) {
          canSubmitEvening = false;
        }
      }
    }
  }

  bool isInTimeWindow(DateTime currentTime, {required bool isMorning}) {
    if (isMorning) {
      return currentTime.hour >= 4 && currentTime.hour <= 7;
    } else {
      return currentTime.hour >= 13 && currentTime.hour <= 15;
    }
  }

  void submitAttendance() {
    if (selectedAttendance != null) {
      setState(() {
        widget.user.isPresent = selectedAttendance!.contains('Present');
        widget.user.lastAttendanceTime = DateTime.now();
      });

      // Decrease gender-specific seat availability only if marked present
      if (widget.user.isPresent) {
        if (widget.user.gender.toLowerCase() == "male" &&
            globals.availableMaleSeats > 0) {
          globals.availableMaleSeats--;
        } else if (widget.user.gender.toLowerCase() == "female" &&
            globals.availableFemaleSeats > 0) {
          globals.availableFemaleSeats--;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance marked as $selectedAttendance')),
      );

      DateTime now = DateTime.now();
      if (now.hour >= 4 && now.hour <= 7) {
        canSubmitMorning = false;
      } else if (now.hour >= 13 && now.hour <= 15) {
        canSubmitEvening = false;
      }

      Future.delayed(Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SeatAvailabilityPage()),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Present or Absent')),
      );
    }
  }

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
          boxShadow: const [
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
        title: const Text('Mark Attendance'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              widget.user.name,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            if (isMorningTime && canSubmitMorning) ...[
              buildAttendanceOption(
                'Present (Morning)',
                Colors.green,
                Icons.check_circle_outline,
              ),
              buildAttendanceOption(
                'Absent (Morning)',
                Colors.red,
                Icons.cancel_outlined,
              ),
            ],
            if (isEveningTime && canSubmitEvening) ...[
              buildAttendanceOption(
                'Present (Evening)',
                Colors.green,
                Icons.check_circle_outline,
              ),
              buildAttendanceOption(
                'Absent (Evening)',
                Colors.red,
                Icons.cancel_outlined,
              ),
            ],

            const Spacer(),

            if ((isMorningTime && canSubmitMorning) ||
                (isEveningTime && canSubmitEvening))
              ElevatedButton(
                onPressed: submitAttendance,
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
