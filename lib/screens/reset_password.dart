import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:ZenZone/reusable_widgets/reusable_widget.dart';
import 'package:ZenZone/screens/login_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ZenZone/reusable_widgets/reusable_widget.dart';
import 'package:ZenZone/screens/patient_home_screen.dart';
import 'package:ZenZone/screens/caregiver_home_screen.dart';
import 'package:ZenZone/screens/signup_screen.dart';
import 'package:firebase_database/firebase_database.dart';

import '../reusable_widgets/reusable_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff86a191), Color(0xff9aaea0), Color(0xfff0efd8), Color(0xffffffff)])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color(0xff86a191),
          foregroundColor: Color(0xff30312f),
          title: const Text(
            "Forgot Password?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          //width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  reusableTextField("Enter Email ID", Icons.alternate_email_outlined, false, _emailTextController),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  functionButton(context, "SEND RESET EMAIL", () {
                    FirebaseAuth.instance.sendPasswordResetEmail(email: _emailTextController.text).then((value) {
                      String snackbarText = "Password reset link has been sent to your email!";
                      final snackBar = SnackBar(
                        content: Text(
                          snackbarText,
                          style: TextStyle(color: Color(0xff30312f)),
                        ),
                        backgroundColor: (Colors.green[300]),
                        action: SnackBarAction(
                          label: 'OK',
                          textColor: Color(0xff30312f),
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }).onError((error, stackTrace) {
                      print("Error ${error.toString()}");
                      String errorMsg = '';
                      if (error.toString() == "[firebase_auth/unknown] Given String is empty or null") {
                        errorMsg = "Enter a valid email!";
                      } else if (error.toString() ==
                          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
                        errorMsg = "No user found with this email!";
                      }
                      String snackbarText = errorMsg;
                      final snackBar = SnackBar(
                        content: Text(
                          snackbarText,
                          style: TextStyle(color: Color(0xff30312f)),
                        ),
                        backgroundColor: (Colors.red[200]),
                        action: SnackBarAction(
                          label: 'OK',
                          textColor: Color(0xff30312f),
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  }),
                  SizedBox(
                    height: 15,
                  ),
                  LoginOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row LoginOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          child: const Text(
            "Go back to Log In",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}