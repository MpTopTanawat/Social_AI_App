// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:exchange_experience/Group/ContentGroup.dart';
import 'package:exchange_experience/Group/GroupPage.dart';
import 'package:exchange_experience/HomePage/ConsumerShowPostPage_WritePostMessage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class AllGroup extends StatelessWidget {
  const AllGroup({Key? key, required this.groupName}) : super(key: key);
  final String groupName;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection(showFeedPostFirebaseFirestore())
        .snapshots()
        .forEach((element) {
      for (var element in element.docs) {
        if (element.get('uid') == FirebaseAuth.instance.currentUser!.uid) {
          element.reference.update({
            'name': FirebaseAuth.instance.currentUser!.displayName.toString(),
          });
        }
      }
    });
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreenAccent,
          centerTitle: true,
          title: Text(
            groupName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          ),
          bottom: TabBar(
            overlayColor: MaterialStateProperty.resolveWith((states) =>
                states.contains(MaterialState.pressed)
                    ? Colors.orange
                    : Colors.green),
            labelColor: Colors.orange,
            indicatorColor: Colors.orange,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(
                icon: const Icon(Icons.home),
                text: 'Feed'.tr(),
              ),
              Tab(
                icon: const Icon(Icons.article_outlined),
                text: 'Content'.tr(),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ConsumerShowPostPage(),
            ContentGroup(),
          ],
        ),
      ),
    );
  }
}
