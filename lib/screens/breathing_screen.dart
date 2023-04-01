import 'package:ZenZone/screens/customize_videos_screen.dart';
import 'package:ZenZone/screens/patient_home_screen.dart';
import 'package:flutter/material.dart';
import 'breathing.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  int currentIndex = 2;
  List pages = [PatientHomeScreen(), CustomVideosScreen(), BreathingScreen()];
  void onTap(int index) {
    setState(() {
      var routeTo = pages[index];
      Navigator.push(context, MaterialPageRoute(builder: (context) => routeTo));
    });
  }

  Widget desginedButton(BuildContext context, imagePath, heading, Function onPressed) {
    return InkWell(
      onTap: () => {onPressed()},
      child: Container(
        height: 150,
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)), color: Colors.white.withOpacity(0.6),
          boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 3),
                )
              ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Container(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    imagePath,
                    // fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
                 heading,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xff30312f)),
                )],
        ),
      ),
    );
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
            "Breathing Exercises",
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
            BottomNavigationBarItem(label: "Visual", icon: Icon(Icons.movie)),
            BottomNavigationBarItem(label: "Breathing", icon: Icon(Icons.wb_twilight))
          ],
        ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  desginedButton(context, "assets/img/breathing icon.png", "7/11 Pattern", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return Breathing(pattern: '7/11 Breathing', key: UniqueKey(),);
                      }));
                  }
                      ),
                  
                  SizedBox(
                    height: 30.0,
                  ),
                  desginedButton(context, "assets/img/breathing icon2.png", "4-7-8 Pattern", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return Breathing(pattern: '4-7-8 Breathing', key: UniqueKey(),);
                      }));
                  }
                      ),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}