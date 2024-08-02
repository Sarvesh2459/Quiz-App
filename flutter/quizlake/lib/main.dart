import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlake/screens/home/isQuizStarted.dart';
import 'package:quizlake/models/user.dart';
import 'package:quizlake/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/src/async_provider.dart';
import 'package:quizlake/service/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserClass?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        home: ChangeNotifierProvider(
            create: (_) => QuizState(), child: Wrapper()),
      ),
    );
  }
}
