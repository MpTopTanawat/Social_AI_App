// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentUser extends StatefulWidget {
  const CommentUser({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<CommentUser> createState() => _CommentUserState();
}

class _CommentUserState extends State<CommentUser> {
  final Stream<QuerySnapshot> stream =
      FirebaseFirestore.instance.collection('Comment').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'COMMENT',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              try {
                if (widget.uid == snapshot.data!.docs[index].get('uidpost')) {
                  return Container(
                    margin: const EdgeInsets.all(5),
                    child: Card(
                      margin: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  snapshot.data!.docs[index].get('namecomment'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                IconButton(
                                  alignment: Alignment.topRight,
                                  icon: const Icon(Icons.close),
                                  onPressed: () => snapshot
                                      .data!.docs[index].reference
                                      .delete(),
                                ),
                              ],
                            ),
                            leading: CircleAvatar(
                              backgroundImage: Image.network(
                                snapshot.data!.docs[index].get('imagecomment'),
                              ).image,
                            ),
                          ),
                          Text(
                            snapshot.data?.docs[index].get('msgcomment'),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              } catch (e) {
                return Text(e.toString());
              }
            },
          );
        },
      ),
    );
  }
}
