import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizlake/screens/play_quiz.dart';
import 'package:quizlake/service/auth.dart';
import 'package:quizlake/service/database.dart';

class QuizDisplay extends StatefulWidget {
  // const QuizDisplay({super.key});
  final String roomID;
  QuizDisplay(this.roomID);

  @override
  State<QuizDisplay> createState() => _QuizDisplayState();
}

class _QuizDisplayState extends State<QuizDisplay> {
  DatabaseService _databaseInstance = new DatabaseService();
  AuthService _authInstance = new AuthService();

  Stream quizstream = Stream.empty();
  Widget quizList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
          stream: quizstream,
          builder: ((context, AsyncSnapshot snapshot) {
            return snapshot.data == null
                ? Container()
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      return QuizTile(
                          desc: snapshot.data!.docs
                              .elementAt(index)
                              .get("quizDescription"),
                          title: snapshot.data!.docs
                              .elementAt(index)
                              .get("quizTitle"),
                          quizID: snapshot.data!.docs
                              .elementAt(index)
                              .get("quizId"));
                    }));
          })),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _databaseInstance.GetQuizData(widget.roomID).then((value) {
      setState(() {
        quizstream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: quizList(),
    );
  }
}

class QuizTile extends StatelessWidget {
  // const QuizTile({super.key});
  final String title;
  final String desc;
  final String quizID;
  QuizTile({required this.desc, required this.title, required this.quizID});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => PlayQuiz(quizId: quizID)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "https://4kwallpapers.com/images/walls/thumbs_3t/8324.png",
                width: MediaQuery.of(context).size.width - 48,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    desc,
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
