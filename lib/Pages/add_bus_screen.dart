import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'bus_form_page.dart';

class AddBusScreen extends StatefulWidget {
  @override
  _AddBusScreenState createState() => _AddBusScreenState();
}

class _AddBusScreenState extends State<AddBusScreen> {
  final DatabaseReference _busRef = FirebaseDatabase.instance.ref().child(
    'buses',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Bus')),
      body: StreamBuilder(
        stream: _busRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map data = snapshot.data!.snapshot.value as Map;
            List<Widget> busList =
                data.entries.map<Widget>((entry) {
                  String key = entry.key;
                  Map value = entry.value;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: ListTile(
                      leading: Icon(Icons.directions_bus),
                      title: Text(
                        'Bus Number  :   ${value['busNumber'] ?? ''}\nStart to Stop:   ${value['driverName'] ?? ''}\nDriver Name :   ${value['numberPlate'] ?? ''}',
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (String choice) {
                          if (choice == 'Edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => BusFormPage(
                                      busKey: key,
                                      busData: Map<String, dynamic>.from(value),
                                    ),
                              ),
                            );
                          } else if (choice == 'Delete') {
                            _confirmDelete(context, key);
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return ['Edit', 'Delete'].map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  );
                }).toList();

            return ListView(children: busList);
          } else {
            return Center(child: Text('No buses found.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BusFormPage()),
          ).then((_) => setState(() {}));
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Bus',
      ),
    );
  }

  void _confirmDelete(BuildContext context, String key) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Delete Bus'),
            content: Text('Are you sure you want to delete this bus?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // cancel
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _busRef.child(key).remove();
                  Navigator.pop(context);
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
