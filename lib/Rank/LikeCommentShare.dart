// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:exchange_experience/Group/GroupPage.dart';
import 'package:exchange_experience/HomePage/ConsumerShowPostPage_WritePostMessage.dart';
import 'package:exchange_experience/Post/PostBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exchange_experience/Scaffold.dart';
import 'package:flutter/material.dart';

Widget likeCommentShareRank(String name, String orderBy) {
  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
      .collection("Database")
      .orderBy(
        orderBy,
        descending: true,
      )
      .snapshots(includeMetadataChanges: true);
  String nameTitle = '10 อันดับ';

  nameTitle += name == 'Like'
      ? 'ไลค์'
      : name == 'Comment'
          ? 'ความคิดเห็น'
          : name == 'Share'
              ? 'แชร์'
              : '';
  nameTitle += 'มากที่สุด';
  setShowFeedPostFirebaseFirestore('likeCommentShareRank');
  return SecondScaffold(
    name: nameTitle,
    func: () => Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  height: height(context),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, int index) {
                      return PostBox(snapshot: snapshot, index: index);
                    },
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    ),
  );
}
