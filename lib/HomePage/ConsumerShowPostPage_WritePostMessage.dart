// ignore_for_file: file_names, invalid_use_of_visible_for_testing_member, depend_on_referenced_packages, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:exchange_experience/Group/GroupPage.dart';
import 'package:exchange_experience/HomePage/ShowMsgDialog.dart';
import 'package:exchange_experience/Post/AlertDialogAnonymus.dart';
import 'package:exchange_experience/Post/StreamBuild.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// การแสดงผลเป็นหน้าที่ของ Consumer และการประมวลผลจะเป็นหน้าที่ของ Provider
CollectionReference postData =
    FirebaseFirestore.instance.collection("Database");

stt.SpeechToText speechToText = stt.SpeechToText();
bool isSpeech = false;
String textSpeechMsg = '';
TextEditingController control = TextEditingController();

class ConsumerShowPostPage extends StatefulWidget {
  const ConsumerShowPostPage({Key? key}) : super(key: key);

  @override
  _ConsumerShowPostPageState createState() => _ConsumerShowPostPageState();
}

class _ConsumerShowPostPageState extends State<ConsumerShowPostPage> {
  @override
  void initState() {
    super.initState();
    speechToText = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: FloatingActionButton(
        heroTag: 'post',
        // Exception There are multiple heroes that share the same tag within a subtree.
        onPressed: () {
          if (FirebaseAuth.instance.currentUser!.isAnonymous) {
            showDialog(
              context: context,
              builder: (BuildContext context) =>
                  alertDialogForAnonymus(context),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const ShowMsgDialog(
                  snapshot: AsyncSnapshot.nothing(),
                  tag: [],
                );
              },
            );
          }
        },
        backgroundColor: Colors.lightGreenAccent,
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
      body: streamBuild(
          control,
          context,
          0,
          "History_UnHistory",
          "Database",
          "date",
          "",
          [],
          "",
          Timestamp.now(),
          "Document",
          "No checkAgreeValuePositiveValue"),
    );
  }
}

double height(BuildContext context) {
  if (showFeedPostFirebaseFirestore() == 'Post') {
    return MediaQuery.of(context).size.height * .815;
  } else if (showFeedPostFirebaseFirestore() == 'History') {
    return MediaQuery.of(context).size.height * .89;
  } else if (showFeedPostFirebaseFirestore() == 'Rank') {
    return MediaQuery.of(context).size.height * .86;
  } else {
    return MediaQuery.of(context).size.height * .79;
  }
}
