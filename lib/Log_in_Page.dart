// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Chat_Screen.dart';
import 'package:velocity_x/velocity_x.dart';

final _formkey = GlobalKey<FormState>();
bool null_user = false;

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);
  @override
  static var auth = FirebaseAuth.instance;

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  Widget build(BuildContext context) {
    String email = "", password = "";
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) return "error";
                      email = value.toString();
                      return null;
                    },
                    decoration: InputDecoration(
                        label: Text("Email"), hintText: "Enter Your Email"),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) return "error";
                      password = value.toString();
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        label: Text("Password"),
                        hintText: "Enter Your Password"),
                  )
                ],
              )),
          ElevatedButton(
            onPressed: () async {
              if (_formkey.currentState!.validate()) {
                try {
                  await LogInPage.auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  Navigator.pushReplacementNamed(context, '/chat_screen');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('User Successfully Logged in'),
                  ));
                } on FirebaseAuthException catch (err) {
                  if (err.code == 'wrong-password')
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('wrong password'),
                    ));
                  else if (err.code == 'user-not-found')
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('user not found'),
                    ));
                  else if (err.code == 'user-disabled')
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Acoount is disabled'),
                    ));
                  else if (err.code == 'invalid-email')
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('email is Invalid'),
                    ));
                }
              }
            },
            child: Text("Log In"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: null_user
                ? Text(
                    "wrong email or password",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )
                : Text(
                    "create Account",
                    style: TextStyle(color: Colors.lightBlue),
                  ).onTap(() {
                    Navigator.pushReplacementNamed(context, "/Sign_in");
                  }),
          ),
        ],
      ),
    );
  }
}
