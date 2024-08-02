import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizlake/models/question_model.dart';
import 'package:quizlake/service/database.dart';
import 'package:quizlake/widgets/quiz_play_widgets.dart';

class PlayQuiz extends StatefulWidget {
  // const PlayQuiz({super.key});
  final String roomID;
  PlayQuiz({required this.roomID});

  @override
  State<PlayQuiz> createState() => _PlayQuizState();
}

int total = 0;
int _correct = 0;
int _incorrrect = 0;
int _notAttempted = 0;

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService _databaseInstance = DatabaseService();
  QuerySnapshot? questionsnapshot;

  QuestionModel GetQuestionModelFromSnapshot(DocumentSnapshot Docsnapshot) {
    QuestionModel newModel = QuestionModel(
        question: "",
        option1: "",
        option2: "",
        option3: "",
        option4: "",
        correctOption: "",
        answered: false);

    newModel.question = Docsnapshot.get("question");
    List<String> options = [
      Docsnapshot.get("option1"),
      Docsnapshot.get("option2"),
      Docsnapshot.get("option3"),
      Docsnapshot.get("option4")
    ];
    options.shuffle();

    newModel.option1 = options[0];
    newModel.option2 = options[1];
    newModel.option3 = options[2];
    newModel.option4 = options[3];
    newModel.correctOption = Docsnapshot.get("option1");
    newModel.answered = false;

    return newModel;
  }

  @override
  void initState() {
    // TODO: implement initState
    _databaseInstance.getQuestionData(widget.roomID).then((value) {
      questionsnapshot = value;
      total = questionsnapshot!.docs.length;
      _correct = 0;
      _incorrrect = 0;
      _notAttempted = 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuizLake"),
      ),
      body: Container(
        child: Column(
          children: [
            questionsnapshot != null
                ? ListView.builder(
                    itemCount: questionsnapshot!.docs.length,
                    itemBuilder: (context, index) {
                      return QuizTile(
                          questionModel: GetQuestionModelFromSnapshot(
                              questionsnapshot!.docs.elementAt(index)),
                          index: index);
                    })
                : Container(
                    child: Text("null"),
                  )
          ],
        ),
      ),
    );
  }
}

class QuizTile extends StatefulWidget {
  // const QuizTile({super.key});

  final QuestionModel questionModel;
  final int index;
  QuizTile({required this.questionModel, required this.index});

  @override
  State<QuizTile> createState() => _QuizTileState();
}

class _QuizTileState extends State<QuizTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(widget.questionModel.question),
          SizedBox(
            height: 5,
          ),
          OptionTile(
              option: "A",
              description: widget.questionModel.option1,
              correctAnswer: widget.questionModel.option1,
              optionSelected: optionSelected),
          SizedBox(
            height: 5,
          ),
          OptionTile(
              option: "B",
              description: widget.questionModel.option1,
              correctAnswer: widget.questionModel.option2,
              optionSelected: optionSelected),
          SizedBox(
            height: 5,
          ),
          OptionTile(
              option: "C",
              description: widget.questionModel.option1,
              correctAnswer: widget.questionModel.option3,
              optionSelected: optionSelected),
          SizedBox(
            height: 5,
          ),
          OptionTile(
              option: "D",
              description: widget.questionModel.option1,
              correctAnswer: widget.questionModel.option4,
              optionSelected: optionSelected),
        ],
      ),
    );
  }
}
