import 'dart:math';

import 'package:flutter/material.dart';

import '../../firebase_serivces/splash_serivces.dart';




class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {


  SplashSerivces splashScreen = SplashSerivces();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashScreen.login(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(


       body: Center(

         child: Text("Firebase Management",

           style: TextStyle(
             color: Colors.black87,
             fontSize: 30,
             fontStyle: null,
             fontWeight: FontWeight.bold,
           ),

         ),

       ),

    );
  }
}
