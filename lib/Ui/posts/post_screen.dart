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

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ✅ Delete Dialog
  void deletePost(String pushKey) {
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
                await _databaseRef.child(pushKey).remove();
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

  // ✅ Edit Dialog — delete ki tarah
  void editPost(String pushKey, String currentText) {
    final TextEditingController _editController =
    TextEditingController(text: currentText);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Post Edit Karo"),
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
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              if (_editController.text.trim().isEmpty) return;
              Navigator.pop(context);
              try {
                await _databaseRef.child(pushKey).update({
                  'post': _editController.text.trim(),
                  'title': _editController.text.trim(),
                  'updatedAt': DateTime.now().toIso8601String(),
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
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
            child: Text("Update", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  // ✅ Text highlight function
  List<TextSpan> _highlightText(String text, String query) {
    if (query.isEmpty) {
      return [TextSpan(text: text, style: TextStyle(fontSize: 16, color: Colors.black87))];
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
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
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

      body: Column(
        children: [

          // ── Search Bar ──────────────────────────────
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search posts...',
                prefixIcon: Icon(Icons.search, color: Colors.blue),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey),
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
                  borderSide: BorderSide(color: Colors.blue, width: 2),
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
            child: StreamBuilder(
              stream: _databaseRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, color: Colors.red, size: 50),
                          SizedBox(height: 10),
                          Text(
                            "❌ Error:\n${snapshot.error}",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return Center(
                    child: Text(
                      'No posts available.\nTap the + button to add a new post!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                final Map<dynamic, dynamic> map =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                final allPosts = map.entries.map((e) {
                  final postData = Map<String, dynamic>.from(e.value as Map);
                  postData['pushKey'] = e.key;
                  return postData;
                }).toList();

                allPosts.sort((a, b) {
                  final aTime = a['createdAt'] ?? '';
                  final bTime = b['createdAt'] ?? '';
                  return bTime.compareTo(aTime);
                });

                final postsList = _searchQuery.isEmpty
                    ? allPosts
                    : allPosts.where((post) {
                  final postText =
                  (post['post'] ?? '').toLowerCase();
                  return postText
                      .contains(_searchQuery.toLowerCase());
                }).toList();

                if (postsList.isEmpty) {
                  return Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'No posts available.\nTap the + button to add a new post!'
                          : 'No results found for "$_searchQuery"',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: postsList.length,
                  itemBuilder: (context, index) {
                    final post = postsList[index];
                    final pushKey = post['pushKey'] ?? '';
                    final postText = post['post'] ?? post['title'] ?? '';
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

                            // ── Post Text + PopupMenu ────────
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: _highlightText(
                                          postText, _searchQuery),
                                    ),
                                  ),
                                ),

                                // ✅ PopupMenuButton
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.more_vert,
                                      color: Colors.grey),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      if (pushKey.isNotEmpty)
                                        deletePost(pushKey);
                                    } else if (value == 'edit') {
                                      if (pushKey.isNotEmpty)
                                        editPost(pushKey, postText);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit,
                                              color: Colors.blue, size: 20),
                                          SizedBox(width: 8),
                                          Text("Edit"),
                                        ],
                                      ),
                                    ),
                                    PopupMenuDivider(),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete,
                                              color: Colors.red, size: 20),
                                          SizedBox(width: 8),
                                          Text("Delete",
                                              style: TextStyle(
                                                  color: Colors.red)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: 6),

                            // ── ID Badge ─────────────────────
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                Border.all(color: Colors.blue.shade200),
                              ),
                              child: Text(
                                'Key: $pushKey',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue.shade700,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              createdAt,
                              style:
                              TextStyle(fontSize: 11, color: Colors.grey),
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

      // ✅ FAB — AddPostsScreen pe jata hai
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