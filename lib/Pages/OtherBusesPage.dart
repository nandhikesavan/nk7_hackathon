import 'package:flutter/material.dart';
import 'map_view.dart';
import 'bus_timing_view.dart';
import 'bus_list_view.dart';
import '../screens/user_data.dart'; // Ensure correct import path

class OtherBusesPage extends StatefulWidget {
  final UserData userData;

  const OtherBusesPage({Key? key, required this.userData}) : super(key: key);

  @override
  _OtherBusesPageState createState() => _OtherBusesPageState();
}

class _OtherBusesPageState extends State<OtherBusesPage> {
  int _selectedIndex = 0;

  // Method to change the view based on selected index
  Widget _getSelectedView(int index) {
    switch (index) {
      case 0:
        return MapView();
      case 1:
        return BusTimingView();
      case 2:
        return BusListView();
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
      appBar: AppBar(title: Text('Other Buses')),
      body: _getSelectedView(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Bus Timing',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Bus List'),
        ],
      ),
    );
  }
}
