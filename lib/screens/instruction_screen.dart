import 'package:ZenZone/screens/patient_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:health/health.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({super.key});

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  @override
  Widget build(BuildContext context) {
    return 
    Container(
  height: MediaQuery.of(context).size.height,
  width: MediaQuery.of(context).size.width,
  decoration: const BoxDecoration(
    image: DecorationImage(
        image: AssetImage("assets/img/instructionPage.png"),
        fit: BoxFit.contain),
        color: Colors.white
  ), child:
   Scaffold(backgroundColor: Colors.transparent,
   body: Stack(
    
    children: [
      Align(alignment: AlignmentDirectional.bottomEnd, child: Padding(padding: EdgeInsets.all(30), child: ElevatedButton(onPressed: () async {
        HealthFactory health = HealthFactory();
        var types = [
        HealthDataType.HEART_RATE,
        HealthDataType.ELECTRODERMAL_ACTIVITY,
        HealthDataType.BODY_TEMPERATURE
      ];
      bool requested = await health.requestAuthorization(types);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PatientHomeScreen()));}, child: Text("Done"),)),
    )
     ])));
  }
}