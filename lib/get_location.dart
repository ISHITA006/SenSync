import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';

void get_location() async {
  final PermissionStatus permission = await _getLocationPermission();
  if (permission == PermissionStatus.granted) {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
        print(position.latitude);
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        String userUid = user.uid;
        DatabaseReference currUserRef = FirebaseDatabase.instance.ref('users/$userUid');
        currUserRef.update({
          "location": {"latitude": position.latitude, "longitude": position.longitude}
        }).then((res) {});
        }
       });
  }
 }

 Future<PermissionStatus> _getLocationPermission() async {
  final PermissionStatus permission = await LocationPermissions()
      .checkPermissionStatus(level: LocationPermissionLevel.location);

  if (permission != PermissionStatus.granted) {
    final PermissionStatus permissionStatus = await LocationPermissions()
        .requestPermissions(
            permissionLevel: LocationPermissionLevel.location);

    return permissionStatus;
  } else {
    return permission;
  }
 }