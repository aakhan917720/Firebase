import 'package:flutter/material.dart';

class VerifyCode extends StatefulWidget {
  final String verificationId;

  const VerifyCode({super.key, required this.verificationId});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify"),
        backgroundColor: Colors.blue,
      ),body: Column(
      children: [


        SizedBox(height: 30,),



      ],
    ),
    );
  }
}
