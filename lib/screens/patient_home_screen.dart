import 'package:ZenZone/get_location.dart';
import 'package:ZenZone/screens/breathing_screen.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ZenZone/reusable_widgets/gradient_button.dart';
import 'package:ZenZone/screens/visuals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ZenZone/Services/notifications.dart';
import 'dart:async';
import 'package:ZenZone/reusable_widgets/NavbarPatient.dart';
import '../reusable_widgets/emotion_card.dart';
import 'customize_videos_screen.dart';
import 'package:health/health.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({Key? key}) : super(key: key);
  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  dynamic userUid;
  List pages = [PatientHomeScreen(), CustomVideosScreen(), BreathingScreen()];
  String userName = "";
  int currentIndex = 0;
  
  void onTap(int index) {
    setState(() {
      var routeTo = pages[index];
      Navigator.push(context, MaterialPageRoute(builder: (context) => routeTo));
    });
  }
  late final NotificationService notificationService;

  @override
  void initState() {
  notificationService = NotificationService();
    listenToNotificationStream();
    notificationService.initializePlatformNotifications();
    get_location();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        String userUid = user.uid;
        DatabaseReference currUserRef = FirebaseDatabase.instance.ref('users/$userUid');
        currUserRef.onValue.listen((DatabaseEvent event) {
          Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
          setState(() {
            userName = data['name'];
          });
        });
      }
    });
    initPlatformState();
    super.initState();
  }

  void listenToNotificationStream() =>
    notificationService.behaviorSubject.listen((payload) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideosScreen()));
});

Future<dynamic> fetchData() async {
  HealthFactory health = HealthFactory();
  var types = [
    HealthDataType.HEART_RATE,
    HealthDataType.ELECTRODERMAL_ACTIVITY,
    HealthDataType.BODY_TEMPERATURE
  ];
  bool requested = await health.requestAuthorization(types);
  final now = DateTime.now();
  final from = now.subtract(const Duration(minutes: 15));
  List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(from, now, types);
  List EDA_data = [];
  List HR_data = [];
  List Temp_data = [];
  
  healthData.forEach((element) {
    if (element.type == HealthDataType.HEART_RATE){
      HR_data.add(element);
    }
    else if (element.type == HealthDataType.ELECTRODERMAL_ACTIVITY){
      EDA_data.add(element);
    }
    else if (element.type == HealthDataType.BODY_TEMPERATURE){
      Temp_data.add(element);
    }
});

List instances = [];

HR_data.forEach((HRpoint) {
  bool EDA_found = false;
  bool temp_found = false;
  List instance = [];
  EDA_data.forEach((EDApoint) { 
    if (EDA_found==false && EDApoint.dateFrom == HRpoint.dateFrom){
      instance.add(EDApoint.value);
      EDA_found = true;
    }
  });
  if (EDA_found==false){
    instance.add(0.0);
  }
  instance.add(HRpoint.value);
  Temp_data.forEach((Temppoint) { 
    if (temp_found==false && Temppoint.dateFrom == HRpoint.dateFrom){
      instance.add(Temppoint.value);
      temp_found = true;
    }
  });
  if (temp_found==false){
    instance.add(0.0);
  }
  instances.add(instance);
 });


print(instances);
var result = await http.post(Uri.parse('https://us-central1-signup-login-9679a.cloudfunctions.net/predictStress'),
    headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},    
    body: jsonEncode({"instances": [[0.552590,  32.37,  73.87]]}));
  print(result.body);

  var predictions = jsonDecode(result.body);
  var sensory_overload = false;
  ////////// Don't forget to change to 1
  if (predictions.contains(1)){
    sensory_overload = true;
   await notificationService.showLocalNotification(
                                id: 0,
                                title: "Check-In Time!",
                                body: "Hope you are feeling okay!",
                                payload: "You destressed, yay");
  }   
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        String userUid = user.uid;
        DatabaseReference currUserRef = FirebaseDatabase.instance.ref('users/$userUid');
        currUserRef.update({
          "sensory_overload": sensory_overload
        }).then((res) {});
      }
    });
  return healthData;
}

Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: true,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE
    ), (String taskId) async {  // <-- Event handler
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
      await fetchData();
      //get_location();
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {  // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    print('[BackgroundFetch] configure success: $status');  

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }
  

   @override
  Widget build(BuildContext context) {
    return 
    Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff86a191), Color(0xff9aaea0), Color(0xfff0efd8), Color(0xffffffff)])),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff86a191),
          foregroundColor: Color(0xff30312f),
          title: Text(
            "Hello ${userName}!",
          ),
        ),
        drawer: NavDrawerPatient(user_name: userName),
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
        backgroundColor: Colors.transparent,
        body: 
        SingleChildScrollView(
          child:
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 20),
              GradientButton(),
              SizedBox(height: 20),
              Container(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                child: Text(
                  'How do you feel today?',
                  style: TextStyle(
                    color: Color(0xff30312f),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //const SizedBox(
              //   height: 10,
              // ),
              Container(
                  height: 350,
                  width: 350,
                  child:
                    GridView.count(primary: false, padding: const EdgeInsets.all(20), crossAxisCount: 2, children: [
                    CarouselItem(imagePath: "assets/img/Bad Emoji.png", headingName: "Bad"),
                    CarouselItem(imagePath: "assets/img/Fine Emoji.png", headingName: "Fine"),
                    CarouselItem(imagePath: "assets/img/Well Emoji.png", headingName: "Well"),
                    CarouselItem(imagePath: "assets/img/Excellent Emoji.png", headingName: "Excellent"),
                  ])),
            ],
          ),
        ),
      ),
    ));
  }
}

