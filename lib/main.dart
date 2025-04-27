import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nk7_hach/Splashscreen/splashscreen.dart';

import 'login/Login.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBZiKeTlxm33KqyXzV6ehnJeO_3NDwykPc',
        appId: '1:421265623000:android:a3bae1ccdfaf5de899d4ad',
        messagingSenderId: '421265623000',
        projectId: 'marcofire',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }


  runApp(const Myapp());
}
class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
