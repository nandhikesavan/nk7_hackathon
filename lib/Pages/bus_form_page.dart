import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class BusFormPage extends StatefulWidget {
  final String? busKey;
  final Map<String, dynamic>? busData;

  BusFormPage({this.busKey, this.busData});

  @override
  _BusFormPageState createState() => _BusFormPageState();
}

class _BusFormPageState extends State<BusFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _busNumberController = TextEditingController();
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _numberPlateController = TextEditingController();

  final DatabaseReference _busRef = FirebaseDatabase.instance.ref().child(
    'buses',
  );

  @override
  void initState() {
    super.initState();
    if (widget.busData != null) {
      _busNumberController.text = widget.busData!['busNumber'] ?? '';
      _driverNameController.text = widget.busData!['driverName'] ?? '';
      _numberPlateController.text = widget.busData!['numberPlate'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.busKey != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Bus Details' : 'Add Bus Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _busNumberController,
                decoration: InputDecoration(labelText: 'Bus Number'),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter the bus number' : null,
              ),
              TextFormField(
                controller: _driverNameController,
                decoration: InputDecoration(labelText: 'Start to Stop'),
                validator:
                    (value) =>
                        value!.isEmpty
                            ? 'Please enter the Start to stoping'
                            : null,
              ),
              TextFormField(
                controller: _numberPlateController,
                decoration: InputDecoration(labelText: 'Driver name'),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter the Driver name' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newBus = {
                      'busNumber': _busNumberController.text,
                      'driverName': _driverNameController.text,
                      'numberPlate': _numberPlateController.text,
                    };

                    if (isEdit) {
                      await _busRef.child(widget.busKey!).update(newBus);
                    } else {
                      await _busRef.push().set(newBus);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Bus details saved')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text(isEdit ? 'Update' : 'Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
