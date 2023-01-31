import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Chat_Screen.dart';
import 'package:flutter_application_1/Log_in_Page.dart';
import 'package:flutter_application_1/Sign_in_Page.dart';
import 'firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/Sign_in",
      home: LogInPage(),
      routes: {
        "/Sign_in": (context) => SignInPage(),
        "/Log_in": (context) => LogInPage(),
        "/chat_screen": (context) => ChatScreen(),
      },
    );
  }
}
