import 'package:flutter/material.dart';

TextField reusableTextField(String text, IconData icon, bool isPasswordType, TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color(0xFFFFFFFF).withOpacity(0.5),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
      /* -- Text and Icon -- */
      hintText: text,
      hintStyle: const TextStyle(
        fontSize: 18,
        color: Color(0xff30312f),
      ), // TextStyle
      suffixIcon: Icon(
        icon,
        size: 26,
        color: Colors.black54,
      ), // Icon
      /* -- Border Styling -- */
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(45.0),
        borderSide: const BorderSide(
          width: 2.0,
          color: Color(0xFFFF0000),
        ), // BorderSide
      ), // OutlineInputBorder
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(45.0),
        borderSide: const BorderSide(
          width: 2.0,
          color: Colors.grey,
        ), // BorderSide
      ), // OutlineInputBorder
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(45.0),
        borderSide: const BorderSide(
          width: 2.0,
          color: Colors.grey,
        ), // BorderSide
      ), // OutlineInputBorder
    ),
    keyboardType: isPasswordType ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}

Container functionButton(BuildContext context, String buttonText, Function onTap) {
  return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.width * 0.15,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 3,
          offset: Offset(0, 3),
        )
      ]),
      child: ElevatedButton(
          onPressed: () {
            onTap();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.black26;
                }
                return Colors.white.withOpacity(0.9);
              }),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
          child: Text(
            buttonText,
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
          )));
}