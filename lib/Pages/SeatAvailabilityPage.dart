import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class SeatAvailabilityPage extends StatefulWidget {
  const SeatAvailabilityPage({Key? key}) : super(key: key);

  @override
  _SeatAvailabilityPageState createState() => _SeatAvailabilityPageState();
}

class _SeatAvailabilityPageState extends State<SeatAvailabilityPage> {
  // Seat layout (true = seat, false = aisle)
  final List<List<bool>> seatLayout = [
    [true, true, false, true, true],
    [true, true, false, true, true],
    [true, true, false, true, true],
    [true, true, false, true, true],
    [true, true, false, true, true],
    [true, true, false, true, true],
  ];

  // Track which seats are booked
  final List<List<bool>> bookedSeats = List.generate(
    6,
    (_) => List.generate(5, (_) => false),
  );

  @override
  void initState() {
    super.initState();

    // Pre-book seats based on attendance
    int totalSeats = seatLayout.fold(
      0,
      (sum, row) => sum + row.where((seat) => seat).length,
    );
    int seatsToBook = totalSeats - globals.availableSeats;

    outerLoop:
    for (int i = 0; i < seatLayout.length; i++) {
      for (int j = 0; j < seatLayout[i].length; j++) {
        if (seatLayout[i][j]) {
          if (seatsToBook > 0) {
            bookedSeats[i][j] = true; // Mark seat as booked (present)
            seatsToBook--;
          } else {
            break outerLoop;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalSeats = seatLayout.fold(
      0,
      (sum, row) => sum + row.where((seat) => seat).length,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Seat Availability'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              'Available Seats: ${globals.availableSeats} / $totalSeats',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: seatLayout.length * 5,
                  itemBuilder: (context, index) {
                    int row = index ~/ 5;
                    int col = index % 5;

                    if (row >= seatLayout.length ||
                        col >= seatLayout[row].length) {
                      return const SizedBox();
                    }

                    bool isSeat = seatLayout[row][col];

                    if (!isSeat) {
                      return const SizedBox(); // Aisle
                    }

                    bool isBooked = bookedSeats[row][col];
                    Color seatColor =
                        isBooked
                            ? Colors
                                .red // Booked (Present)
                            : Colors.green; // Available (Absent)

                    return Container(
                      decoration: BoxDecoration(
                        color: seatColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Icon(
                        Icons.event_seat,
                        color: Colors.white,
                        size: 30,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
