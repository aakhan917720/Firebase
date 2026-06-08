import 'package:firebase/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../auth/login_screen.dart';
import 'add_posts_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref("Posts");

  List<Map<dynamic, dynamic>> postsList = [];
  bool loading = true;
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  // ✅ Realtime Database se data fetch
  void fetchPosts() {
    _databaseRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;

      if (data == null) {
        setState(() {
          postsList = [];
          loading = false;
          errorMsg = '';
        });
        return;
      }

      try {
        final Map<dynamic, dynamic> map = data as Map<dynamic, dynamic>;
        final list = map.entries
            .map((e) => e.value as Map<dynamic, dynamic>)
            .toList()
            .reversed
            .toList();

        setState(() {
          postsList = list;
          loading = false;
          errorMsg = '';
        });
      } catch (e) {
        setState(() {
          loading = false;
          errorMsg = e.toString();
        });
      }
    }, onError: (error) {
      setState(() {
        loading = false;
        errorMsg = error.toString();
      });
    });
  }

  // ✅ Delete function — ID se post remove karo
  void deletePost(String postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Post Delete Karo"),
        content: Text("Kya aap yeh post delete karna chahte hain?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _databaseRef.child(postId).remove();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("✅ Post delete ho gayi!"),
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
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }).onError((error, stackTrace) {
                Utils().toastMessages(error.toString());
              });
            },
            icon: Icon(Icons.logout),
          ),
        ],
        title: Text(
          "Post Screen",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.blue,
      ),

      body: loading
      // ── Loading ──────────────────────────────────────────
          ? Center(child: CircularProgressIndicator())

      // ── Error ────────────────────────────────────────────
          : errorMsg.isNotEmpty
          ? Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 50),
              SizedBox(height: 10),
              Text(
                "❌ Error:\n$errorMsg",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      )

      // ── Empty ────────────────────────────────────────────
          : postsList.isEmpty
          ? Center(
        child: Text(
          'No posts available.\nTap the + button to add a new post!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )

      // ── Posts List ───────────────────────────────────────
          : ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: postsList.length,
        itemBuilder: (context, index) {
          final post = postsList[index];
          final postId    = post['id']        ?? '';
          final postText  = post['post']      ?? '';
          final createdAt = post['createdAt'] ?? '';

          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Post Text + Delete button ─────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          postText,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      // 🗑️ Delete button
                      IconButton(
                        onPressed: () {
                          if (postId.isNotEmpty) {
                            deletePost(postId);
                          }
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Delete Post',
                      ),
                    ],
                  ),

                  SizedBox(height: 6),

                  // ── ID Badge ──────────────────────────
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Text(
                      'ID: $postId',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue.shade700,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),

                  SizedBox(height: 4),

                  // ── Timestamp ─────────────────────────
                  Text(
                    createdAt,
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPostsScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}