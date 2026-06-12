import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Utils/utils.dart';
import 'package:flutter/material.dart';

class AddFireStoreScreen extends StatefulWidget {
  const AddFireStoreScreen({super.key});

  @override
  State<AddFireStoreScreen> createState() => _AddFireStoreScreenState();
}

class _AddFireStoreScreenState extends State<AddFireStoreScreen> {
  final _postController = TextEditingController();
  bool loading = false;

  // 👈 Firestore Collection Reference
  final CollectionReference _firestoreRef = FirebaseFirestore.instance.collection("Posts");

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Post',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // Back button white karne ke liye
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // ── Styled TextField ──────────────────────────────
            TextField(
              controller: _postController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.blue.shade50.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.blue.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.blue.shade200),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ── Modern Styled Button ──────────────────────────────
            SizedBox(
              width: double.infinity, // Button ko full width karne ke liye
              height: 55, // Button ki height barhai
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button ka main color
                  foregroundColor: Colors.white, // Text aur Ripple ka color
                  elevation: 3, // Shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                ),
                onPressed: loading
                    ? null // Loading ke dauran button disable ho jayega
                    : () async {
                  if (_postController.text.trim().isEmpty) {
                    Utils().toastMessages('⚠️ Please write something first!');
                    return;
                  }

                  setState(() => loading = true);

                  try {
                    await _firestoreRef.add({
                      'post': _postController.text.trim(),
                      'title': _postController.text.trim(),
                      'createdAt': DateTime.now().toIso8601String(),
                    });
                    Utils().toastMessages('✅ Post add ho gayi!');
                    Navigator.pop(context);
                  } catch (e) {
                    Utils().toastMessages('❌ Error: ${e.toString()}');
                  } finally {
                    setState(() => loading = false);
                  }
                },
                child: loading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3, // Spinner ko thoda patla kiya taake aacha lage
                  ),
                )
                    : const Text(
                  'Add Post',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1, // Letters ke beech thoda space
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}