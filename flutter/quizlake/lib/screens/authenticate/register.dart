import 'package:flutter/material.dart';
import 'package:quizlake/service/auth.dart';

class Register extends StatefulWidget {
  // const Register({super.key});

  final Function View;
  Register(this.View);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authInstance = AuthService();
  final _formkey = GlobalKey<FormState>();

  // storing text field states
  String email = "";
  String password = "";
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
              icon: Icon(Icons.person_4_rounded),
              label: Text("Sign In"))
        ],
        title: Center(
          child: Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 30,
            ),
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
                      validator: (val) =>
                          val!.isEmpty ? "Enter an Email" : null,
                      decoration: InputDecoration(hintText: "Specify Email"),
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
                      decoration:
                          InputDecoration(hintText: "Set your password"),
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
                              dynamic result = await _authInstance
                                  .registerWithEmail(email, password);
                              if (result == null) {
                                setState(() => error = "User invalid");
                              }
                            }
                          },
                          child: Text(
                            'REGISTER',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    SizedBox(height: 12.0),
                    Text(error,
                        style: TextStyle(
                          color: Colors.red,
                        ))
                  ],
                ))),
      ),
    );
  }
}
