import 'package:flutter/material.dart';
import 'mymap_view.dart';
import 'select_bus_view.dart';

class MyBusPage extends StatefulWidget {
  @override
  _MyBusPageState createState() => _MyBusPageState();
}

class _MyBusPageState extends State<MyBusPage> {
  int _selectedIndex = 0;

  // Method to change the view based on selected index
  Widget _getSelectedView(int index) {
    switch (index) {
      case 0:
        return MapView(); // Map view widget
      case 1:
        return SelectBusView(); // Select bus view widget
      default:
        return Center(child: Text('Unknown View'));
    }
  }

  // Method to handle navigation bar item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Bus')),
      body: _getSelectedView(
        _selectedIndex,
      ), // Display content based on selection
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Select Bus',
          ),
        ],
      ),
    );
  }
}
