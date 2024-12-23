import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heavy_rental_app/auth/login_or_register.dart';
import 'package:heavy_rental_app/pages/home_page.dart';
import 'package:heavy_rental_app/pages/user_home.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Check if the user is logged in
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for auth state
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            // User is logged in, fetch their role
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!.uid)
                  .get(),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator while fetching the role
                  return const Center(child: CircularProgressIndicator());
                }

                if (roleSnapshot.hasData && roleSnapshot.data!.exists) {
                  final role = roleSnapshot.data!.get('role') as String;

                  // Navigate based on role
                  if (role == 'admin') {
                    return HomeScreen();
                  } else if (role == 'user') {
                    return UserHome();
                  } else {
                    return const Center(
                      child: Text('Role not defined. Please contact support.'),
                    );
                  }
                } else {
                  return const Center(
                    child: Text('User data not found.'),
                  );
                }
              },
            );
          } else {
            // User is not logged in, show login/register page
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
