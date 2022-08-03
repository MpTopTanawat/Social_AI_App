// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:exchange_experience/Post/Post.dart';
import 'package:exchange_experience/Post/StreamBuild.dart';
import 'package:exchange_experience/Scaffold.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

CollectionReference commentData =
    FirebaseFirestore.instance.collection("Comment");
TextEditingController controller = TextEditingController();
String uid = FirebaseAuth.instance.currentUser!.uid.toString();
String name = '';

void setUid(String setUid) => uid = setUid;
void setName(String setName) => name = setName;
String getUid() => uid;
String getName() => name;
int amountComment = 0;
void setAmountComment(int number) => amountComment = number;

Widget aComment(
    BuildContext context,
    String setUidSecondPersonPost,
    List setGroupSecondPersonPost,
    String setMsgSecondPersonPost,
    Timestamp setDateSecondPersonPost) {
  return streamBuild(
      control,
      context,
      0,
      'AComment',
      'Comment',
      'datecomment',
      setUidSecondPersonPost,
      setGroupSecondPersonPost,
      setMsgSecondPersonPost,
      setDateSecondPersonPost,
      'UnDocument',
      "No checkAgreeValuePositiveValue");
}

Widget allComment(
    BuildContext context,
    String setUidSecondPersonPost,
    List setGroupSecondPersonPost,
    String setMsgSecondPersonPost,
    Timestamp setDateSecondPersonPost) {
  return SecondScaffold(
    name: 'ความคิดเห็น'.tr(),
    func: () => SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Text(
            '$amountComment\t ${'ความคิดเห็น'.tr()}',
            style: const TextStyle(fontSize: 16),
          ),
          streamBuild(
              control,
              context,
              0,
              'AllComment',
              'Comment',
              'datecomment',
              setUidSecondPersonPost,
              setGroupSecondPersonPost,
              setMsgSecondPersonPost,
              setDateSecondPersonPost,
              "Document",
              "No checkAgreeValuePositiveValue"),
        ],
      ),
    ),
  );
}
