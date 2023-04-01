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
import '../reusable_widgets/time_series_chart.dart';
import 'map_screen.dart';

class MoodAnalyticsScreen extends StatefulWidget {
  const MoodAnalyticsScreen({super.key});
  @override
  State<MoodAnalyticsScreen> createState() => _MoodAnalyticsScreenState();
}

class _MoodAnalyticsScreenState extends State<MoodAnalyticsScreen> {
  String patientName = "";
  String userUid = "";
  String userName = "";
  Map<String, int> moodChartData = {};
  int currentIndex = 2;
  List pages = [CaregiverHomeScreen(), GoogleMapScreen(), MoodAnalyticsScreen()];
  void onTap(int index) {
    setState(() {
      var routeTo = pages[index];
      Navigator.push(context, MaterialPageRoute(builder: (context) => routeTo));
    });
  }

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        String user_Uid = user.uid;
        DatabaseReference currUserRef = FirebaseDatabase.instance.ref('users/$user_Uid');
        currUserRef.onValue.listen((DatabaseEvent event) {
          Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
          var patientUid = data['linked_user'];
          DatabaseReference patientRef = FirebaseDatabase.instance.ref('users/$patientUid');
          patientRef.onValue.listen((DatabaseEvent event2) {
            Map<dynamic, dynamic> patient_data = event2.snapshot.value as Map<dynamic, dynamic>;
            var patient_Name = patient_data['name'];
            if (patient_data['emotions']!=null){
              getPatientMoodData(patient_data['emotions']);
            }
            setState(() {
              patientName = patient_Name;
            });
          });
          setState(() {
            userUid = user_Uid;
            userName = data['name'];
            patientUid = data['linked_user'];
          });
        });
      }
    });
    // initPlatformState();

    super.initState();
  }

  void getPatientMoodData(emotions) {
    List moodDate = [];
    emotions.forEach((key, value) {
      moodDate.add(key);
    });
    moodDate.sort((a, b) => a.compareTo(b));
    moodDate.forEach((date) {
      String emotion = emotions[date]['Emotion'];
      int emotion_num = 0;
      if (emotion == "Bad") {
        emotion_num = 1;
      } else if (emotion == "Fine") {
        emotion_num = 2;
      } else if (emotion == "Well") {
        emotion_num = 3;
      } else if (emotion == "Excellent") {
        emotion_num = 4;
      }
      moodChartData[date] = emotion_num;
    });

    setState(() {
      moodChartData;
    });
  }

  Widget legendItem(number, imagePath, headingName){
    return  Padding(padding: EdgeInsets.fromLTRB(0,5,0,5),
    child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: MediaQuery.of(context).size.width * 0.1),
            Text(
                  number,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff30312f)),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  height: 30,
                  width: 30,
                  child: Image.asset(
                    imagePath,
                    // fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.1),
            Text(
                  headingName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff30312f)),
                ),   
          ],
        ));
  }

  Widget legend(){
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height:10),
          legendItem( "1:", "assets/img/Bad Emoji.png","Bad"),
          legendItem("2:", "assets/img/Fine Emoji.png", "Fine"),
          legendItem("3","assets/img/Well Emoji.png","Well"),
          legendItem("4:", "assets/img/Excellent Emoji.png", "Excellent"),
          SizedBox(height:10)
        ],);
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
        appBar: AppBar(
          backgroundColor: Color(0xff86a191),
          foregroundColor: Color(0xff30312f),
          title: Text(
            "${patientName}'s mood analytics",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTap,
          currentIndex: currentIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey.withOpacity(0.5),
          showUnselectedLabels: true,
          showSelectedLabels: true,
          elevation: 0,
          items: [
            BottomNavigationBarItem(label: "Home", icon: Icon(Icons.apps)),
            BottomNavigationBarItem(label: "Map", icon: Icon(Icons.map)),
            BottomNavigationBarItem(label: "Analytics", icon: Icon(Icons.analytics)),
          ],
        ),
        body: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
      width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white.withOpacity(0.2),
        ),
        child: legend()),
        SizedBox(height: 20,),
              Center(child: Container(
                  color: Colors.white.withOpacity(0.2),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height:  MediaQuery.of(context).size.height * 0.4,
                  child: SimpleTimeSeriesChart(
                    moodChartData: moodChartData,
                  ))),
    
        
          ]),
     )
         );
  }
}