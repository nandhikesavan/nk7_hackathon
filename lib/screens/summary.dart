import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:nk7_hach/screens/user_data.dart';
import 'package:nk7_hach/screens/checkbox_animation_page.dart';
import '../widgets/step_progress.dart';

class Page5Summary extends StatefulWidget {
  final UserData userData;

  const Page5Summary({Key? key, required this.userData}) : super(key: key);

  @override
  _Page5SummaryState createState() => _Page5SummaryState();
}

class _Page5SummaryState extends State<Page5Summary> {
  bool termsAccepted = false;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<String?> _convertImageToBase64(String imagePath) async {
    try {
      File imageFile = File(imagePath);
      List<int> imageBytes = await imageFile.readAsBytes();
      return base64Encode(imageBytes);
    } catch (e) {
      print("Image conversion failed: $e");
      return null;
    }
  }

  void _saveToFirebase() async {
    if (!termsAccepted) return;

    String? base64Image;
    if (widget.userData.role == 'Driver' &&
        widget.userData.profileImage != null &&
        widget.userData.profileImage!.isNotEmpty) {
      base64Image = await _convertImageToBase64(widget.userData.profileImage!);
    }

    Map<String, dynamic> userDataMap = {
      "name": widget.userData.name,
      "role": widget.userData.role,
      "gender": widget.userData.gender,
      "dob": widget.userData.dob?.toIso8601String() ?? "Not Set",
      "phone": widget.userData.phoneNumber,
      "country": widget.userData.country,
      "state": widget.userData.state,
      "district": widget.userData.district,
      "city": widget.userData.city,
      "area": widget.userData.area,
      "address": widget.userData.address,
      "experience":
          widget.userData.role == 'Driver' ? widget.userData.experience : "N/A",
      "profileImageBase64": base64Image ?? "No Image",
    };

    try {
      await _database.child("users").push().set(userDataMap);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => CheckboxAnimationPage(
                success: true,
                userData: widget.userData,
              ),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save data: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: const Text(
          'Profile Overview',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepProgress(currentStep: 5, totalSteps: 5),
            const SizedBox(height: 20),
            const Text(
              'Review Your Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Center(
              child: Column(
                children: [
                  if (widget.userData.role == 'Driver')
                    CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.grey[200],
                      backgroundImage:
                          widget.userData.profileImage != null
                              ? FileImage(File(widget.userData.profileImage!))
                              : null,
                      child:
                          widget.userData.profileImage == null
                              ? const Icon(
                                Icons.person,
                                size: 65,
                                color: Colors.blue,
                              )
                              : null,
                    ),
                ],
              ),
            ),

            const SizedBox(height: 25),
            const Text(
              'Personal Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Name:', widget.userData.name),
            _buildInfoRow('Role:', widget.userData.role),
            _buildInfoRow('Gender:', widget.userData.gender),
            _buildInfoRow(
              'DOB:',
              widget.userData.dob?.toLocal().toString().split(' ')[0] ??
                  "Not Set",
            ),

            const SizedBox(height: 20),
            const Text(
              'Contact Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Phone:', widget.userData.phoneNumber),
            _buildInfoRow('Country:', widget.userData.country),
            _buildInfoRow('State:', widget.userData.state),
            _buildInfoRow('District:', widget.userData.district),
            _buildInfoRow('City:', widget.userData.city),
            _buildInfoRow('Area:', widget.userData.area),
            _buildInfoRow('Address:', widget.userData.address),

            if (widget.userData.role == 'Driver') ...[
              const SizedBox(height: 20),
              const Text(
                'Experience',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildInfoRow('Experience:', widget.userData.experience),
            ],

            const SizedBox(height: 20),
            CheckboxListTile(
              value: termsAccepted,
              onChanged: (value) {
                setState(() {
                  termsAccepted = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('I accept the Terms & Conditions'),
              contentPadding: EdgeInsets.zero,
              activeColor: Colors.blue,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: termsAccepted ? _saveToFirebase : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          termsAccepted ? Colors.blue : Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'Not provided',
              textAlign: TextAlign.end,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
