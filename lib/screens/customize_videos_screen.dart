import 'package:ZenZone/screens/breathing_screen.dart';
import 'package:ZenZone/screens/patient_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomVideosScreen extends StatefulWidget {
  const CustomVideosScreen({Key? key}) : super(key: key);
  @override
  State<CustomVideosScreen> createState() => _CustomVideosScreenState();
}

class _CustomVideosScreenState extends State<CustomVideosScreen> {
  dynamic userUid;
  List fav_videos = [];
  late YoutubePlayerController _controller;
  int _currentSongIndex = 0;
  final _songNameList = [
    "Nature Sounds",
    "Plasma Ball",
    "Bubble Tube",
    "Fibre Optic",
    "Lava Lamp",
    "Floating Bubbles",
    "Kaleidoscope",
    "Moving Dots",
    "Magic Meltdown",
    "Soothing Therapy"
    ];
  final List<String> _songsList = [
    'https://youtu.be/hlWiI4xVXKY',
    'https://youtu.be/Zk3B16rt8To',
    'https://youtu.be/BTrfbUMtEUk',
    'https://youtu.be/CMsZbn_iyNs',
    'https://youtu.be/14XxolEJloE',
    'https://youtu.be/4hTbiesJWbE',
    'https://youtu.be/LBN7a0AQ6Pw',
    'https://youtu.be/FOACFYTlFTs',
    'https://youtu.be/9rJbmCvI19I',
    'https://youtu.be/vKkDUC1tfmw',
  ];
  
  int currentIndex = 1;
  List pages = [PatientHomeScreen(), CustomVideosScreen(), BreathingScreen()];
  void onTap(int index) {
    setState(() {
      var routeTo = pages[index];
      Navigator.push(context, MaterialPageRoute(builder: (context) => routeTo));
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(_songsList[_currentSongIndex])!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        userUid = user.uid;
        DatabaseReference ref = FirebaseDatabase.instance.ref('users/$userUid/fav_videos');
        ref.onValue.listen((DatabaseEvent event) {
          if (event.snapshot.value != null) {
            Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
            var videos = data['videos'];
            videos.forEach((key) {
              if (!fav_videos.contains(key)) {
                fav_videos.add(key);
              }
            });
            setState(() {
              fav_videos;
            });
          }
        });
      }
    });
  }

  void previewVideo(int videoNum) {
    setState(() {
      _controller.play();
      _currentSongIndex = videoNum;
      _controller.load(YoutubePlayer.convertUrlToId(_songsList[_currentSongIndex])!);
      _controller.play();
    });
  }

  void toggleFav(String video) {
    if (fav_videos.contains(video)) {
      fav_videos.remove(video);
      setState(() {
        fav_videos;
      });
    } else {
      fav_videos.add(video);
      setState(() {
        fav_videos;
      });
    }
    updateDB(fav_videos);
  }

  void updateDB(fav_videos) {
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/$userUid/fav_videos');
    ref.set({"videos": fav_videos}).then((res) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CustomVideosScreen()));
    });
  }

  bool isFav(String video) {
    if (fav_videos.contains(video)) {
      return true;
    }
    return false;
  }

  Widget VideoTile(index, name) {
    return InkWell(
      onTap: () => {previewVideo(index)},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.12,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 3),
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white.withOpacity(0.7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Container(
                    height: 40,
                    width: 40,
                    child: Image.asset(
                      'assets/img/video icon.png',
                      // fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Text(
                name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff30312f)),
              ),
              IconButton(
                  onPressed: () {
                    toggleFav(_songsList[index]);
                  },
                  icon: isFav(_songsList[index])
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                        )
                      : const Icon(
                          Icons.favorite,
                        )),
            ],
          ),
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
          title: Text("Select favourite audiovisuals"),
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
        body: Column(children: [
          Container(
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
          ),
          Expanded(
                          child: ListView.builder(
                        itemCount: _songsList.length,
                        itemBuilder: (context, index) {
                          return  VideoTile(index, _songNameList[index]);
                        },
                      )),
        ]),
      ),
    );
  }
}