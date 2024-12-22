import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:heavy_rental_app/auth/auth.dart';
import 'package:heavy_rental_app/auth/login_or_register.dart';
import 'package:heavy_rental_app/firebase_options.dart';
import 'package:heavy_rental_app/pages/add_products.dart';
import 'package:heavy_rental_app/pages/edit_products.dart';
import 'package:heavy_rental_app/pages/register_page.dart';

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
        brightness:
            Brightness.light, // Use a light theme for better readability
        primaryColor:
            Colors.blueGrey[900], // A dark blue-grey for a professional look
        scaffoldBackgroundColor: Colors.grey[100], // Light grey background
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[900], // Dark blue-grey app bar
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black, fontSize: 16),
          titleMedium: TextStyle(color: Colors.black, fontSize: 18),
          titleLarge: TextStyle(
            color: Colors.blueGrey, // Title color matches primary
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
          labelStyle: TextStyle(color: Colors.grey),
          hintStyle: TextStyle(color: Colors.grey),
        ),
        cardColor: Colors.white,
      ),
      home: const AuthPage(),
      routes: {
        '/addItem': (context) => const AddItemScreen(),
      },
    );
  }
}
