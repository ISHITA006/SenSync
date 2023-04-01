import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'caregiver_home_screen.dart';
import 'mood_analytics_screen.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  String userUid = "";
  String userName = "";
  String patientUid = "";
  String patientName = "";
  int currentIndex = 1;
  List pages = [CaregiverHomeScreen(), GoogleMapScreen(), MoodAnalyticsScreen()];
  double? latitude;
  double? longitude;
  void onTap(int index) {
    setState(() {
      var routeTo = pages[index];
      Navigator.push(context, MaterialPageRoute(builder: (context) => routeTo));
    });
  }

    @override
  void initState() {
    getPatientLocation();
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
            if (patient_data['sensory_overload'] == true) {
              // NotificationService().showNotification(title: 'Check-In Time', body: '${patient_Name} might not be doing well!');
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

  @override
  void dispose() {
    super.dispose();
  }

  void getPatientLocation(){
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
            var patient_location = patient_data['location'];
            var lat = patient_location['latitude'];
            var long = patient_location['longitude'];
            
            setState(() {
              latitude = lat;
              longitude = long;

        markers.add(
          Marker(
            markerId: MarkerId('current_location'),
            position: LatLng(lat, long),
            infoWindow: InfoWindow(
              title: 'Patient is here',
              snippet: 'Last seen location',
            ),
          ),
        );
      });

            
            });
        });
      }
    });
  }

  void onMapcreated(GoogleMapController controller) {
    setState(() {
      markers.add(Marker(
        markerId: MarkerId('1'),
        position: LatLng(latitude!, longitude!),
        infoWindow: InfoWindow(
          title: 'Patient is here',
          snippet: 'Their last seen location',
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Color(0xff86a191),
          foregroundColor: Color(0xff30312f),
          title: Text(" ${patientName}'s Location"),
        ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTap,
          currentIndex: currentIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey.withOpacity(0.5),
          showUnselectedLabels: false,
          showSelectedLabels: false,
          elevation: 0,
          items: [
            BottomNavigationBarItem(label: "Home", icon: Icon(Icons.apps)),
            BottomNavigationBarItem(label: "Map", icon: Icon(Icons.map)),
            BottomNavigationBarItem(label: "Analytics", icon: Icon(Icons.analytics)),
          ],
        ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(latitude!, longitude!),
            zoom: 10,
          ),
          mapToolbarEnabled: true,
          buildingsEnabled: false,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          markers: markers,
          onMapCreated: onMapcreated,
          myLocationEnabled: true,
          zoomControlsEnabled: true,
        ),
      ),
    );
  }
}