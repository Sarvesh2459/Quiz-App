import 'package:flutter/material.dart';

class QuizState extends ChangeNotifier {
  bool _quizStarted = false;

  bool get quizstate => _quizStarted;
}
