import 'package:ZenZone/widgets/breather_error.dart';
import 'package:ZenZone/widgets/three_stage.dart';
import 'package:ZenZone/widgets/two_stage.dart';
import 'package:flutter/material.dart'; 

class Breathing extends StatelessWidget {
  final String pattern;

  const Breathing({Key? key, required this.pattern}) : super(key: key);

     

  @override
  Widget build(BuildContext context) {
    StatefulWidget breather;

    switch (pattern) {
      case '7/11 Breathing':
        breather = TwoStage();
        break;
      case '4-7-8 Breathing':
        breather = ThreeStage();
        break;
      default:
        breather = TwoStage();
        break;
    }

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff86a191), Color(0xff9aaea0), Color(0xfff0efd8), Color(0xffffffff)])),
      child:Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Color(0xff86a191),
          foregroundColor: Color(0xff30312f),
          title: Text(
            pattern
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    breather,
                  ],
                ),
              ),
            ),
          ],
        )));
  }
}