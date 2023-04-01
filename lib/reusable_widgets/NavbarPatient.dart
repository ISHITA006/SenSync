import 'package:ZenZone/screens/visuals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/customize_videos_screen.dart';
import '../screens/login_screen.dart';
import 'package:ZenZone/screens/money_scanner_screen.dart';

class NavDrawerPatient extends StatelessWidget {
  final String? user_name;
  NavDrawerPatient({Key? key, this.user_name}) : super(key: key);
  String userName = '';

  void getUserName() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        String userUid = user.uid;
        DatabaseReference currUserRef = FirebaseDatabase.instance.ref('users/$userUid');
        currUserRef.onValue.listen((DatabaseEvent event) {
          Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
          userName = data['name'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getUserName();
    return Drawer(
      backgroundColor: Color(0xff666666),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              " Hi, ${user_name}",
              style: TextStyle(color: Color(0xff30312f), fontSize: 30),
            ),
            decoration:
                BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/img/navbar.jpg'))),
          ),
          ListTile(
            textColor: Color(0xffeef4eb),
            iconColor: Color(0xffeef4eb),
            leading: Icon(Icons.library_music),
            title: Text('Visuals'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => VideosScreen()))},
          ),
          ListTile(
            textColor: Color(0xffeef4eb),
            iconColor: Color(0xffeef4eb),
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              })
            },
          ),
        ],
      ),
    );
  }
}