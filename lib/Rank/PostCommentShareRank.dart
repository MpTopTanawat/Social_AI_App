// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exchange_experience/Group/GroupPage.dart';
import 'package:exchange_experience/Post/TextNameMethod.dart';
import 'package:exchange_experience/Scaffold.dart';
import 'package:flutter/material.dart';

postCommentShareRank(String score) {
  Future<QuerySnapshot> future = FirebaseFirestore.instance
      .collection('MostRankUser')
      .orderBy(score, descending: true)
      .get();
  String name = 'อันดับคะแนน'
      '${score == "postScore" ? 'โพสต์' : score == 'commentScore' ? 'ความคิดเห็น' : 'แชร์'}'
      'สูงสุด';
  setShowFeedPostFirebaseFirestore('postCommentShareRank');
  return SecondScaffold(
    name: name,
    func: () => Scaffold(
      backgroundColor: Colors.grey[200],
      body: FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 5,
                ),
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: Image.network(
                        snapshot.data!.docs[index].get('image'),
                      ).image,
                    ),
                    title: textName(snapshot, context, index, 'name', 'uid'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${snapshot.data!.docs[index].get(score)} คะแนน',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}
