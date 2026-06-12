import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.ref('PasswordResets');

  @override
  Widget build(BuildContext context) {
    // PopScope replaces WillPopScope in newer Flutter versions
    return PopScope(
      canPop: false, // Prevents accidental back swipes
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Logic to handle custom back behavior or show a dialog
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
          // Set to false as per your requirement to hide default back button
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Enter your Gmail',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  resetPassword();
                },
                child: const Text('Send Reset Link'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void resetPassword() {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      // Show error if email is empty
      return;
    }

    // 1. Send Password Reset Email via Firebase Auth
    auth.sendPasswordResetEmail(email: email).then((value) {

      // 2. Store the reset request event in Realtime Database
      databaseRef.child(DateTime.now().millisecondsSinceEpoch.toString()).set({
        'email': email,
        'status': 'Reset Link Sent',
        'timestamp': ServerValue.timestamp,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset link sent to your Gmail!')),
      );

    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    });
  }
}