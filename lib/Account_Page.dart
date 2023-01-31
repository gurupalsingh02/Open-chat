import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Chat_Screen.dart';
import 'package:flutter_application_1/Log_in_Page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

double image_task = 0;
bool uploading = false;

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(
      children: [
        TextButton(
            onPressed: () async {
              XFile? file =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (file != null) {
                File image = new File(file.path);
                UploadTask uploadTask = FirebaseStorage.instance
                    .ref()
                    .child("ProfilePictures")
                    .child(Uuid().v1())
                    .putFile(image);
                TaskSnapshot snapshot = uploadTask.snapshot;
                String imageurl = await snapshot.ref.getDownloadURL();
                LogInPage.auth.currentUser!.updatePhotoURL(imageurl);
                firestore.collection('profile_images').add({
                  'imageurl': imageurl,
                });
              }
            },
            child: (LogInPage.auth.currentUser!.photoURL != null &&
                    LogInPage.auth.currentUser!.photoURL!.isNotEmpty)
                ? Image.network(
                    LogInPage.auth.currentUser!.photoURL.toString(),
                    width: MediaQuery.of(context).size.width * 0.2,
                  )
                : Text(
                    "choose an image",
                    style: TextStyle(color: Colors.black),
                  )),
        ElevatedButton(
            onPressed: () {
              LogInPage.auth.signOut();
              Navigator.pushReplacementNamed(context, "/Log_in");
            },
            child: Text("Log Out")),
      ],
    )));
  }
}
