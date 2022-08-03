// ignore_for_file: file_names, use_build_context_synchronously, depend_on_referenced_packages

import 'dart:math';

import 'package:exchange_experience/Post/Post.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String msgPostShared = 'msg';
String namePostShared = 'name';
String datePostShared = 'date';
String uidPostShared = 'uid';

int scoreShare = 0;

class Share extends StatefulWidget {
  const Share({Key? key, required this.index, required this.snapshot})
      : super(key: key);
  final AsyncSnapshot snapshot;
  final int index;

  @override
  State<Share> createState() => _ShareState();
}

class _ShareState extends State<Share> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('MostRankUser')
        .snapshots()
        .forEach((element) {
      for (var element in element.docs) {
        if (element.get('uid') == FirebaseAuth.instance.currentUser!.uid) {
          scoreShare = element.get('shareScore');
        }
      }
    });
    return AlertDialog(
      backgroundColor: Colors.lightGreen,
      title: const Text(
        'Share',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 30,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actionsPadding: const EdgeInsets.only(
        right: 10,
        left: 10,
      ),
      actions: [
        subShare(
            widget.snapshot,
            widget.index,
            FirebaseAuth.instance.currentUser!.uid,
            FirebaseAuth.instance.currentUser!.displayName.toString(),
            namePostShared,
            msgPostShared,
            datePostShared,
            uidPostShared),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                primary: Colors.green,
              ),
              child: const Text(
                '\t โพสต์ \t',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              onPressed: () async {
                int i = Random().nextInt(10000000);
                await widget.snapshot.data!.docs[widget.index].reference
                    .update({
                  'share':
                      widget.snapshot.data!.docs[widget.index].get('share') + 1,
                });
                if (widget.snapshot.data!.docs[widget.index]
                        .get('shareToFeed') ==
                    'yes') {
                  msgPostShared = 'msgpostshared';
                  namePostShared = 'namepostshared';
                  datePostShared = 'datepostshared';
                  uidPostShared = 'uidpostshared';
                }

                await FirebaseFirestore.instance.collection('Database').add({
                  "name":
                      FirebaseAuth.instance.currentUser!.displayName.toString(),
                  "uid": FirebaseAuth.instance.currentUser!.uid.toString(),
                  "msg": '',
                  "date": DateTime.now(),
                  'group':
                      widget.snapshot.data!.docs[widget.index].get('group'),
                  'checklike': [FirebaseAuth.instance.currentUser!.uid],
                  'like': 0,
                  'share': 0,
                  'shareToFeed': 'yes',
                  'comment': 0,
                  'checkComment': {},
                  'checkLikeClick': {
                    FirebaseAuth.instance.currentUser!.uid.toString(): 'grey',
                  },
                  'namepostshared': widget.snapshot.data!.docs[widget.index]
                      .get(namePostShared),
                  'datepostshared': widget.snapshot.data!.docs[widget.index]
                      .get(datePostShared),
                  'msgpostshared': widget.snapshot.data!.docs[widget.index]
                      .get(msgPostShared),
                  'uidpostshared': widget.snapshot.data!.docs[widget.index]
                      .get(uidPostShared),
                  'imagePost': ['', i],
                  'imagepostshared':
                      widget.snapshot.data!.docs[widget.index].get('image'),
                  'imagePostpostshare':
                      widget.snapshot.data!.docs[widget.index].get('imagePost'),
                  'subCategorypostshare': widget
                      .snapshot.data!.docs[widget.index]
                      .get('subCategory'),
                  'image': FirebaseAuth.instance.currentUser!.photoURL,
                  'RGBA': [],
                });

                FirebaseFirestore.instance
                    .collection('MostRankUser')
                    .snapshots()
                    .forEach((element) {
                  for (var element in element.docs) {
                    if (element.get('uid') ==
                        FirebaseAuth.instance.currentUser!.uid) {
                      element.reference.update({
                        'shareScore': scoreShare + 1,
                      });
                    }
                  }
                });

                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                '\tยกเลิก\t',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget subShare(
    AsyncSnapshot snapshot,
    int index,
    String uidCurrentUser,
    String nameCurrentUser,
    String namePostShared,
    String msgPostShared,
    String datePostShared,
    String uidPostShared) {
  if (snapshot.data!.docs[index].get('shareToFeed') == 'yes') {
    msgPostShared = 'msgpostshared';
    namePostShared = 'namepostshared';
    datePostShared = 'datepostshared';
    uidPostShared = 'uidpostshared';
  }

  return Container(
    color: Colors.grey[100],
    child: Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.only(top: 6),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: Image.network(
                FirebaseAuth.instance.currentUser!.photoURL.toString(),
              ).image,
              child: const FittedBox(),
            ),
          ),
          title: Text(
            nameCurrentUser,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            timeagoText(Timestamp.now()),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 12,
          ),
          padding: const EdgeInsets.only(
            left: 2,
            right: 2,
            bottom: 18,
          ),
          color: Colors.grey[350],
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.only(top: 6),
                  child: CircleAvatar(
                    radius: 19,
                    backgroundImage: Image.network(
                      snapshot.data!.docs[index].get('image'),
                    ).image,
                    child: const FittedBox(),
                  ),
                ),
                title: Text(
                  snapshot.data!.docs[index].get(namePostShared),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  timeagoText(snapshot.data!.docs[index].get(datePostShared))
                      .toString(),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 7,
                  right: 7,
                ),
                child: Text(
                  snapshot.data!.docs[index].get(msgPostShared).toString(),
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
