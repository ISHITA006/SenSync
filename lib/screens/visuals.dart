import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:ZenZone/reusable_widgets/reusable_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({Key? key}) : super(key: key);
  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  dynamic userUid;
  late YoutubePlayerController _controller;
  int _currentSongIndex = 0;
  String _songToPlay = 'https://youtu.be/9rJbmCvI19I';

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        userUid = user.uid;
        DatabaseReference ref = FirebaseDatabase.instance.ref('users/$userUid/fav_videos');
        ref.onValue.listen((DatabaseEvent event) {
          if (event.snapshot.value != null) {
            Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
            var videos = data['videos'];
            _currentSongIndex = Random().nextInt(videos.length); 
            _songToPlay = videos[_currentSongIndex];
            setState(() {
               _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(_songToPlay)!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
            });
           
          }
          else{
            _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId('https://youtu.be/9rJbmCvI19I')!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
          }
        });
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xff86a191),
          foregroundColor: Color(0xff30312f),
        title: Text("Video Player"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Container(
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          ),
        ),
        Container(height: 70,child: Text(""))
     ]),
    );
  }
}

