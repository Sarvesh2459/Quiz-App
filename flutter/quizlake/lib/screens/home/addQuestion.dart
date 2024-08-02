import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizlake/screens/home/your_room_id.dart';
import 'package:quizlake/service/auth.dart';
import 'package:quizlake/service/database.dart';
import 'package:quizlake/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
  // const AddQuestion({super.key});
  final String quizId;
  final String roomID;
  AddQuestion({required this.quizId, required this.roomID});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formkey = GlobalKey<FormState>();
  DatabaseService _databaseInstance = new DatabaseService();
  AuthService _authInstance = new AuthService();
  String question = "";
  String option1 = "";
  String option2 = "";
  String option3 = "";
  String option4 = "";
  bool _isLoading = false;

  publishQuestion(BuildContext context, VoidCallback OnSuccess) async {
    Map<String, dynamic> RoomData = {
      "roomID": widget.roomID,
      "quizID": widget.quizId,
      "userID": FirebaseAuth.instance.currentUser!.uid
    };
    await _databaseInstance.CreateRoom(RoomData, widget.roomID);
    OnSuccess.call();
  }

  uploadQuestionData() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4,
      };
      await _databaseInstance
          .addQuestionData(questionMap, widget.quizId)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("QuizLake"),
      ),
      body: _isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Form(
              key: _formkey,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                child: Column(children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (val) =>
                        val!.isEmpty ? "Enter a valid question" : null,
                    decoration: InputDecoration(hintText: "Question"),
                    onChanged: (value) {
                      setState(() => question = value);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (val) => val!.isEmpty ? "Enter an option" : null,
                    decoration:
                        InputDecoration(hintText: "Option 1 (Correct Answer)"),
                    onChanged: (value) {
                      setState(() => option1 = value);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (val) => val!.isEmpty ? "Enter an option" : null,
                    decoration: InputDecoration(hintText: "Option 2"),
                    onChanged: (value) {
                      setState(() => option2 = value);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (val) => val!.isEmpty ? "Enter an option" : null,
                    decoration: InputDecoration(hintText: "Option 3"),
                    onChanged: (value) {
                      setState(() => option3 = value);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (val) => val!.isEmpty ? "Enter an option" : null,
                    decoration: InputDecoration(hintText: "Option4"),
                    onChanged: (value) {
                      setState(() => option4 = value);
                    },
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  GestureDetector(
                      onTap: (() => uploadQuestionData()),
                      child: VioletButton(
                        context,
                        "Add Question",
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: (() => publishQuestion(context, () {
                            if (!mounted) return;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RoomID(widget.roomID)));
                          })),
                      child: VioletButton(
                        context,
                        "Publish",
                      ))
                ]),
              )),
    );
  }
}
