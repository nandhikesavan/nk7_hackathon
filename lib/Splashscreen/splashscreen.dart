import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Pages/students.dart'; // Job provider page
import '../Pages/drivers.dart'; // Worker page
import '../login/Login.dart';
import '../screens/user_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    bool isWorker =
        prefs.getBool('isWorker') ?? false; // Flag for worker status
    String? userDataJson = prefs.getString('userData');

    UserData? userData;
    if (userDataJson != null) {
      Map<String, dynamic> jsonMap = jsonDecode(userDataJson);
      userData = UserData.fromJson(jsonMap);
    }

    await Future.delayed(const Duration(seconds: 2)); // Optional splash delay

    if (isLoggedIn && userData != null) {
      if (isWorker) {
        // If user is a worker, navigate to the WorkerPage
        Get.off(() => Workerpage(userData: userData!));
      } else {
        // If user is a job provider, navigate to the JobProviderPage
        Get.off(() => Jobproviderpage(userData: userData!));
      }
    } else {
      // If not logged in, navigate to the LoginScreen
      Get.off(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 250,
          height: 250,
          child: Image.asset(
            "assets/images/splash.jpeg",
          ), // Splash screen image
        ),
      ),
    );
  }
}
