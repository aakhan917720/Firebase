import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostsScreen extends StatefulWidget {
  const AddPostsScreen({super.key});

  @override
  State<AddPostsScreen> createState() => _AddPostsScreenState();
}

class _AddPostsScreenState extends State<AddPostsScreen> {

  final postController = TextEditingController();
  bool loading = false;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref("Posts");
  String id = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Post Screen",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30),

            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 30),

            InkWell(
              onTap: loading
                  ? null
                  : () async {
                if (postController.text.isEmpty) {
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
                  // ✅ push() se har post ka unique ID banta hai
                  final newPostRef = _databaseRef.push();

                  await newPostRef.set({
                    'id': id,
                    'title': postController.text,
                    'post': postController.text,
                    'createdAt': DateTime.now().toIso8601String(),
                  });


                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("✅ Post saved successfully!"),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("❌ Error: ${e.toString()}"),
                    ),
                  );
                }

                setState(() => loading = false);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.black87),
                  color: loading ? Colors.grey : Colors.blue,
                ),
                child: Center(
                  child: loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
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