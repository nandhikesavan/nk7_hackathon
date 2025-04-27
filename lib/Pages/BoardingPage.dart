import 'package:flutter/material.dart';

class BoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Boarding Details')),
      body: Center(
        child: Text(
          'Welcome to the Boarding Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
