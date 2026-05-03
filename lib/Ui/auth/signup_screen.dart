import 'package:firebase/Ui/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final emailcontroller = TextEditingController();
  final passwordcontoller = TextEditingController();
  final _formkey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return false;
      },

      child: Scaffold(

        appBar: AppBar(
          // automaticallyImplyLeading: true,
          elevation: 90,

          title: Text("Sign Up", style: TextStyle(color: Colors.white),),
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


                    InkWell(
                      onTap: (){
                        if(_formkey.currentState!.validate()){

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
                            "Sign Up",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text("I have an account?"),

                        TextButton(

                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context)=>LoginScreen()
                                )
                            );
                          },

                          child: Text("Login"),

                        )

                      ],
                    ),


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




















