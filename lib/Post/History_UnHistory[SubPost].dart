// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:exchange_experience/Group/GroupPage.dart';
import 'package:exchange_experience/HomePage/ConsumerShowPostPage_WritePostMessage.dart';
import 'package:exchange_experience/Post/Comment.dart';
import 'package:exchange_experience/Post/PostBox.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubPost extends StatefulWidget {
  const SubPost({Key? key, required this.snapshot, required this.control})
      : super(key: key);
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final TextEditingController control;

  @override
  State<SubPost> createState() => _SubPostState();
}

class _SubPostState extends State<SubPost> {
  @override
  Widget build(BuildContext context) {
    bool condition = true;

    return SizedBox(
      height: height(context),
      child: Container(
        margin: const EdgeInsets.all(10),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: true,

          itemCount: widget.snapshot.data!.docs.length,
          // ถ้าเกิด กรณี RangeError Valid value range is empty: 0 ให้ใช้ .compareTo(0); ตามหลัง length
          itemBuilder: (context, int index) {
            try {
              uid = widget.snapshot.data!.docs[index].get('uid').toString();
              List group = widget.snapshot.data!.docs[index].get("group");

              bool checkGroup = false;
              for (var element in group) {
                if (element == showFeedPostFirebaseFirestore()) {
                  checkGroup = true;
                }
              }
              condition = showFeedPostFirebaseFirestore() != 'History'
                  ? checkGroup && showFeedPostFirebaseFirestore() != "Post"
                  : FirebaseAuth.instance.currentUser!.uid.toString() ==
                      widget.snapshot.data!.docs[index].get("uid");

              if (condition) {
                return PostBox(snapshot: widget.snapshot, index: index);
              } else if (showFeedPostFirebaseFirestore() == "Post") {
                // isn't History part

                return PostBox(snapshot: widget.snapshot, index: index);
              }

              return const Card();
            } catch (e) {
              rethrow;
            }
          },
        ),
      ),
    );
  }
}
