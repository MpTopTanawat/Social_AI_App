// ignore_for_file: file_names, depend_on_referenced_packages, use_build_context_synchronously, must_be_immutable

import 'dart:math';

import 'package:exchange_experience/DropDownButton/Agree_Positive.dart';
import 'package:exchange_experience/Group/GroupPage.dart';
import 'package:exchange_experience/HomePage/ShowMsgDialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';

int scorePost = 0;
bool isLoad = false;

class ConfirmPost extends StatefulWidget {
  ConfirmPost(
      {Key? key,
      required this.control,
      required this.postData,
      required this.textSpeechMsg})
      : super(key: key);
  TextEditingController control;
  final CollectionReference postData;
  String textSpeechMsg;

  @override
  State<ConfirmPost> createState() => _ConfirmPostState();
}

class _ConfirmPostState extends State<ConfirmPost> {
  @override
  void initState() {
    isLoad = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('MostRankUser')
        .snapshots()
        .forEach((element) {
      for (var element in element.docs) {
        if (element.get('uid') == FirebaseAuth.instance.currentUser!.uid) {
          scorePost = element.get('postScore');
        }
      }
    });
    if (isLoad) {
      return Container(
        padding: const EdgeInsets.all(60),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Just A Minute',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 223, 177, 107),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            CircularProgressIndicator(
              color: Color.fromARGB(255, 223, 177, 107),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: AlertDialog(
        insetPadding: const EdgeInsets.fromLTRB(12, 70, 12, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.5),
        ),
        backgroundColor: Colors.lightGreenAccent,
        title: const Text(
          'โปรดตรวจสอบข้อความและแท็กก่อนยืนยัน',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actionsPadding: const EdgeInsets.only(
          left: 5,
          right: 5,
        ),
        actions: [
          Container(
            alignment: Alignment.center,
            height: 200,
            width: double.maxFinite,
            color: Colors.white,
            child: Text(
              widget.control.text.toString(),
              style: const TextStyle(
                fontSize: 35,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              showFeedPostFirebaseFirestore() != 'Other'
                  ? 'แท็กที่มีในโพสต์'
                  : '',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          for (int i = 0; i <= tagList.length - 1; i++)
            Container(
              alignment: Alignment.center,
              child: Text(
                '# ${tagList[i]}',
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          const SizedBox(
            height: 18,
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
                  '\t ยืนยัน \t',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                onPressed: () async {
                  try {
                    setState(() {
                      isLoad = true;
                    });
                    String url = '';
                    int i = Random().nextInt(10000000);
                    if (filePost != null) {
                      UploadTask dirImage = FirebaseStorage.instance
                          .ref()
                          .child('ImagePost/$i.png')
                          .putFile(filePost!);
                      String urlTemp =
                          await (await dirImage).ref.getDownloadURL();
                      setState(() {
                        url = urlTemp;
                      });
                    }
                    List agreeDisAgree = await positiveNegative_AgreeDisagree(
                        context, widget.control.text, "Post");
                    double agreeValue = agreeDisAgree[2];
                    String toxic = agreeDisAgree[1];
                    final String subToxic =
                        toxic.substring(1, toxic.length - 1);

                    final List subToxicList = subToxic.split(', ');

                    List mapToxic = [];

                    for (String text in subToxicList) {
                      final List tmp = text.split('\': ');

                      setState(() {
                        mapToxic.add(tmp[0].substring(1, tmp[0].length));
                      });

                      setState(() {
                        mapToxic.add(tmp[1]);
                      });
                    }
                    final Map<String, double> map = {
                      mapToxic[0].toString(): double.parse(mapToxic[1]),
                      mapToxic[2].toString(): double.parse(mapToxic[3]),
                      mapToxic[4].toString(): double.parse(mapToxic[5]),
                      mapToxic[6].toString(): double.parse(mapToxic[7]),
                      mapToxic[8].toString(): double.parse(mapToxic[9]),
                      mapToxic[10].toString(): double.parse(mapToxic[11]),
                      mapToxic[12].toString(): double.parse(mapToxic[13]),
                    };

                    var commentArray = [0, 0, 0];

                    await widget.postData.add({
                      'imagePost': [url, i],
                      'subCategory': textInImage,
                      "name": FirebaseAuth.instance.currentUser!.displayName
                          .toString(),
                      "uid": FirebaseAuth.instance.currentUser!.uid.toString(),
                      "msg": widget.control.text.toString(),
                      "date": DateTime.now(),
                      'group': tagList,
                      'like': 0,
                      'checklike': [
                        FirebaseAuth.instance.currentUser!.uid.toString()
                      ],
                      'share': 0,
                      'comment': 0,
                      'shareToFeed': 'no',
                      'checkLikeClick': {
                        FirebaseAuth.instance.currentUser!.uid.toString():
                            'grey'
                      },
                      'checkComment': {},
                      'agreeValue': agreeValue,
                      'commentPositiveValue': commentArray,
                      'commentPositiveAmount': commentArray,
                      'commentAgreeValue': commentArray,
                      'commentAgreeAmount': commentArray,
                      'voteAmount': 0,
                      'userVote': [],
                      'image': FirebaseAuth.instance.currentUser!.photoURL,
                      'RGBA': [],
                      'toxic': map,
                    });
                    FirebaseFirestore.instance
                        .collection('MostRankUser')
                        .snapshots()
                        .forEach((element) {
                      for (var element in element.docs) {
                        if (element.get('uid') ==
                            FirebaseAuth.instance.currentUser!.uid) {
                          element.reference.update({
                            'postScore': scorePost + 1,
                          });
                        }
                      }
                    });
                    setState(() {
                      isLoad = false;
                      filePost = null;
                      widget.textSpeechMsg = "";
                      widget.control.clear();
                    });

                    Navigator.pop(context);
                    Navigator.pop(context);
                  } catch (e) {
                    Fluttertoast.showToast(
                        msg: e.toString(), gravity: ToastGravity.CENTER);

                    isLoad = false;
                  }
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  '\tแก้ไข\t',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
