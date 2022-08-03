// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:exchange_experience/Group/GroupPage.dart';
import 'package:exchange_experience/Group/PostContentGroup.dart';
import 'package:exchange_experience/Post/AlertDialogAnonymus.dart';
import 'package:exchange_experience/Post/Post.dart';
import 'package:exchange_experience/Scaffold.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContentGroup extends StatefulWidget {
  const ContentGroup({Key? key}) : super(key: key);

  @override
  State<ContentGroup> createState() => _ContentGroupState();
}

class _ContentGroupState extends State<ContentGroup> {
  Stream<QuerySnapshot> user = FirebaseFirestore.instance
      .collection(showFeedPostFirebaseFirestore())
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        heroTag: 'content',
        // Exception There are multiple heroes that share the same tag within a subtree.
        backgroundColor: Colors.orangeAccent[200],
        onPressed: FirebaseAuth.instance.currentUser!.isAnonymous
            ? () => showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      alertDialogForAnonymus(context),
                )
            : () => setState(
                  () => showBottomSheet(
                    context: context,
                    builder: (context) => const PostContentGroup(),
                  ),
                ),
        child: const Icon(Icons.article_outlined),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: user,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, int index) {
              if (snapshot.data!.docs[index].get('passConsider')) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        right: 5,
                        left: 5,
                        top: 5,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.amberAccent[100],
                        ),
                        child: ListTile(
                          title: Text(
                            snapshot.data!.docs[index].get('subCategory'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                            ),
                          ),
                          subtitle: ListTile(
                            title: Text(
                              snapshot.data!.docs[index].get('title'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 21,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Author : ${snapshot.data!.docs[index].get('name')}',
                                ),
                                Text(
                                  timeagoText(
                                    snapshot.data!.docs[index].get('date'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SecondScaffold(
                                  name: snapshot.data!.docs[index]
                                      .get('subCategory'),
                                  func: () => Scaffold(
                                    backgroundColor: const Color.fromARGB(
                                        155, 250, 222, 121),
                                    body: SingleChildScrollView(
                                      child: Center(
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 18,
                                            ),
                                            Text(
                                              snapshot.data!.docs[index]
                                                  .get('title'),
                                              style: const TextStyle(
                                                fontSize: 30,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(
                                              height: 18,
                                            ),
                                            Text(
                                              snapshot.data!.docs[index]
                                                  .get('subCategory'),
                                              style: const TextStyle(
                                                fontSize: 25,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              'Author : ${snapshot.data!.docs[index].get('name')}',
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              timeagoText(
                                                snapshot.data!.docs[index]
                                                    .get('date'),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 18,
                                            ),
                                            Text(
                                              snapshot.data!.docs[index]
                                                  .get('content'),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 25,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
              return Container();
            },
          );
        },
      ),
    );
  }
}
