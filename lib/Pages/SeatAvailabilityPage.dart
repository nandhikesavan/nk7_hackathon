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

  final List<List<bool>> bookedMaleSeats = List.generate(
    6,
    (_) => List.generate(5, (_) => false),
  );
  final List<List<bool>> bookedFemaleSeats = List.generate(
    6,
    (_) => List.generate(5, (_) => false),
  );

  @override
  void initState() {
    super.initState();

    int totalMaleSeats = 6 * 2; // 6 rows * 2 left seats (per row)
    int totalFemaleSeats = 6 * 2; // 6 rows * 2 right seats (per row)

    int malesToBook = totalMaleSeats - globals.availableMaleSeats;
    int femalesToBook = totalFemaleSeats - globals.availableFemaleSeats;

    // Book Male Seats (left side)
    outerMale:
    for (int i = 0; i < seatLayout.length; i++) {
      for (int j = 0; j < 2; j++) {
        if (seatLayout[i][j] && malesToBook > 0) {
          bookedMaleSeats[i][j] = true;
          malesToBook--;
        }
        if (malesToBook <= 0) break outerMale;
      }
    }

    // Book Female Seats (right side)
    outerFemale:
    for (int i = 0; i < seatLayout.length; i++) {
      for (int j = 3; j < 5; j++) {
        if (seatLayout[i][j] && femalesToBook > 0) {
          bookedFemaleSeats[i][j] = true;
          femalesToBook--;
        }
        if (femalesToBook <= 0) break outerFemale;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalSeats = 6 * 4;

    return Scaffold(
      appBar: AppBar(title: const Text('Seat Availability'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              'Available Seats: ${globals.availableMaleSeats + globals.availableFemaleSeats} / $totalSeats',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'Males: ${globals.availableMaleSeats} | Females: ${globals.availableFemaleSeats}',
              style: const TextStyle(fontSize: 18),
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

                    if (!seatLayout[row][col]) {
                      return const SizedBox(); // Aisle
                    }

                    bool isBookedMale = bookedMaleSeats[row][col];
                    bool isBookedFemale = bookedFemaleSeats[row][col];

                    Color seatColor;
                    if (isBookedMale) {
                      seatColor = Colors.blue; // Booked Male
                    } else if (isBookedFemale) {
                      seatColor = Colors.pink; // Booked Female
                    } else {
                      seatColor = Colors.green; // Available
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: seatColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black),
                      ),
                      child: const Icon(
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
