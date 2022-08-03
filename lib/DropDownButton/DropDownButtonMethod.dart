// ignore_for_file: file_names, depend_on_referenced_packages, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:exchange_experience/DropDownButton/QR&Box&AnalyzeBox.dart';
import 'package:exchange_experience/DropDownButton/CommentAnalyze.dart';
import 'package:exchange_experience/DropDownButton/Report.dart';
import 'package:exchange_experience/DropDownButton/VoteForContent.dart';
import 'package:exchange_experience/Group/GroupPage.dart';
import 'package:exchange_experience/HomePage/ShowMsgDialog.dart';
import 'package:exchange_experience/Post/Post.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:easy_localization/easy_localization.dart';

List uidReport = [''];

class DropDown extends StatefulWidget {
  const DropDown(
      {Key? key,
      required this.index,
      required this.snapshot,
      required this.uid,
      required this.msg,
      required this.group,
      required this.item,
      required this.item2,
      required this.control,
      required this.formkey})
      : super(key: key);
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int index;
  final String uid;
  final String msg;
  final group;
  final String item;
  final String item2;
  final TextEditingController control;
  final GlobalKey formkey;

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  Future<QuerySnapshot> report =
      FirebaseFirestore.instance.collection('Report').get();
  @override
  void initState() {
    setState(() {
      uidReport = [''];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      uidReport = [''];
    });
    var itemButton = [
      "แก้ไข".tr(),
      "ลบ".tr(),
      widget.item.tr(),
      widget.item2.tr(),
      "แปลภาษา".tr()
    ];

    if (widget.item == '' && widget.item2 == '') {
      itemButton.removeAt(3);
      itemButton.removeAt(2);
    }
    if (FirebaseAuth.instance.currentUser!.uid !=
            widget.snapshot.data!.docs[widget.index].get(widget.uid) &&
        !FirebaseAuth.instance.currentUser!.isAnonymous) {
      itemButton.insert(2, 'Vote [For Content]');
    }
    if (widget.uid != 'uidcomment' &&
        widget.snapshot.data!.docs[widget.index].get('shareToFeed') == 'yes' &&
        widget.snapshot.data!.docs[widget.index].get('uid') ==
            FirebaseAuth.instance.currentUser!.uid) {
      itemButton.removeAt(2);
      itemButton.removeAt(2);
    }
    if (FirebaseAuth.instance.currentUser!.uid !=
        widget.snapshot.data!.docs[widget.index].get(widget.uid)) {
      itemButton = [widget.item2.tr(), "แปลภาษา".tr(), "รายงานข้อความนี้".tr()];
      if (widget.item2 == '') itemButton.removeAt(0);
      if (showFeedPostFirebaseFirestore() != 'Post' &&
          widget.uid != 'uidcomment') {
        itemButton.insert(2, 'Vote [For Content]');
      }
      if (widget.uid != 'uidcomment') {
        if (widget.snapshot.data!.docs[widget.index].get('shareToFeed') ==
            'yes') {
          itemButton.removeAt(0);
        }
      }
    }
    if (widget.uid != 'uidcomment' &&
        widget.snapshot.data!.docs[widget.index].get('shareToFeed') == 'no' &&
        FirebaseAuth.instance.currentUser!.uid ==
            widget.snapshot.data!.docs[widget.index].get('uid')) {
      itemButton.insert(itemButton.length - 1, 'Generate QR Code'.tr());
    }
    if (widget.uid == 'uidcomment') {
      itemButton.removeAt(0);
    }

    return FutureBuilder(
      future: report,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return DropdownButton(
          isDense: true,
          alignment: Alignment.topRight,
          items: [
            for (int i = 0; i <= itemButton.length - 1; i++) itemButton[i],
          ].map((String button) {
            return DropdownMenuItem(
              alignment: Alignment.center,
              value: button,
              child: Text(button),
            );
          }).toList(),
          onChanged: (String? clickButton) async {
            setState(() {
              uidReport = [''];
            });

            if (clickButton == 'แปลภาษา'.tr()) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: const Color.fromARGB(255, 160, 233, 76),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          elevatedSmallBox(context, widget.snapshot, 'Thai',
                              'th', widget.index, widget.msg),
                          elevatedSmallBox(context, widget.snapshot, 'English',
                              'en', widget.index, widget.msg),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          elevatedSmallBox(context, widget.snapshot, 'Swedish',
                              'sv', widget.index, widget.msg),
                          elevatedSmallBox(context, widget.snapshot, 'Japanese',
                              'ja', widget.index, widget.msg),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          elevatedSmallBox(context, widget.snapshot, 'Russian',
                              'ru', widget.index, widget.msg),
                          elevatedSmallBox(context, widget.snapshot, 'Spanish',
                              'es', widget.index, widget.msg),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          elevatedSmallBox(context, widget.snapshot, 'French',
                              'fr', widget.index, widget.msg),
                          elevatedSmallBox(context, widget.snapshot, 'Korean',
                              'ko', widget.index, widget.msg),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
              );
            }
            if (clickButton == 'Vote [For Content]') {
              showDialog(
                context: context,
                builder: (context) => Vote(
                  index: widget.index,
                  snapshot: widget.snapshot,
                ),
              );
            }

            if (clickButton == 'Generate QR Code'.tr()) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => qRCode(
                    context,
                    widget.snapshot.data!.docs[widget.index].get(widget.msg),
                    widget.snapshot.data!.docs[widget.index].get('name'),
                    timeagoText(
                      widget.snapshot.data!.docs[widget.index].get('date'),
                    ),
                  ),
                ),
              );
            }

            if (clickButton == 'รายงานข้อความนี้'.tr()) {
              for (var element in snapshot.data!.docs) {
                if (element.get('uid').toString() ==
                        widget.snapshot.data!.docs[widget.index]
                            .get(widget.uid)
                            .toString() &&
                    widget.snapshot.data!.docs[widget.index].get(widget.msg) ==
                        element.get(widget.msg)) {
                  uidReport = element.get('uidReport');
                }
              }
              for (int i = 0; i <= uidReport.length - 1; i++) {
                if (uidReport[i] == FirebaseAuth.instance.currentUser!.uid) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text('You have reported this content 😔'.tr()),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                          ),
                          child: Text('Close'.tr()),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                  break;
                } else if (i == uidReport.length - 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Report(
                        uidPost: widget.snapshot.data!.docs[widget.index]
                            .get(widget.uid),
                        msg: widget.snapshot.data!.docs[widget.index]
                            .get(widget.msg),
                      ),
                    ),
                  );
                }
              }
            }

            if (clickButton == 'แก้ไข'.tr()) {
              if (widget.uid != 'uidcomment') {
                showDialog(
                  context: context,
                  builder: (context) => ShowMsgDialog(
                    snapshot: widget.snapshot,
                    index: widget.index,
                    msg: widget.snapshot.data!.docs[widget.index]
                        .get(widget.msg),
                    tag: widget.snapshot.data!.docs[widget.index].get('group'),
                  ),
                );
              }
            }

            if (clickButton == 'ลบ'.tr()) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Text(
                      'คุณแน่ใจหรือว่าจะลบ?'.tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    content: Text(
                      'warning delete post'.tr(),
                      textAlign: TextAlign.center,
                    ),
                    actionsAlignment: MainAxisAlignment.spaceAround,
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightGreen[400],
                          padding: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'ใช่'.tr(),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 17),
                        ),
                        onPressed: () {
                          if (widget.uid == 'uidcomment') {
                            FirebaseFirestore.instance
                                .collection('Database')
                                .get()
                                .then((QuerySnapshot querySnapshot) {
                              for (var element in querySnapshot.docs) {
                                if (element.get('uid') ==
                                        widget.snapshot.data!.docs[widget.index]
                                            .get("uidpost") &&
                                    element.get('group') ==
                                        widget.snapshot.data!.docs[widget.index]
                                            .get("grouppost") &&
                                    element.get('msg') ==
                                        widget.snapshot.data!.docs[widget.index]
                                            .get("msgpost") &&
                                    element.get('date') ==
                                        widget.snapshot.data!.docs[widget.index]
                                            .get("datepost")) {
                                  element.reference.update({
                                    // 'commentRankTopTen':
                                    //     (element.get('commentRankTopTen') - 1),
                                    'comment': (element.get('comment') - 1),
                                  });
                                }
                              }
                            });
                          } else {
                            int i = widget.snapshot.data!.docs[widget.index]
                                .get('imagePost')[1];
                            FirebaseStorage.instance
                                .ref()
                                .child("ImagePost/$i.png")
                                .delete();
                          }
                          widget.snapshot.data!.docs[widget.index].reference
                              .delete();
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[400],
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'ไม่'.tr(),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 17),
                          ),
                          onPressed: () => Navigator.pop(context)),
                    ],
                  );
                },
              );
            }

            if (clickButton == 'วิเคราะห์ความคิดเห็น'.tr()) {
              setShowFeedPostFirebaseFirestore('AgreeDisAgree');

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => commentAnalyze(
                    context,
                    'Agree',
                    widget.snapshot.data!.docs[widget.index]
                        .get('commentAgreeAmount'),
                    widget.snapshot.data!.docs[widget.index]
                        .get('commentAgreeValue'),
                    () => commentAnalyzeButton(
                      context,
                      widget.control,
                      'Agree',
                      'ความคิดเห็นเห็นด้วย',
                      widget.index,
                      widget.snapshot.data!.docs[widget.index].get(widget.uid),
                      widget.snapshot.data!.docs[widget.index]
                          .get(widget.group),
                      widget.snapshot.data!.docs[widget.index].get(widget.msg),
                      widget.snapshot.data!.docs[widget.index].get('date'),
                    ),
                    () => commentAnalyzeButton(
                      context,
                      widget.control,
                      'Neutral Agree',
                      'ความคิดเห็นเป็นกลาง',
                      widget.index,
                      widget.snapshot.data!.docs[widget.index].get(widget.uid),
                      widget.snapshot.data!.docs[widget.index]
                          .get(widget.group),
                      widget.snapshot.data!.docs[widget.index].get(widget.msg),
                      widget.snapshot.data!.docs[widget.index].get('date'),
                    ),
                    () => commentAnalyzeButton(
                      context,
                      widget.control,
                      'DisAgree',
                      'ความคิดเห็นไม่เห็นด้วย',
                      widget.index,
                      widget.snapshot.data!.docs[widget.index].get(widget.uid),
                      widget.snapshot.data!.docs[widget.index]
                          .get(widget.group),
                      widget.snapshot.data!.docs[widget.index].get(widget.msg),
                      widget.snapshot.data!.docs[widget.index].get('date'),
                    ),
                  ),
                ),
              );
            }

            if (clickButton == "ความคิดเห็นเชิงบวกและเชิงลบ".tr()) {
              setShowFeedPostFirebaseFirestore('PositiveNegative');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => commentAnalyze(
                    context,
                    'Positive',
                    widget.snapshot.data!.docs[widget.index]
                        .get('commentPositiveAmount'),
                    widget.snapshot.data!.docs[widget.index]
                        .get('commentPositiveValue'),
                    () => commentAnalyzeButton(
                      context,
                      widget.control,
                      'Positive',
                      'ความคิดเห็นเชิงบวก',
                      widget.index,
                      widget.snapshot.data!.docs[widget.index].get(widget.uid),
                      widget.snapshot.data!.docs[widget.index]
                          .get(widget.group),
                      widget.snapshot.data!.docs[widget.index].get(widget.msg),
                      widget.snapshot.data!.docs[widget.index].get('date'),
                    ),
                    () => commentAnalyzeButton(
                      context,
                      widget.control,
                      'Neutral',
                      'ความคิดเห็นเป็นกลาง',
                      widget.index,
                      widget.snapshot.data!.docs[widget.index].get(widget.uid),
                      widget.snapshot.data!.docs[widget.index]
                          .get(widget.group),
                      widget.snapshot.data!.docs[widget.index].get(widget.msg),
                      widget.snapshot.data!.docs[widget.index].get('date'),
                    ),
                    () => commentAnalyzeButton(
                      context,
                      widget.control,
                      'Negative',
                      'ความคิดเห็นเชิงลบ',
                      widget.index,
                      widget.snapshot.data!.docs[widget.index].get(widget.uid),
                      widget.snapshot.data!.docs[widget.index]
                          .get(widget.group),
                      widget.snapshot.data!.docs[widget.index].get(widget.msg),
                      widget.snapshot.data!.docs[widget.index].get('date'),
                    ),
                  ),
                ),
              );
            }
          },
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.uid != 'uidcomment'
                    ? ''
                    : widget.snapshot.data!.docs[widget.index]
                                .get('agreeLevel') ==
                            'Agree'
                        ? "\u2713 ${widget.snapshot.data!.docs[widget.index].get('agreeLevel')}"
                        : widget.snapshot.data!.docs[widget.index]
                                    .get('agreeLevel') ==
                                'DisAgree'
                            ? "\u2717 ${widget.snapshot.data!.docs[widget.index].get('agreeLevel')}"
                            : widget.snapshot.data!.docs[widget.index]
                                .get('agreeLevel'),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                widget.uid != 'uidcomment'
                    ? ''
                    : widget.snapshot.data!.docs[widget.index]
                                .get('positiveLevel') ==
                            'Positive'
                        ? "\u2713 ${widget.snapshot.data!.docs[widget.index].get('positiveLevel')}"
                        : widget.snapshot.data!.docs[widget.index]
                                    .get('positiveLevel') ==
                                'Negative'
                            ? "\u2717 ${widget.snapshot.data!.docs[widget.index].get('positiveLevel')}"
                            : "${widget.snapshot.data!.docs[widget.index].get('positiveLevel')}",
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          underline: Container(
            alignment: Alignment.topRight,
            child: const Text('...'),
          ),
        );
      },
    );
  }
}
