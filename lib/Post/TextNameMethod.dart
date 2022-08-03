// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:exchange_experience/Group/GroupPage.dart';
import 'package:exchange_experience/Post/Comment.dart';
import 'package:exchange_experience/Profile/ProfileSecondPerson.dart';
import 'package:exchange_experience/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Widget textName(AsyncSnapshot snapshot, BuildContext context, int index,
    String name, String uid) {
  return TextButton(
    style: TextButton.styleFrom(
      primary: showFeedPostFirebaseFirestore() == 'postCommentShareRank'
          ? Colors.lightGreen
          : Colors.black,
      splashFactory: NoSplash.splashFactory,
      alignment: Alignment.topLeft,
    ),
    child: Text(
      snapshot.data!.docs[index].get(name).toString(),
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
    onPressed: () {
      setName(snapshot.data!.docs[index].get(name));
      setUid(snapshot.data!.docs[index].get(uid));
      if (snapshot.data!.docs[index].get(uid) ==
          FirebaseAuth.instance.currentUser!.uid) {
        numItemValue(3);
        setShowFeedPostFirebaseFirestore('Profile');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MainPage()));
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: subProfileSecondPerson(snapshot, context, index),
                contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              );
            });
      }
    },
  );
}
