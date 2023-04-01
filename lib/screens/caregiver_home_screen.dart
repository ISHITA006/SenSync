import 'package:any_link_preview/any_link_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ZenZone/screens/mood_analytics_screen.dart';
import 'package:ZenZone/screens/map_screen.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:background_fetch/background_fetch.dart';

import '../Services/notifications.dart';
import '../reusable_widgets/NavbarCaregiver.dart';



class CaregiverHomeScreen extends StatefulWidget {
  const CaregiverHomeScreen({Key? key}) : super(key: key);
  @override
  State<CaregiverHomeScreen> createState() => _CaregiverHomeScreenState();
}

class _CaregiverHomeScreenState extends State<CaregiverHomeScreen> {
  String userUid = "";
  String userName = "";
  String patientUid = "";
  String patientName = "";
  Map<String, int> moodChartData = {};
  int currentIndex = 0;
  List pages = [CaregiverHomeScreen(), GoogleMapScreen(), MoodAnalyticsScreen()];
  void onTap(int index) {
    setState(() {
      currentIndex = index;
      var routeTo = pages[index];
      Navigator.push(context, MaterialPageRoute(builder: (context) => routeTo));
    });
  }
  late final NotificationService notificationService;
  List artclesList = [
    "https://www.ivyrehab.com/news/sensory-overload-tips-for-helping-sensory-sensitive-kids/#:~:text=Give%20your%20child%20sensory%20toys,spend%20several%20afternoons%20in%20therapy",
    "https://www.autismspeaks.org/sensory-issues",
    "https://www.brainbalancecenters.com/blog/minimizing-sensory-overload-in-kids-with-special-needs",
    "https://otsimo.com/en/sensory-overload-autism/",
    "https://www.autismparentingmagazine.com/understanding-calming-sensory-overload/",
    "https://smiletutor.sg/autism-and-education-how-to-prevent-sensory-overload/",
"https://www.griffinot.com/asd-and-sensory-processing-disorder/",
"https://www.angelsense.com/blog/10-tips-de-escalating-child-special-needs-sensory-meltdown/",
"https://carmenbpingree.com/blog/sensory-overload-in-autism/",
"https://www.verywellhealth.com/autism-and-sensory-overload-259892",
"https://www.autism.org.uk/advice-and-guidance/topics/sensory-differences/sensory-differences/all-audiences",
"https://thespectrum.org.au/autism-strategy/autism-strategy-sensory/",
"https://www.healthline.com/health/sensory-overload",
"https://www.nhs.uk/conditions/autism/autism-and-everyday-life/help-for-day-to-day-life/",
"https://www.helpguide.org/articles/autism-learning-disabilities/helping-your-child-with-autism-thrive.htm",
"https://www.autismspeaks.org/blog/ways-parents-help-autistic-child",
"https://www.webmd.com/brain/autism/parenting-child-with-autism",
"https://kidshealth.org/en/parents/autism-checklist-bigkids.html",
"https://www.today.com/series/things-i-wish-i-knew/things-i-wish-i-d-known-about-having-child-autism-t110323",
"https://www.verywellhealth.com/how-to-calm-a-child-with-autism-4177696",
"https://ibcces.org/blog/2016/07/15/behavior-strategies/?https://ibcces.org/&keyword=&creative=643673812016&gclid=CjwKCAjw5pShBhB_EiwAvmnNV9UUyf7kkhcoZ6x2ACjNVhkOb2LXYrSwmUs1by7I15iGzs-52_-GVRoChNwQAvD_BwE"
  ];

  @override
  void initState() {
    notificationService = NotificationService();
    listenToNotificationStream();
    notificationService.initializePlatformNotifications();
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
    initPlatformState();
    super.initState();
  }

  
  void checkPatientStatus() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        String user_Uid = user.uid;
        DatabaseReference currUserRef = FirebaseDatabase.instance.ref('users/$user_Uid');
        currUserRef.onValue.listen((DatabaseEvent event) {
          print("getting patient info");
          Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
          var patientUid = data['linked_user'];
          DatabaseReference patientRef = FirebaseDatabase.instance.ref('users/$patientUid');
          patientRef.onValue.listen((DatabaseEvent event2) {
            Map<dynamic, dynamic> patient_data = event2.snapshot.value as Map<dynamic, dynamic>;
            var patient_Name = patient_data['name'];
            if (patient_data['sensory_overload'] == true) {
            print("detected overload");
            notificationService.showLocalNotification(
                                id: 0,
                                title: "Check-In Time!",
                                body: "${patient_Name} might be experiencing sensory overload!",
                                payload: "You destressed, yay").then((value) => null);
            }
          });
        });
      }
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
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
      checkPatientStatus(); 
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {  // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    print('[BackgroundFetch] configure success: $status');
    // setState(() {
    //   _status = status;
    // });
  
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void listenToNotificationStream() =>
    notificationService.behaviorSubject.listen((payload) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GoogleMapScreen()));
});

void _getMetadata(String url) async {
    bool _isValid = _getUrlValid(url);
    if (_isValid) {
      Metadata? _metadata = await AnyLinkPreview.getMetadata(
        link: url,
        cache: const Duration(days: 7),
        proxyUrl: "https://cors-anywhere.herokuapp.com/", // Needed for web app
      );
      debugPrint(_metadata?.title);
      debugPrint(_metadata?.desc);
    } else {
      debugPrint("URL is not valid");
    }
  }

bool _getUrlValid(String url) {
    bool _isUrlValid = AnyLinkPreview.isValidLink(
      url,
      protocols: ['http', 'https'],
      hostWhitelist: ['https://youtube.com/'],
      hostBlacklist: ['https://facebook.com/'],
    );
    return _isUrlValid;
  }

  Widget article(link){
    return Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 5), child: AnyLinkPreview(
                link: link,
                displayDirection: UIDirection.uiDirectionHorizontal,
                cache: const Duration(hours: 1),
                backgroundColor: Colors.grey[300],
                errorWidget: Container(
                  color: Colors.grey[300],
                  child: const Text('Oops!'),
                ),
                errorImage: "https://i.ytimg.com/vi/z8wrRRR7_qU/maxresdefault.jpg",
              ));
  }

   Widget desginedButton(imagePath, heading1, heading2, Function onPressed) {
    return InkWell(
      onTap: () => {onPressed()},
      child: Container(
        height: MediaQuery.of(context).size.width * 0.20,
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white.withOpacity(0.2),
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
                  height: 50,
                  width: 50,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  heading1,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff30312f)),
                ),
                Text(
                  heading2,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff30312f)),
                ),
              ],
            ),],
        ),
      ),
    );
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
          title: Text("Hello ${userName}!"),
        ),
        drawer: NavDrawerCaregiver(user_name: userName),
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
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  desginedButton("assets/img/location.png", "${patientName}'s", "location", (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleMapScreen()));
              }),
              Container(child: Column(children: [])),
              SizedBox(width: 10),
              desginedButton("assets/img/line-chart.png", "${patientName}'s", "mood log", () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MoodAnalyticsScreen()));
              })],),
              SizedBox(height: 20,),
              Text(
                "Some Useful Articles",
                style: TextStyle(color: Color(0xff30312f), fontSize: 25, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 20),
              Expanded(
                          child: ListView.builder(
                        itemCount: artclesList.length,
                        itemBuilder: (context, index) {
                          return  article(artclesList[index]);
                        },
                      )),
            ],
          ),
        ),
      ),
    );
  }
}