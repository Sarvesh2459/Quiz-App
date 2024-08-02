import 'package:flutter/material.dart';

Widget VioletButton(BuildContext context, String label) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 18.0),
    decoration: BoxDecoration(
      color: Colors.deepPurple[800],
      borderRadius: BorderRadius.circular(30),
    ),
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width - 48,
    child: Text(
      label,
      style: TextStyle(color: Colors.white, fontSize: 20),
    ),
  );
}
