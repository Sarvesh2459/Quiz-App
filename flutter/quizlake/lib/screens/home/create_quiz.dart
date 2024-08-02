import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizlake/screens/home/addQuestion.dart';
import 'package:quizlake/service/auth.dart';
import 'package:quizlake/service/database.dart';
import 'package:quizlake/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({super.key});

  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formkey = GlobalKey<FormState>();
  DatabaseService _databaseInstance = new DatabaseService();
  AuthService _authInstance = new AuthService();
  bool _isloading = true;

  String quizTitle = "";
  String quizDescription = "";
  String quizId = "";
  String roomID = "";

  publishQuiz() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      quizId = randomAlphaNumeric(16);
      roomID = randomNumeric(6);
      Map<String, String> quizMap = {
        "quizId": quizId,
        "quizTitle": quizTitle,
        "quizDescription": quizDescription
      };
      await _databaseInstance.addQuizData(quizMap, quizId).then((value) {
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddQuestion(quizId: quizId, roomID: roomID)));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuizLake"),
      ),
      body: Form(
          key: _formkey,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            child: Column(children: <Widget>[
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter a valid Title" : null,
                decoration: InputDecoration(hintText: "Quiz Title"),
                onChanged: (value) {
                  setState(() => quizTitle = value);
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (val) =>
                    val!.isEmpty ? "Enter a valid description" : null,
                decoration: InputDecoration(hintText: "Quiz description"),
                onChanged: (value) {
                  setState(() => quizDescription = value);
                },
              ),
              SizedBox(
                height: 60,
              ),
              GestureDetector(
                  onTap: (() => publishQuiz()),
                  child: VioletButton(context, 'Create Quiz'))
            ]),
          )),
    );
  }
}
