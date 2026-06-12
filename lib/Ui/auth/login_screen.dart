import 'package:firebase/Ui/auth/login_with_phone_number.dart';
import 'package:firebase/Ui/auth/signup_screen.dart';
import 'package:firebase/Ui/posts/post_screen.dart';
import 'package:firebase/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../posts/forgot_password.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailcontroller = TextEditingController();
  final passwordcontoller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool loading = false;

 @override
  void dispose() {
    // TODO: implement dispose
    emailcontroller.dispose();
    passwordcontoller.dispose();
    super.dispose();

  }

  void login(){

   setState(() {
     loading = true;
   });

   _auth.signInWithEmailAndPassword(
       email: emailcontroller.text,
       password: passwordcontoller.text.toString()).then((value){
         // Utils().toastMessages(value.user?.email ?? emailcontroller.text);
     Utils().toastMessages(value.user!.email.toString());
     Navigator.push(
       context,
       MaterialPageRoute(
           builder: (context)=>PostScreen())
     );
         setState(() {
           loading = false;
         });
   }).onError((error, stackTrace) {
     debugPrint(error.toString());
     Utils().toastMessages(error.toString());
     setState(() {
       loading = false;
     });
   });
 }




  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 90,

          title: Text("Login", style: TextStyle(color: Colors.white),),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [




            Card(

              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [


                    SizedBox(height: 10,),


                    Form(

                      key: _formkey,

                      child: Column(

                        children: [


                          TextFormField(
                            controller: emailcontroller,
                            decoration: InputDecoration(
                              hintText: "Email",
                              icon: Icon(Icons.alternate_email),
                            ),

                            validator: (value){
                              if(value!.isEmpty){
                                return "Enter Email";
                              }else{
                                return null;
                              }
                            },

                          ),


                          SizedBox(height: 10,),



                          TextFormField(
                            controller: passwordcontoller,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Password",
                              icon: Icon(Icons.lock_open),
                            ),
                           validator: (value){
                              if(value!.isEmpty){
                                return "Enter Password";
                              }
                              return null;
                           },
                          ),




                        ],

                      ),



                    ),






                    SizedBox(height: 10,),

                    loading ? CircularProgressIndicator()
                    :
                    InkWell(
                      onTap: (){
                        if(_formkey.currentState!.validate()){
                          login();
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,

                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10,),


                    // FORGOT BUTTON

                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context)=>ForgotPassword()
                              )
                          );
                        },

                        child: Text("Forgot button"),

                      ),
                    ),



                    // DO NOT HAVE ACCOUNT SIGN UP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text("Do not have an account?"),

                        TextButton(

                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context)=>SignUpScreen()
                              )
                            );
                          },

                          child: Text("Sign up"),

                        )

                      ],
                    ),

                    SizedBox(height: 30,),


                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context)=>LoginWithPhoneNumber(),
                          )
                        );
                      },
                      child: Container(
                        height: 50,
                        // color: Colors.blue,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.black87
                          )
                        ),

                        child: Center(child: Text("Login with phone")),


                      ),
                    )






                  ],

                ),


              ),

            )



          ],

        ),

      ),


      ),
    );
  }
}