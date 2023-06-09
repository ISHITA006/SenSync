import 'package:ZenZone/widgets/info_item.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 30.0,
          horizontal: 24.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoItem(
              type: "7/11 Breathing",
              details: "This breathing exercise can help you to reduce stress in the moment. " +
                  "If you practice it regularly, you may also find that it helps you feel calmer generally. " +
                  "The more you practice, the more effective this technique becomes.",
              url:
                  "https://thewellbeingthesis.org.uk/foundations-for-success/stress/711-breathing/", key: UniqueKey(),
            ),
            InfoItem(
              type: "4-7-8 Breathing",
              details: "The 4-7-8 technique forces the mind and body to focus on regulatingthe breath, rather than replaying your worries when you lie down at night. Proponents claim it can soothe a racing heart or calm frazzled nerves. Dr. Weil has even described it as a “natural tranquilizer for the nervous system.”",
              url: "https://www.healthline.com/health/4-7-8-breathing", key: UniqueKey(),
            ),
          ],
        ),
      ),
    );
  }
}