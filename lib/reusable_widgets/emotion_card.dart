import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class CarouselItem extends StatelessWidget {
  final String? imagePath;
  final String? headingName;
  CarouselItem({Key? key, this.imagePath, this.headingName}) : super(key: key);

  void pushEmotionToDB(String emotion) {
    dynamic userUid;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        userUid = user.uid;
        DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
        String dateStr = dateFormat.format(DateTime.now());
        DatabaseReference ref = FirebaseDatabase.instance.ref('users/$userUid/emotions/$dateStr');
        ref.set({"Emotion": emotion}).then((res) {});
      }
    });
  }

  void onTapEmotion(BuildContext context) {
    if (headingName == "Bad") {
      pushEmotionToDB("Bad");
    } else if (headingName == "Fine") {
      pushEmotionToDB("Fine");
    } else if (headingName == "Well") {
      pushEmotionToDB("Well");
    } else if (headingName == "Excellent") {
      pushEmotionToDB("Excellent");
    }
    return;
  }

  void onTap(context, mood) {
    onTapEmotion(context);
    String snackbarText = "Mood changed to ${mood}";
    final snackBar = SnackBar(
      content: Text(snackbarText),
      backgroundColor: (Colors.blueGrey),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 4, 6, 6),
      child: InkWell(
        onTap: () => {onTap(context, headingName)},
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 3),
                )
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Opacity(
                  opacity: 0.8,
                  child: Image.asset(
                    this.imagePath as String,
                    height: 60.0,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(headingName as String,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff30312f)))
            ],
          ),
        ),
      ),
    );
  }
}