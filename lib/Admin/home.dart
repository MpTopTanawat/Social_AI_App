// ignore_for_file: depend_on_referenced_packages

import 'package:exchange_experience/Admin/CommentUser.dart';
import 'package:exchange_experience/Admin/Group.dart';
import 'package:exchange_experience/Login/Login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShowData extends StatefulWidget {
  const ShowData({Key? key}) : super(key: key);

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  final Stream<QuerySnapshot> future =
      FirebaseFirestore.instance.collection('Database').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'POST',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.group),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GroupUser(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut().then(
                  (value) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  ),
                ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: future,
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

          try {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                try {
                  List<dynamic> group = snapshot.data?.docs[index].get('group');
                  String image = snapshot.data!.docs[index].get('imagePost')[0];
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
                                  snapshot.data!.docs[index].get('name'),
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
                            subtitle: Container(
                              margin: const EdgeInsets.only(
                                right: 30,
                              ),
                              child: Row(
                                children: [
                                  for (int i = 0; i <= group.length - 1; i++)
                                    Row(
                                      children: [
                                        Text(group[i] + '\t'),
                                        if (i != group.length - 1)
                                          const Text(',\t')
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            leading: const CircleAvatar(
                              backgroundColor: Colors.amber,
                            ),
                          ),
                          Text(
                            snapshot.data?.docs[index].get('msg'),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          image == '' ? Container() : Image.network(image),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.amber,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              width: double.maxFinite,
                              child: const Text(
                                'ดูความคิดเห็น',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommentUser(
                                  uid: snapshot.data!.docs[index].get('uid'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } catch (e) {
                  return Text(e.toString());
                }
              },
            );
          } catch (e) {
            return Container();
          }
        },
      ),
    );
  }
}
