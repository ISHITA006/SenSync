import 'package:ZenZone/screens/instruction_screen.dart';
import 'package:ZenZone/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ZenZone/reusable_widgets/reusable_widget.dart';
import 'package:ZenZone/screens/caregiver_home_screen.dart';
import 'package:ZenZone/screens/patient_home_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _patientEmailTextController = TextEditingController();
  var _currentSelectedValue = 'Patient';
  var _userOptions = ['Patient', 'Caregiver'];

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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color(0xff86a191),
          foregroundColor: Color(0xff30312f),
          title: const Text(
            "Sign Up",
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  "Enter account details",
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xff30312f),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              reusableTextField("Enter Name", Icons.person_outline, false, _userNameTextController),
              SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Email ID", Icons.alternate_email_outlined, false, _emailTextController),
              SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Password", Icons.lock, true, _passwordTextController),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  "Select user type",
                  style: TextStyle(fontSize: 22, color: Color(0xff30312f)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF).withOpacity(0.5),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
                      /* -- Text and Icon -- */
                      hintText: "Please select user type",
                      hintStyle: const TextStyle(
                        fontSize: 18,
                        color: Color(0xff30312f),
                      ), // TextStyle
                      // suffixIcon: Icon(
                      //   Icons.arrow_drop_down,
                      //   size: 26,
                      //   color: Colors.transparent,
                      // ), // Icon
                      /* -- Border Styling -- */
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(45.0),
                        borderSide: const BorderSide(
                          width: 2.0,
                          color: Color(0xFFFF0000),
                        ), // BorderSide
                      ), // OutlineInputBorder
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(45.0),
                        borderSide: const BorderSide(
                          width: 2.0,
                          color: Colors.grey,
                        ), // BorderSide
                      ), // OutlineInputBorder
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(45.0),
                        borderSide: const BorderSide(
                          width: 2.0,
                          color: Colors.grey,
                        ), // BorderSide
                      ), // OutlineInputBorder
                    ),
                    isEmpty: _currentSelectedValue == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _currentSelectedValue,
                        isDense: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            _currentSelectedValue = newValue!;
                            state.didChange(newValue);
                          });
                        },
                        items: _userOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              _currentSelectedValue == 'Caregiver'
                  ? Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        reusableTextField("Enter Patient's Email ID", Icons.alternate_email_outlined, false,
                            _patientEmailTextController),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 50,
                    ),
              functionButton(context, "SIGN UP", () {
                String patientUid = '';
                if (_currentSelectedValue == 'Caregiver') {
                  DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
                  usersRef.onValue.listen((DatabaseEvent event) {
                    Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
                    data.forEach((key, val) {
                      if (val['email'] == _patientEmailTextController.text) {
                        patientUid = key;
                      }
                    });
                    if (patientUid == '') {
                      String snackbarText = "Patient does not exist!";
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
                    } else {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: _emailTextController.text, password: _passwordTextController.text)
                          .then(
                        (value) {
                          // if user has been created successfully
                          if (value.user != null) {
                            DatabaseReference ref = FirebaseDatabase.instance.ref('users/${value.user!.uid}');
                            // if user type == caregiver - check if corr child exists in DB else show error
                            DatabaseReference patientRef = FirebaseDatabase.instance.ref('users/$patientUid');
                            patientRef.update({"linked_user": value.user!.uid}).then((res) {});
                            ref.set({
                              "email": _emailTextController.text,
                              "name": _userNameTextController.text,
                              "user_type": _currentSelectedValue,
                              "linked_user": patientUid
                            });
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CaregiverHomeScreen()));
                          }
                        },
                      ).onError((error, stackTrace) {
                        print("Error ${error.toString()}");
                        String snackbarText = error.toString();
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
                    }
                  });
                } else {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text, password: _passwordTextController.text)
                      .then(
                    (value) {
                      // if user has been created successfully
                      if (value.user != null) {
                        DatabaseReference ref = FirebaseDatabase.instance.ref('users/${value.user!.uid}');
                        // else if user type == patient
                        // push all associated data to realtime database
                        ref.set({
                          "email": _emailTextController.text,
                          "name": _userNameTextController.text,
                          "user_type": _currentSelectedValue
                        }).then((res) {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InstructionScreen()));});
                      }
                    },
                  ).onError((error, stackTrace) {
                    String errorMsg = '';
                    print("Error ${error.toString()}");
                    if (error.toString() ==
                        "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
                      errorMsg = "The email address is already in use by another account. Try logging in instead.";
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
                }
              }),
              SizedBox(
                height: 15,
              ),
              LoginOption(),
            ],
          ),
        ))),
      ),
    );
  }

  Row LoginOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?", style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          child: const Text(
            " Log In",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}