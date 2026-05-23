import 'package:firebase/Ui/auth/verify_code.dart';
import 'package:firebase/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {

  final phoneNumberController = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.blue,
      ),body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
        children: [

          SizedBox(height: 50,),

          TextFormField(
            controller: phoneNumberController,
            decoration: InputDecoration(
              hintText: "+1 234 5678 934"
            ),
          ),


          SizedBox(
            height: 50,
          ),

          InkWell(
            onTap: (){
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context)=>VerifyCode(),
              //   )
              // );

              auth.verifyPhoneNumber(
                phoneNumber: phoneNumberController.text,
                  verificationCompleted: (_){

                  },
                  verificationFailed: (e){
                  Utils().toastMessages(e.toString());
                  },
                  codeSent: (String verificationId, int? token){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context)=>VerifyCode(verificationId: verificationId,),
                    )
                  );
                  },
                  codeAutoRetrievalTimeout: (e){
                  Utils().toastMessages(e.toString());
                  }
              );

            },
            child: Container(

              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.black87
                ),
                color: Colors.blue,
              ),

              child: Center(child: Text("Login")),

            ),
          )






        ],
            ),
      ),
    );
  }
}
