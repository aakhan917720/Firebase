import 'dart:async';

import 'package:firebase/Ui/posts/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Ui/auth/login_screen.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../firestore/fire_list_screen.dart';
import '../upload_files/upload_img.dart';


class SplashSerivces {

void login(BuildContext context){

  final auth = FirebaseAuth.instance;

  final user = auth.currentUser;

  if(user!= null){
    Timer(Duration(seconds: 2), ()=>Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context)=>PostScreen(),
      ),
    )
    );
  }else{
    Timer(Duration(seconds: 2), ()=>Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context)=>LoginScreen(),
      ),
    )
    );
  }

}
}
