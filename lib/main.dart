import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:heavy_rental_app/auth/auth.dart';
import 'package:heavy_rental_app/auth/login_or_register.dart';
import 'package:heavy_rental_app/firebase_options.dart';
import 'package:heavy_rental_app/pages/add_products.dart';
import 'package:heavy_rental_app/pages/edit_products.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark, // Use a dark theme
        primaryColor: Colors.teal, // Minimalist accent color
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.teal),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
          titleMedium: TextStyle(color: Colors.white, fontSize: 18),
          titleLarge: TextStyle(
            color: Colors.teal,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.white70),
          hintStyle: TextStyle(color: Colors.white54),
        ),
        cardColor: Colors.grey[900], // Background color for cards
      ),
      darkTheme: ThemeData.dark(), // Optional: Default Flutter dark theme
      home: const AuthPage(),
      routes: {
        '/addItem': (context) => const AddItemScreen(),
      },
    );
  }
}
