import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ZenZone/reusable_widgets/reusable_widget.dart';
import 'package:ZenZone/screens/patient_home_screen.dart';
import 'package:ZenZone/screens/caregiver_home_screen.dart';
import 'package:ZenZone/screens/signup_screen.dart';
import 'package:ZenZone/screens/reset_password.dart';
import 'package:firebase_database/firebase_database.dart';

import '../reusable_widgets/reusable_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  dynamic userUid;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        userUid = user.uid;
        DatabaseReference currUserRef = FirebaseDatabase.instance.ref('users/$userUid');
        currUserRef.onValue.listen((DatabaseEvent event) {
          Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
          if (data['user_type'] == 'Caregiver') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CaregiverHomeScreen()));
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PatientHomeScreen()));
          }
        });
      }
    });
    super.initState();
  }

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
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  reusableTextField("Enter Password", Icons.lock, true, _passwordTextController),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  functionButton(context, "LOG IN", () {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailTextController.text, password: _passwordTextController.text)
                        .then((value) {
                      if (value.user != null) {
                        DatabaseReference currUserRef = FirebaseDatabase.instance.ref('users/${value.user!.uid}');
                        currUserRef.onValue.listen((DatabaseEvent event) {
                          Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
                          if (data['user_type'] == 'Caregiver') {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CaregiverHomeScreen()));
                          } else {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PatientHomeScreen()));
                          }
                        });
                      }
                    }).onError((error, stackTrace) {
                      print("Error ${error.toString()}");
                      String errorMsg = '';
                      print("Error ${error.toString()}");
                      if (error.toString() ==
                          "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
                        errorMsg = "Incorrect password!";
                      } else if (error.toString() ==
                          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
                        errorMsg = "User not found!";
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
                  signUpOption(),
                  SizedBox(
                    height: 15,
                  ),
                  ForgotPasswordOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?", style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Row ForgotPasswordOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Forgot password? ", style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
          },
          child: const Text(
            " Reset",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}