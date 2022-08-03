// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:exchange_experience/Profile/Profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Widget bio(String getUid, bool returnTextOnly) {
  final Stream<QuerySnapshot> usersStream =
      FirebaseFirestore.instance.collection("Bio").snapshots();

  return SingleChildScrollView(
    child: StreamBuilder<QuerySnapshot>(
      stream: usersStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
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

        for (int i = 0; i <= snapshot.data!.docs.length - 1; i++) {
          if (snapshot.data!.docs[i].get('uid') == getUid) {
            textSnapshot = snapshot.data!.docs[i].get('bio').toString();
            break;
          }
          if (i == snapshot.data!.docs.length - 1 &&
              snapshot.data!.docs[i].get('uid') != getUid) {
            textSnapshot = '';
          }
        }
        if (returnTextOnly == false) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.5),
              color: Colors.grey[200],
            ),
            height: 145,
            width: 300,
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IconButton(
                  alignment: Alignment.topRight,
                  icon: const Icon(Icons.edit, size: 15),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: const Text(
                            'Bio',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: TextFormField(
                            controller: control =
                                TextEditingController(text: textSnapshot),
                            decoration: const InputDecoration(
                              hintText: 'ใส่ประวัติคร่าวๆของคุณดูสิ !',
                            ),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            autofocus: true,
                            maxLines: null,
                            maxLength: 110,
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.lightGreenAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    '\t ยืนยัน \t',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (control.text.isEmpty ||
                                        control.text == '') {
                                      for (int i = 0;
                                          i <= snapshot.data!.docs.length - 1;
                                          i++) {
                                        if (snapshot.data!.docs[i].get('uid') ==
                                                getUid &&
                                            (control.text.isEmpty ||
                                                control.text == '') &&
                                            textSnapshot != '') {
                                          snapshot.data!.docs[i].reference
                                              .delete();
                                          textSnapshot = '';
                                          break;
                                        }
                                      }
                                    }
                                    if (control.text.isNotEmpty &&
                                        textSnapshot != '') {
                                      for (int i = 0;
                                          i <= snapshot.data!.docs.length - 1;
                                          i++) {
                                        if (snapshot.data!.docs[i].get('uid') ==
                                            getUid) {
                                          if (snapshot.data!.docs[i]
                                                  .get('bio') !=
                                              '') {
                                            snapshot.data!.docs[i].reference
                                                .update({
                                              'bio': control.text,
                                            });
                                            break;
                                          }
                                        }
                                      }
                                    }
                                    if (control.text.isNotEmpty &&
                                        textSnapshot == '') {
                                      bioProfile.add({
                                        'uid': FirebaseAuth
                                            .instance.currentUser!.uid
                                            .toString(),
                                        'bio': control.text,
                                      });
                                    }
                                    control.clear();
                                    Navigator.pop(context);
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    primary: Colors.grey[400],
                                  ),
                                  child: const Text(
                                    '\t ยกเลิก \t',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  onPressed: () {
                                    control.clear();
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                Text(textSnapshot,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify),
              ],
            ),
          );
        } else {
          return Text(
            textSnapshot,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          );
        }
      },
    ),
  );
}
