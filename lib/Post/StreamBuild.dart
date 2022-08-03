// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:exchange_experience/Post/History_UnHistory[SubPost].dart';
import 'package:exchange_experience/Post/Share_SubShare.dart';
import 'package:exchange_experience/Post/SubAllComment.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget streamBuild(
    TextEditingController control,
    BuildContext context,
    int index,
    String checkCondition,
    String collection,
    String orderBy,
    String setUidSecondPersonPost,
    List setGroupSecondPersonPost,
    String setMsgSecondPersonPost,
    Timestamp setDateSecondPersonPost,
    String checkConditionParametre,
    String checkAgreeValuePositiveValue) {
  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
      .collection(collection)
      .orderBy(
        orderBy,
        descending: true,
      )
      .snapshots();
  return StreamBuilder<QuerySnapshot>(
    stream: usersStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Something went wrong'),
          ),
          body: Center(
            child: Text(snapshot.hasError.toString()),
          ),
        );
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const SizedBox(
          height: 550,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (checkConditionParametre == "UnDocument") {
        ///
        // if (checkCondition == 'AComment') {
        //   return subAComment(
        //       snapshot,
        //       context,
        //       control,
        //       setUidSecondPersonPost,
        //       setGroupSecondPersonPost,
        //       setMsgSecondPersonPost,
        //       setDateSecondPersonPost);
        // }
        if (checkCondition == 'Share') {
          return Share(index: index, snapshot: snapshot);
        }
      }

      if (checkConditionParametre == "Document") {
        if (checkCondition == "History_UnHistory") {
          return SubPost(snapshot: snapshot, control: control);
        }
        if (checkCondition == 'AllComment') {
          return subAllComment(
            context,
            snapshot,
            control,
            setUidSecondPersonPost,
            setGroupSecondPersonPost,
            setMsgSecondPersonPost,
            setDateSecondPersonPost,
            checkAgreeValuePositiveValue,
          );
        }
        return Container();
      }
      return Container();
    },
  );
}
