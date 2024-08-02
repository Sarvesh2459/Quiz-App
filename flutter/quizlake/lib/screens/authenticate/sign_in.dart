import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizlake/screens/authenticate/register.dart';
import 'package:quizlake/service/auth.dart';
import 'package:flutter/src/material/material_state.dart';

import '../../service/database.dart';

class SignIn extends StatefulWidget {
  // const SignIn({super.key});
  final Function View;
  SignIn(this.View);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authInstance = AuthService();

  final _formkey = GlobalKey<FormState>();

  // storing text field states
  String email = "";
  String password = "";
  String roomID = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[800],
        actions: <Widget>[
          TextButton.icon(
              onPressed: () {
                widget.View();
              },
              icon: Icon(Icons.person),
              label: Text("Register"))
        ],
        title: Center(
          child: Text(
            "QuizLake",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Center(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            child: Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    validator: (val) => val!.isEmpty ? "Enter an Email" : null,
                    decoration: InputDecoration(hintText: "Email"),
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    validator: (val) => val!.length < 6
                        ? "Enter a password 6+ words long"
                        : null,
                    decoration: InputDecoration(hintText: "Password"),
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  SizedBox(height: 40.0),
                  SizedBox(
                    height: 36.0,
                    width: 300,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo[900]),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            dynamic result =
                                _authInstance.SignInWithEmail(email, password);
                            if (result == null) {
                              setState(() => error = "User invalid");
                            }
                          }
                        },
                        child: Text(
                          'LOG IN',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  SizedBox(height: 12.0),
                  Text(error,
                      style: TextStyle(
                        color: Colors.red,
                      )),
                  SizedBox(
                    height: 15.0,
                  ),
                  SizedBox(
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.black,
                            minimumSize: Size(double.infinity, 50)),
                        icon: FaIcon(
                          FontAwesomeIcons.google,
                          color: Colors.red[800],
                        ),
                        onPressed: () {
                          _authInstance.GoogleLogin();
                        },
                        label: Text(
                          "Sign In with Google",
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Log In easily using your Gmail Account")
                ],
              ),
            )),
      ),
    );
  }
}
