// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:exchange_experience/Group/GroupPage.dart';
import 'package:exchange_experience/Post/Post.dart';
import 'package:exchange_experience/Post/StreamBuild.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<String> collectionName = [
  'Career',
  'Education',
  'GeneralKnowledge',
  'Fashion',
  'Health',
  'Pet',
  'Food_Beverage',
  'Human_Social',
  'Religion',
  'Psychology',
  'Funny',
  'Other'
];

history(BuildContext context) {
  setShowFeedPostFirebaseFirestore('History');
  return Scaffold(
    body: SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            streamBuild(
                control,
                context,
                0,
                "History_UnHistory",
                "Database",
                'date',
                "",
                [],
                "",
                Timestamp.now(),
                "Document",
                "No checkAgreeValuePositiveValue"),
          ],
        ),
      ),
    ),
  );
}
