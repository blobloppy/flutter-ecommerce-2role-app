import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:heavy_rental_app/auth/auth.dart';
import 'package:heavy_rental_app/auth/login_or_register.dart';
import 'package:heavy_rental_app/firebase_options.dart';
import 'package:heavy_rental_app/pages/register_page.dart';

import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
