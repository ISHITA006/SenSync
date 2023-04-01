import 'package:flutter/material.dart';

class Breather extends StatelessWidget {
  final AnimationController breathingController;
  final String action;
  @override
  final Key key;

  const Breather({
    required this.breathingController,
    required this.action,
    required this.key, // Add the key parameter here
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 210.0 + 70 * breathingController.value,
          decoration: BoxDecoration(
            gradient: RadialGradient(colors: [
              Colors.greenAccent,
              Colors.greenAccent,
              Colors.greenAccent,
              Colors.greenAccent,
              Colors.black,
            ]),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          height: 160.0 + 50 * breathingController.value,
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            shape: BoxShape.circle,
          ),
          child: Center(child: Text(action)),
        ),
      ],
    );
  }
}