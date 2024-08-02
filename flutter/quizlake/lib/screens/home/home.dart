import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizlake/models/user.dart';
import 'package:quizlake/screens/home/Display_playerSide.dart';
import 'package:quizlake/screens/home/create_quiz.dart';
import 'package:quizlake/screens/home/quiz_data_display.dart';
import 'package:quizlake/screens/player_displayAdmin.dart';
import 'package:quizlake/service/auth.dart';
import 'package:quizlake/service/database.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // const Home({super.key});
  final _formkey = GlobalKey<FormState>();

  final AuthService _authInstance = AuthService();

  DatabaseService _databaseInstance = new DatabaseService();

  String roomID = "";

  String error = "";

  JoinRoom(String roomID, BuildContext context, VoidCallback OnSuccess) async {
    final player = FirebaseAuth.instance.currentUser!.uid;
    Map<String, String> userData = {"player": player};
    dynamic join_room = await _databaseInstance.JoinRoom(userData, roomID);
    OnSuccess.call();
  }

  Stream Roomstream = Stream.empty();
  Widget RoomList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
          stream: Roomstream,
          builder: ((context, AsyncSnapshot snapshot) {
            return snapshot.data == null
                ? Container()
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      return RoomTile(
                        RoomID:
                            snapshot.data!.docs.elementAt(index).get("roomID"),
                      );
                    }));
          })),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _databaseInstance.getRoomData().then((value) {
      setState(() {
        Roomstream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.deepPurple[800],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            label: Text('Logout'),
            onPressed: () async {
              await _authInstance.signingOut();
            },
            icon: Icon(Icons.person),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateQuiz()));
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              child: Center(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  key: _formkey,
                  child: Form(
                      child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Room ID is INVALID" : null,
                        decoration: InputDecoration(hintText: "Room ID"),
                        onChanged: (value) {
                          setState(() {
                            roomID = value;
                          });
                        },
                      ),
                      SizedBox(height: 12.0),
                      SizedBox(
                        height: 36.0,
                        width: 100,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo[900]),
                            onPressed: (() {
                              // if (_formkey.currentState!.validate()) {
                              JoinRoom(roomID, context, () {
                                if (!mounted) return;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PlayerSideDisplay(RoomID: roomID)));
                              });
                              // }
                              ;
                            }),
                            // if (_formkey.currentState!.validate()) {

                            // if (join_room == null) {
                            //   setState(() => error = "Room invalid");
                            // }

                            child: Text(
                              'Join Room',
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      SizedBox(height: 12.0),
                      Text(error,
                          style: TextStyle(
                            color: Colors.red,
                          )),
                    ],
                  )),
                ),
              ),
            ),
            Container(child: RoomList())
          ],
        ),
      ),
    );
  }
}

class RoomTile extends StatelessWidget {
  // const RoomTile({super.key});
  final String RoomID;
  RoomTile({required this.RoomID});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DisplayPlayers(RoomID)));
      }),
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 3)),
        margin: EdgeInsets.only(bottom: 12),
        height: 100,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "https://icons.veryicon.com/png/o/system/remote-cost-control/room-3.png",
                width: MediaQuery.of(context).size.width - 48,
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Room ID :$RoomID",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
