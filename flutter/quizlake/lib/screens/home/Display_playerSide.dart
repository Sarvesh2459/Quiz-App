import 'package:flutter/material.dart';
import 'package:quizlake/service/database.dart';

class PlayerSideDisplay extends StatefulWidget {
  // const PlayerSideDisplay({super.key});
  final String RoomID;
  PlayerSideDisplay({required this.RoomID});

  @override
  State<PlayerSideDisplay> createState() => _PlayerSideDisplayState();
}

class _PlayerSideDisplayState extends State<PlayerSideDisplay> {
  DatabaseService _databaseInstance = new DatabaseService();

  Stream playerstream = Stream.empty();
  Widget playerList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
          stream: playerstream,
          builder: ((context, AsyncSnapshot snapshot) {
            return snapshot.data == null
                ? Container()
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      return PlayerTile(
                          playerID: snapshot.data!.docs
                              .elementAt(index)
                              .get("player"));
                    }));
          })),
    );
  }

  LeaveRoom(String roomID, BuildContext context, VoidCallback OnSuccess) async {
    dynamic join_room = await _databaseInstance.LeaveRoom(roomID);
    OnSuccess.call();
  }

  @override
  void initState() {
    // TODO: implement initState
    _databaseInstance.GetPlayers(widget.RoomID).then((value) {
      setState(() {
        playerstream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[800],
        title: Center(child: Text("Players")),
        actions: <Widget>[
          TextButton.icon(
              onPressed: () {
                LeaveRoom(widget.RoomID, context, () {
                  if (!mounted) return;
                  Navigator.pop(context);
                });
              },
              icon: Icon(Icons.exit_to_app_rounded),
              label: Text("Exit Room"))
        ],
      ),
      body: playerList(),
    );
    ;
  }
}

class PlayerTile extends StatelessWidget {
  // const PlayerTile({super.key});

  final String playerID;
  PlayerTile({required this.playerID});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 3)),
      margin: EdgeInsets.only(bottom: 10, top: 7),
      height: 100,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              "https://cdn-icons-png.flaticon.com/512/166/166344.png",
              width: MediaQuery.of(context).size.width - 48,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Player ID :$playerID",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
