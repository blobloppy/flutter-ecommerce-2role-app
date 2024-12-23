import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heavy_rental_app/components/my_button.dart';
import 'package:heavy_rental_app/components/my_textfield.dart';
import 'package:heavy_rental_app/helper/helper_function.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  // Role selection
  String selectedRole = 'user'; // Default role

  // Register method
  void registerUser() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Make sure passwords match
    if (passwordController.text != confirmController.text) {
      Navigator.pop(context);
      displayMessageToUser("Passwords don't match", context);
      return;
    }

    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Save user info in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': usernameController.text,
        'email': emailController.text,
        'role': selectedRole, // Save the selected role
      });

      // Dismiss loading circle
      Navigator.pop(context);

      // Notify success
      displayMessageToUser("User registered successfully!", context);
    } on FirebaseAuthException catch (e) {
      // Dismiss loading circle
      Navigator.pop(context);

      // Show error message
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Icon(
                  Icons.inventory,
                  size: 80,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),

                const SizedBox(height: 25),

                // App name
                const Text(
                  "I N V E N T O R Y",
                  style: TextStyle(fontSize: 20),
                ),

                const SizedBox(height: 50),

                // Username textfield
                MyTextfield(
                  hintText: "Username",
                  obscureText: false,
                  controller: usernameController,
                ),

                const SizedBox(height: 10),

                // Email textfield
                MyTextfield(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController,
                ),

                const SizedBox(height: 10),

                // Password textfield
                MyTextfield(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController,
                ),

                const SizedBox(height: 10),

                // Confirm password textfield
                MyTextfield(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: confirmController,
                ),

                const SizedBox(height: 10),

                // Role selection dropdown
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: const [
                    DropdownMenuItem(value: 'user', child: Text('User')),
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Select Role',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // Register button
                MyButton(
                  text: "Register",
                  onTap: registerUser,
                ),

                const SizedBox(height: 25),

                // Already have an account? Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Login Here",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
