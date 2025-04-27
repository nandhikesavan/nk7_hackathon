import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'MyBusPage.dart';
import 'OtherBusesPage.dart';
import 'AttendancePage.dart';
import 'SeatAvailabilityPage.dart';
import 'BoardingPage.dart'; // <<==== ADDED
import '../login/Login.dart'; // adjust path if needed
import '../screens/user_data.dart'; // adjust path if needed

class Jobproviderpage extends StatefulWidget {
  final UserData userData;

  const Jobproviderpage({Key? key, required this.userData}) : super(key: key);

  @override
  _JobproviderpageState createState() => _JobproviderpageState();
}

class _JobproviderpageState extends State<Jobproviderpage> {
  late UserData userData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _backPressCounter = 0;
  DateTime? _lastBackPressed;

  @override
  void initState() {
    super.initState();
    userData = widget.userData;
    _initializePreferences();
  }

  void _initializePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setBool('isdriver', false);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await showModalBottomSheet<XFile?>(
      context: context,
      builder:
          (context) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Take Photo'),
                  onTap: () async {
                    final picked = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    Navigator.pop(context, picked);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Choose from Gallery'),
                  onTap: () async {
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    Navigator.pop(context, picked);
                  },
                ),
              ],
            ),
          ),
    );

    if (image != null) {
      setState(() {
        userData.profileImage = image.path;
      });
    }
  }

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > Duration(seconds: 2)) {
      _lastBackPressed = now;
      _backPressCounter = 1;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Press back again to confirm exit')),
      );
      return Future.value(false);
    } else {
      _backPressCounter++;
      if (_backPressCounter >= 2) {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Exit App'),
                content: Text('Are you sure you want to exit?'),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  TextButton(
                    child: Text('Exit'),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              ),
        );
        if (shouldExit == true) {
          SystemNavigator.pop();
        }
      }
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFF123456),
        appBar: AppBar(
          title: Text(
            '  TRANSIT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF123456),
          elevation: 0,
          leading: null, // remove left icon
          actions: [
            GestureDetector(
              onTap: () {
                _scaffoldKey.currentState?.openEndDrawer(); // open right drawer
              },
              child: _buildProfileAvatar(radius: 40), // Adjust size here
            ),
          ],
        ),
        endDrawer: _buildDrawer(), // right drawer
        body: _buildTransitBody(),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userData.name),
            accountEmail: Text(userData.phoneNumber),
            currentAccountPicture: Stack(
              children: [
                _buildProfileAvatar(radius: 40),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.edit, size: 20, color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              bool shouldLogout = await showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text("Confirm Logout"),
                      content: Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text("Confirm"),
                        ),
                      ],
                    ),
              );

              if (shouldLogout == true) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Profile Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          _buildProfileDetail('Role', userData.role),
          _buildProfileDetail('Gender', userData.gender),
          _buildProfileDetail(
            'DOB',
            userData.dob?.toLocal().toString().split(' ')[0] ?? 'Not Set',
          ),
          _buildProfileDetail('Phone', userData.phoneNumber),
          _buildProfileDetail('Country', userData.country),
          _buildProfileDetail('State', userData.state),
          _buildProfileDetail('District', userData.district),
          _buildProfileDetail('City', userData.city),
          _buildProfileDetail('Area', userData.area),
          _buildProfileDetail('Address', userData.address),
          if (userData.role == 'Driver')
            _buildProfileDetail('Experience', userData.experience),
        ],
      ),
    );
  }

  Widget _buildTransitBody() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  'Your bus arrives at                                ',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(height: 30),
                Text(
                  '7:30 AM',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                StreamBuilder<DateTime>(
                  stream: Stream.periodic(
                    Duration(seconds: 1),
                    (_) => DateTime.now(),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (!snapshot.hasData) {
                      return Text('Error');
                    }
                    final time = DateFormat(
                      'hh:mm:ss a',
                    ).format(snapshot.data!);
                    return Text(
                      'TIME: $time',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 70),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 25,
              mainAxisSpacing: 25,
              childAspectRatio: 1.2,
              children: [
                _buildMenuItem(Icons.location_on, 'My Bus', MyBusPage()),
                _buildMenuItem(
                  Icons.directions_bus,
                  'Other Buses',
                  OtherBusesPage(),
                ),
                _buildMenuItem(
                  Icons.assignment,
                  'Attendance',
                  AttendancePage(),
                ),
                _buildMenuItem(
                  Icons.event_seat,
                  'Seat Availability',
                  SeatAvailabilityPage(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BoardingPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: Size(double.infinity, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Mark as Boarded',
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.black87),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value.isNotEmpty ? value : 'Not provided'),
    );
  }

  Widget _buildProfileAvatar({double radius = 20}) {
    if (userData.profileImage != null && userData.profileImage!.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: FileImage(File(userData.profileImage!)),
        radius: radius, // Adjust size here
      );
    }

    if (userData.role == 'Student') {
      return CircleAvatar(
        backgroundColor: Colors.grey[300],
        radius: radius, // Adjust size here
        child: Text(
          userData.name.isNotEmpty ? userData.name[0].toUpperCase() : '?',
          style: TextStyle(fontSize: radius, color: Colors.blue),
        ),
      );
    }

    return CircleAvatar(
      radius: radius, // Adjust size here
      backgroundColor: Colors.grey[500],
      child: Icon(Icons.account_circle, size: radius * 2, color: Colors.white),
    );
  }
}
