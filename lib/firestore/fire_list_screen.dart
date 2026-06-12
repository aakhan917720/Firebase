import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Ui/auth/login_screen.dart';
import 'add_firestore.dart';

class FirePostScreen extends StatefulWidget {
  const FirePostScreen({super.key});

  @override
  State<FirePostScreen> createState() => _FirePostScreenState();
}

class _FirePostScreenState extends State<FirePostScreen> {
  final auth = FirebaseAuth.instance;

  final CollectionReference _firestoreRef = FirebaseFirestore.instance.collection("Posts");

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ✅ Delete Dialog
  void deletePost(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Post Delete Karo"),
        content: const Text("Kya aap yeh post delete karna chahte hain?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _firestoreRef.doc(docId).delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
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
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ✅ Edit Dialog
  void editPost(String docId, String currentText) {
    final TextEditingController _editController =
    TextEditingController(text: currentText);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Post Edit Karo"),
        content: TextField(
          controller: _editController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Post update karo...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              if (_editController.text.trim().isEmpty) return;
              Navigator.pop(context);
              try {
                await _firestoreRef.doc(docId).update({
                  'post': _editController.text.trim(),
                  'title': _editController.text.trim(),
                  'updatedAt': DateTime.now().toIso8601String(),
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("✅ Post update ho gayi!"),
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
            child: const Text("Update", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  // ✅ Text highlight function
  List<TextSpan> _highlightText(String text, String query) {
    if (query.isEmpty) {
      return [TextSpan(text: text, style: const TextStyle(fontSize: 16, color: Colors.black87))];
    }

    final List<TextSpan> spans = [];
    final String lowerText = text.toLowerCase();
    final String lowerQuery = query.toLowerCase();
    int start = 0;

    while (true) {
      final int index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(
          text: text.substring(start),
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          backgroundColor: Colors.yellow,
          fontWeight: FontWeight.bold,
        ),
      ));
      start = index + query.length;
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }).onError((error, stackTrace) {
                Utils().toastMessages(error.toString());
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        title: const Text(
          "Post Screen",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),

      // 👇 Body ko PopScope se wrap kiya hai taake back button control ho sake
      body: PopScope(
        canPop: false, // Back navigation ko block karne ke liye
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;

          // User ko alert dene ke liye Snackbar lagaya hai
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orange,
              content: Text('⚠️ Logout kiye baghair aap wapas nahi ja sakte!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: Column(
          children: [

            // ── Search Bar ──────────────────────────────
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search posts...',
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade200),
                  ),
                ),
              ),
            ),

            // ── Posts List ──────────────────────────────
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestoreRef.orderBy('createdAt', descending: true).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error, color: Colors.red, size: 50),
                            const SizedBox(height: 10),
                            Text(
                              "❌ Error:\n${snapshot.error}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No posts available.\nTap the + button to add a new post!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  final allPosts = snapshot.data!.docs.map((doc) {
                    final postData = doc.data() as Map<String, dynamic>;
                    postData['pushKey'] = doc.id;
                    return postData;
                  }).toList();

                  final postsList = _searchQuery.isEmpty
                      ? allPosts
                      : allPosts.where((post) {
                    final postText = (post['post'] ?? '').toLowerCase();
                    return postText.contains(_searchQuery.toLowerCase());
                  }).toList();

                  if (postsList.isEmpty) {
                    return Center(
                      child: Text(
                        _searchQuery.isEmpty
                            ? 'No posts available.\nTap the + button to add a new post!'
                            : 'No results found for "$_searchQuery"',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: postsList.length,
                    itemBuilder: (context, index) {
                      final post = postsList[index];
                      final pushKey = post['pushKey'] ?? '';
                      final postText = post['post'] ?? post['title'] ?? '';
                      final createdAt = post['createdAt'] ?? '';

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: _highlightText(postText, _searchQuery),
                                      ),
                                    ),
                                  ),

                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onSelected: (value) {
                                      if (value == 'delete') {
                                        if (pushKey.isNotEmpty) deletePost(pushKey);
                                      } else if (value == 'edit') {
                                        if (pushKey.isNotEmpty) editPost(pushKey, postText);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, color: Colors.blue, size: 20),
                                            SizedBox(width: 8),
                                            Text("Edit"),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuDivider(),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete, color: Colors.red, size: 20),
                                            SizedBox(width: 8),
                                            Text("Delete", style: TextStyle(color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue.shade200),
                                ),
                                child: Text(
                                  'Doc ID: $pushKey',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.blue.shade700,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                createdAt,
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFireStoreScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}