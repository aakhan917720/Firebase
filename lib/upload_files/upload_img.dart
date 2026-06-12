import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:img_picker/img_picker.dart'; // 👈 SystemNavigator.pop() ke liye zaroori hai

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final _titleController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  bool loading = false;

  // Double tap track karne ke liye variable
  DateTime? lastPressed;

  // Firebase References
  final CollectionReference _firestoreRef = FirebaseFirestore.instance.collection("Posts");
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref("Posts");

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // 📸 Gallery se Image Pick karna
  Future<void> getImageGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Utils().toastMessages('Koi image select nahi ki!');
      }
    });
  }

  // 🚀 Post upload karne ka function (Data screen par hi rahega)
  Future<void> uploadPostWithImage() async {
    if (_titleController.text.trim().isEmpty) {
      Utils().toastMessages('Title likhna zaroori hai!');
      return;
    }
    if (_image == null) {
      Utils().toastMessages('Image select karna zaroori hai!');
      return;
    }

    setState(() => loading = true);

    try {
      List<int> imageBytes = await _image!.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

      Map<String, dynamic> postData = {
        'id': uniqueId,
        'title': _titleController.text.trim(),
        'post': _titleController.text.trim(),
        'imageUrl': base64Image,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _databaseRef.child(uniqueId).set(postData);
      await _firestoreRef.doc(uniqueId).set(postData);

      Utils().toastMessages('✅ Post uploaded successfully!');

    } catch (e) {
      Utils().toastMessages('❌ Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
        onWillPop: ()async{
      SystemNavigator.pop();
      return false;
    },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Upload Image Post',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: Colors.blue,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if (!loading) Navigator.pop(context);
              },
            ),
          ),

          // 👇 Double Tap to Close Application Dynamic Logic
          body: PopScope(
            canPop: false, // System back button default behavior close kiya
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;

              // Agar image upload ho rahi hai toh back press kaam nahi karega
              if (loading) {
                Utils().toastMessages('⚠️ Please wait, image upload ho rahi hai...');
                return;
              }

              final now = DateTime.now();
              final maxDuration = const Duration(seconds: 2);

              // Agar doosra click 2 seconds ke andar hua hai
              if (lastPressed == null || now.difference(lastPressed!) > maxDuration) {
                lastPressed = now;

                // User ko message show hoga
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🔴 Exit karne ke liye ek bar phir back dabayein'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              } else {
                // Agar doosra tap time par hua toh App close ho jayegi
                SystemNavigator.pop();
              }
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // ── Image Selection Box ──────────────────────────────
                    GestureDetector(
                      onTap: getImageGallery,
                      child: Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.blue.shade200, style: BorderStyle.solid),
                        ),
                        child: _image != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 60, color: Colors.blue.shade300),
                            const SizedBox(height: 10),
                            Text(
                              'Gallery se Image select karein',
                              style: TextStyle(color: Colors.blue.shade700, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ── Description TextField ──────────────────────────────
                    TextField(
                      controller: _titleController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Post ka title ya description likhein...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.blue.shade50.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.blue.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // ── Upload Button ──────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                        ),
                        onPressed: loading ? null : uploadPostWithImage,
                        child: loading
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                            : const Text(
                          'Image Upload',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}