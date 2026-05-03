import 'dart:async';

import 'package:flutter/material.dart';

import '../Ui/auth/login_screen.dart';


class SplashSerivces {

void login(BuildContext context){

  Timer(Duration(seconds: 2), ()=>Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context)=>LoginScreen(),
    ),
  )
  );



}
}