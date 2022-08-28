import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Log_in_Page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Center(
      child: ElevatedButton(
          onPressed: () {
            LogInPage.auth.signOut();
            Navigator.pushReplacementNamed(context, "/Log_in");
          },
          child: Text("Log Out")),
    )));
  }
}
