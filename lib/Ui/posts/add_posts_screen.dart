import 'package:flutter/material.dart';


class AddPostsScreen extends StatefulWidget {
  const AddPostsScreen({super.key});

  @override
  State<AddPostsScreen> createState() => _AddPostsScreenState();
}

class _AddPostsScreenState extends State<AddPostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post Screen", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),body: Column(

      children: [

        SizedBox(height: 30,),

        TextFormField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "What's on your mind?",
            border: OutlineInputBorder(),
          ),
        ),

        SizedBox(height: 30,),


        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: Colors.black87,
            ),
            color: Colors.blue
          ),
          child: Center(
            child: Text("Submit"),
          ),
        ),








      ],

    ),
    );
  }
}
