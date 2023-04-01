import 'package:flutter/material.dart';
import '../screens/customize_videos_screen.dart';

class GradientButton extends StatelessWidget {
  
  GradientButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => CustomVideosScreen()))},
      child: Container(
        height: 150,
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white.withOpacity(0.3),
          // gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: [Color(0xff88a7a1).withOpacity(0.61), Color(0xffeaf0e9).withOpacity(0.41)])
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Container(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    'assets/img/customize video.png',
                    // fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Choose your",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff30312f)),
                ),
                Text(
                  "favourite audiovisuals!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff30312f)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}