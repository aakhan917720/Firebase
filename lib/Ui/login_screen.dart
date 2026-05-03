import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailcontroller = TextEditingController();
  final passwordcontoller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return  Scaffold(

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
            color: Colors.limeAccent,

            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [


                  TextFormField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      hintText: "Email",
                      icon: Icon(Icons.alternate_email),

                    ),
                    cursorHeight: 15,
                    cursorColor: Colors.green,

                  ),


                  TextFormField(
                    controller: passwordcontoller,
                    decoration: InputDecoration(
                      hintText: "Password",
                      icon: Icon(Icons.lock_open),
                    ),
                    cursorHeight: 15,
                    cursorColor: Colors.green,
                  ),


                  SizedBox(height: 20,),


                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context)=>LoginScreen()
                        )
                      );
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xff1aa260),
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
                  )





                ],

              ),


            ),

          )



        ],

      ),

    ),


    );
  }
}




















