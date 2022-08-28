// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Account_Page.dart';
import 'package:flutter_application_1/Log_in_Page.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _formkey = GlobalKey<FormState>();
final current_user = LogInPage.auth.currentUser;
int current_index = 0;
String message = "";
final firestore = FirebaseFirestore.instance;
TextEditingController controller = TextEditingController();

int value = 0;

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("Chat Screen"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: current_index == 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Chat is end to end encrypted"),
                MsgsStream(),
                Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "can't send an empty message";
                        }
                        message = value.toString();
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: "type a message",
                          suffixIcon: Icon(
                            Icons.send,
                            color: controller.text.isEmpty
                                ? Color.fromARGB(255, 203, 238, 255)
                                : Colors.lightBlue,
                          ).onTap(() async {
                            if (_formkey.currentState!.validate()) {
                              message = controller.text;
                              controller.text = "";
                              setState(() {});
                              await firestore.collection('messages').add({
                                'sender': current_user!.email,
                                'text': message,
                                'time': DateTime.now(),
                              });
                            }
                          })),
                    ),
                  ),
                )
              ],
            )
          : AccountPage(),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: current_index,
          onTap: (value) {
            current_index = value;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(label: "chat", icon: Icon(Icons.chat)),
            BottomNavigationBarItem(
                label: "Account",
                icon: Icon(
                  Icons.account_circle,
                ))
          ]),
    );
  }
}

class MsgsStream extends StatelessWidget {
  const MsgsStream({Key? key}) : super(key: key);
  static List<List> chat = [];

  @override
  Widget build(BuildContext context) {
    delete_message(var id) {
      final res = firestore.collection('messages').doc(id).delete();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('messages')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        var msgs;
        try {
          msgs = snapshot.data!.docs;
        } catch (e) {}
        chat = [];
        if (msgs != null)
          for (var msg in msgs) {
            if (!chat.contains(msg))
              chat.add([msg['sender'], msg['text'], msg.id, msg['time']]);
          }
        return ListView.builder(
          reverse: true,
          itemCount: chat.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
                    crossAxisAlignment: chat[index][0] == current_user!.email
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                  chat[index][0]
                      .toString()
                      .text
                      .color(Colors.black)
                      .make()
                      .p4(),
                  Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          topLeft: chat[index][0] == current_user!.email
                              ? Radius.circular(20)
                              : Radius.circular(0),
                          topRight: chat[index][0] == current_user!.email
                              ? Radius.circular(0)
                              : Radius.circular(20)),
                      color: chat[index][0] == current_user!.email
                          ? Color.fromARGB(255, 147, 235, 150)
                          : Color.fromARGB(255, 223, 233, 29),
                      child: chat[index][1]
                          .toString()
                          .text
                          .size(18)
                          .wrapWords(true)
                          .make()
                          .w64(context)
                          .p8()),
                ])
                .onFeedBackTap(() async {
                  if (chat[index][0] == current_user!.email) {
                    bool delete = await showDialog(
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          title: Text("Do you wanna Delete This Message"),
                          content: Text("Are You Sure"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop(true);
                                },
                                child: Text("Yes")),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop(false);
                                },
                                child: Text("No")),
                          ],
                        );
                      },
                      context: context,
                    );
                    if (delete) {
                      delete_message(chat[index][2]);
                    }
                  }
                })
                .px4()
                .py8();
          },
        ).expand();
      },
    );
  }
}
