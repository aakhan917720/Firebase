import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostsScreen extends StatefulWidget {
  const AddPostsScreen({super.key});

  @override
  State<AddPostsScreen> createState() => _AddPostsScreenState();
}

class _AddPostsScreenState extends State<AddPostsScreen> {
  final TextEditingController postController = TextEditingController();
  bool loading = false;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref("Posts");

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  Future<void> _addPost() async {
    if (postController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("⚠️ Please write something first!"),
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final newPostRef = _databaseRef.push();
      await newPostRef.set({
        'id': newPostRef.key,
        'title': postController.text.trim(),
        'post': postController.text.trim(),
        'createdAt': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text("✅ Post saved successfully!"),
        ),
      );

      postController.clear();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("❌ Error: ${e.toString()}"),
        ),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Post",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30),

            TextFormField(
              controller: postController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),

            SizedBox(height: 30),

            InkWell(
              onTap: loading ? null : _addPost,
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: loading ? Colors.grey : Colors.blue,
                ),
                child: Center(
                  child: loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Add Post",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}