import 'package:firebase/Ui/posts/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Utils/utils.dart';

class VerifyCode extends StatefulWidget {
  final String verificationId;

  const VerifyCode({super.key, required this.verificationId});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final verificationcodecontroller = TextEditingController();
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
            keyboardType: TextInputType.number,
            controller: verificationcodecontroller,
            decoration: InputDecoration(
                hintText: "6 digits code"
            ),
          ),


          SizedBox(
            height: 50,
          ),

          InkWell(
            onTap: loading ? null : ()async{


              setState(() {
                loading = true;
              });

              final credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: verificationcodecontroller.text.toString(),
              );

              try{
                await auth.signInWithCredential(credential);
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => PostScreen(),
                    )
                );

              }catch(e){
                setState(() {
                loading = false;
              });
                Utils().toastMessages(e.toString());
              }



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


              child: Center(
                child: loading
                    ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,

                  ),
                )

                    : Text(
                  "Verify",
                  style: TextStyle(color: Colors.white),

                ),
              ),


            ),
          ),
        ],
      ),
    ),
    );
  }
}
