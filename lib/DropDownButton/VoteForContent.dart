// ignore_for_file: file_names, depend_on_referenced_packages, use_build_context_synchronously

import 'package:exchange_experience/Group/GroupPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String vote = 'Vote !!';
List userVote = [];

class Vote extends StatefulWidget {
  final AsyncSnapshot snapshot;
  final int index;
  const Vote({
    Key? key,
    required this.index,
    required this.snapshot,
  }) : super(key: key);

  @override
  State<Vote> createState() => _VoteState();
}

class _VoteState extends State<Vote> {
  @override
  void initState() {
    setState(() {
      vote = 'Vote !!';
      userVote = widget.snapshot.data!.docs[widget.index].get('userVote');
      for (var element in userVote) {
        if (element == FirebaseAuth.instance.currentUser!.uid) {
          setState(() {
            vote = 'UnVote';
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int numberVote = widget.snapshot.data!.docs[widget.index].get('voteAmount');
    setState(() {
      vote = 'Vote !!';
      userVote = widget.snapshot.data!.docs[widget.index].get('userVote');
    });
    for (var element in userVote) {
      if (element == FirebaseAuth.instance.currentUser!.uid) {
        setState(() {
          vote = 'UnVote';
        });
      }
    }

    return AlertDialog(
      backgroundColor: Colors.orange[100],
      actions: [
        Column(
          children: [
            const Text(
              'Vote To Content',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const Text(
              'You Can Vote this Post.\n'
              'If the point of this is 1000 or More\n'
              'the Post is change to Content in Button Bar in the Group\n',
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            numberVote != 0
                ? Text(
                    'All Vote is $numberVote',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.lightGreenAccent,
              ),
              child: Text(vote),
              onPressed: () {
                if (vote == 'UnVote') {
                  for (int i = 0; i <= userVote.length - 1; i++) {
                    if (userVote[i] == FirebaseAuth.instance.currentUser!.uid) {
                      setState(() {
                        userVote.removeAt(i);
                      });
                      widget.snapshot.data!.docs[widget.index].reference
                          .update({
                        'userVote': userVote,
                        'voteAmount': userVote.length,
                      });
                    }
                  }
                } else if (vote == 'Vote !!') {
                  userVote.add(FirebaseAuth.instance.currentUser!.uid);
                  widget.snapshot.data!.docs[widget.index].reference.update({
                    'userVote': userVote,
                    'voteAmount': userVote.length,
                  });
                }
                if (userVote.length - 1 == 1000) {
                  FirebaseFirestore.instance
                      .collection(showFeedPostFirebaseFirestore())
                      .add({
                    'passConsider': true,
                    'uid': FirebaseAuth.instance.currentUser!.uid,
                    'name': FirebaseAuth.instance.currentUser!.displayName,
                    'subCategory': showFeedPostFirebaseFirestore(),
                    'title':
                        widget.snapshot.data!.docs[widget.index].get('msg'),
                    'content':
                        widget.snapshot.data!.docs[widget.index].get('msg'),
                    'date': DateTime.now(),
                  });
                } else if (userVote.length - 1 < 1000) {
                  FirebaseFirestore.instance
                      .collection(showFeedPostFirebaseFirestore())
                      .snapshots()
                      .forEach((elements) {
                    for (var element in elements.docs) {
                      if (element.get('content') ==
                              widget.snapshot.data!.docs[widget.index]
                                  .get('msg') &&
                          widget.snapshot.data!.docs[widget.index]
                                  .get('date') ==
                              element.get('date') &&
                          element.get('uid') ==
                              widget.snapshot.data!.docs[widget.index]
                                  .get('uid')) {
                        element.reference.delete();
                      }
                    }
                  });
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
