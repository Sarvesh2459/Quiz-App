import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlake/models/user.dart';
import 'package:quizlake/screens/authenticate/authenticate.dart';
import 'package:quizlake/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final userWrap = Provider.of<UserClass?>(context);
    print(userWrap);
    // returns either home or authenticate
    if (userWrap == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
