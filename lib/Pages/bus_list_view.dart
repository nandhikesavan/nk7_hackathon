import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class BusListView extends StatefulWidget {
  const BusListView({Key? key}) : super(key: key);

  @override
  _BusListViewState createState() => _BusListViewState();
}

class _BusListViewState extends State<BusListView> {
  final DatabaseReference _busRef = FirebaseDatabase.instance.ref().child(
    'buses',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removed appBar here
      body: StreamBuilder(
        stream: _busRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading buses'));
          }

          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map data = Map<String, dynamic>.from(
              snapshot.data!.snapshot.value as Map,
            );
            List<Map<String, dynamic>> buses =
                data.entries.map((entry) {
                  return Map<String, dynamic>.from(entry.value);
                }).toList();

            return ListView.builder(
              itemCount: buses.length,
              itemBuilder: (context, index) {
                final bus = buses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.directions_bus),
                    title: Text('Bus Number: ${bus['busNumber'] ?? ''}'),
                    subtitle: Text(
                      'Start to Stop: ${bus['driverName'] ?? ''}\n'
                      'Driver Name: ${bus['numberPlate'] ?? ''}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () => _showBusDetails(context, bus),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No buses available.'));
          }
        },
      ),
    );
  }

  void _showBusDetails(BuildContext context, Map<String, dynamic> bus) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Bus Number: ${bus['busNumber'] ?? ''}'),
            content: Text(
              'Start to Stop: ${bus['driverName'] ?? ''}\n'
              'Driver Name: ${bus['numberPlate'] ?? ''}',
            ),
            actions: [
              TextButton(
                child: const Text('Close'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }
}
