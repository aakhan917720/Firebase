import 'package:firebase/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/login_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (){
                auth.signOut().then((value){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context)=>LoginScreen()));
                }).onError((error, stackTrace){
                  Utils().toastMessages(error.toString());
                });
              },
              icon: Icon(Icons.logout)
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
    );
  }
}
