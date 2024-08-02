import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:quizlake/service/database.dart';
import 'package:random_string/random_string.dart';

class RoomID extends StatefulWidget {
  // const RoomID({super.key});
  final String roomID;
  RoomID(this.roomID);

  @override
  State<RoomID> createState() => _RoomIDState();
}

class _RoomIDState extends State<RoomID> {
  DatabaseService databaseInstance = new DatabaseService();

  List<String> Userlist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 350.0, horizontal: 30.0),
            child: Column(children: <Widget>[
              Text(
                "Your Room ID is ${widget.roomID} ",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Share this ID for your people to join the room",
                  style: TextStyle(fontSize: 16))
            ]),
          ),
        ),
      ),
    );
  }
}
