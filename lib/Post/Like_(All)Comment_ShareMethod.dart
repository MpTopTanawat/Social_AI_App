// ignore_for_file: file_names, depend_on_referenced_packages, use_build_context_synchronously

import 'package:exchange_experience/DropDownButton/Agree_Positive.dart';
import 'package:exchange_experience/Post/AlertDialogAnonymus.dart';
import 'package:exchange_experience/Post/Comment.dart';
import 'package:exchange_experience/Post/Post.dart';
import 'package:exchange_experience/Post/StreamBuild.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';

int num = 0;
void getIndex(int ind) => num = ind;
int setIndex() => num;
Color colorComment = Colors.grey;
int scoreComment = 0;
Color isLike = Colors.grey;
String checkLike = '';

class CommentInPost extends StatefulWidget {
  const CommentInPost({Key? key, required this.index, required this.snapshot})
      : super(key: key);
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int index;

  @override
  State<CommentInPost> createState() => _CommentInPostState();
}

class _CommentInPostState extends State<CommentInPost> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///
        // Container(
        //   color: Colors.white,
        //   child: aComment(
        //     context,
        //     widget.snapshot.data!.docs[widget.index].get('uid'),
        //     widget.snapshot.data!.docs[widget.index].get('group'),
        //     widget.snapshot.data!.docs[widget.index].get('msg'),
        //     widget.snapshot.data!.docs[widget.index].get('date'),
        //   ),
        // ),
        SizedBox(
          width: double.maxFinite,
          height: 35,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              elevation: 0,
            ),
            onPressed: () {
              setAmountComment(
                  widget.snapshot.data!.docs[widget.index].get('comment'));

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => allComment(
                    context,
                    widget.snapshot.data!.docs[widget.index].get('uid'),
                    widget.snapshot.data!.docs[widget.index].get('group'),
                    widget.snapshot.data!.docs[widget.index].get('msg'),
                    widget.snapshot.data!.docs[widget.index].get('date'),
                  ),
                ),
              );
            },
            child: Text(
              '${'ดูความคิดเห็นทั้งหมด'.tr()} >',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class LikeCommentShare extends StatefulWidget {
  const LikeCommentShare(
      {Key? key, required this.snapshot, required this.index})
      : super(key: key);
  final AsyncSnapshot<QuerySnapshot> snapshot;

  final int index;

  @override
  State<LikeCommentShare> createState() => _LikeCommentShareState();
}

class _LikeCommentShareState extends State<LikeCommentShare> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> checkComment =
        widget.snapshot.data!.docs[widget.index].get('checkComment');
    String? color = checkComment[FirebaseAuth.instance.currentUser!.uid];
    setState(() {
      colorComment = color == 'amber' ? Colors.amber : Colors.grey;
    });

    int likeNumber = widget.snapshot.data!.docs[widget.index].get('like');
    Map<String, dynamic> checkLikeClick =
        widget.snapshot.data!.docs[widget.index].get('checkLikeClick');
    String checkLikeTemp = '^ ^';
    List checkLike = widget.snapshot.data!.docs[widget.index].get('checklike');
    for (var element in checkLike) {
      if (element == FirebaseAuth.instance.currentUser!.uid) {
        setState(() {
          checkLikeTemp = 'Have UID User in Field of on Database Collection';
        });
      }
    }
    String colorLike = checkLikeClick[FirebaseAuth.instance.currentUser!.uid];
    num = 0;
    getIndex(widget.index);

    FirebaseFirestore.instance
        .collection('MostRankUser')
        .snapshots()
        .forEach((element) {
      for (var element in element.docs) {
        if (element.get('uid') == FirebaseAuth.instance.currentUser!.uid) {
          scoreComment = element.get('commentScore');
        }
      }
    });

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              primary: Colors.grey[200],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: colorLike == 'red' ? Colors.red : Colors.grey,
                ),
                Text(
                  '${widget.snapshot.data!.docs[widget.index].get('like')}',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            onPressed: () {
              if (FirebaseAuth.instance.currentUser!.isAnonymous) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      alertDialogForAnonymus(context),
                );
              } else if (!FirebaseAuth.instance.currentUser!.isAnonymous) {
                if (checkLikeTemp == '^ ^') {
                  setState(() {
                    checkLike.add(FirebaseAuth.instance.currentUser!.uid);
                    checkLikeClick.addAll(
                        {FirebaseAuth.instance.currentUser!.uid: 'grey'});
                  });
                  widget.snapshot.data!.docs[widget.index].reference.update({
                    'checkLikeClick': checkLikeClick,
                    'checklike': checkLike,
                  });
                }

                if (colorLike == 'red') {
                  setState(() {
                    isLike = Colors.red;
                  });
                } else {
                  setState(() {
                    isLike = Colors.grey;
                  });
                }
                if (isLike == Colors.grey) {
                  setState(() {
                    checkLikeClick.update(
                        FirebaseAuth.instance.currentUser!.uid,
                        (value) => 'red');
                  });
                  widget.snapshot.data!.docs[widget.index].reference.update({
                    'checkLikeClick': checkLikeClick,
                    'like': ++likeNumber,
                  });
                } else {
                  setState(() {
                    checkLikeClick.update(
                        FirebaseAuth.instance.currentUser!.uid,
                        (value) => 'grey');
                  });
                  widget.snapshot.data!.docs[widget.index].reference.update({
                    'checkLikeClick': checkLikeClick,
                    'like': --likeNumber,
                  });
                }
              }
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              primary: Colors.grey[200],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.message,
                  color: colorComment,
                ),
                Text(
                  widget.snapshot.data!.docs[widget.index]
                      .get('comment')
                      .toString(),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  if (FirebaseAuth.instance.currentUser!.isAnonymous) {
                    return alertDialogForAnonymus(context);
                  } else if (!FirebaseAuth.instance.currentUser!.isAnonymous) {
                    return AlertDialog(
                      title: const Text("แสดงความคิดเห็น"),
                      content: Form(
                        key: formkey,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'กรุณาใส่ความคิดเห็น ^ ^';
                            }
                            return null;
                          },
                          controller: controller,
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          child: const Text("ยืนยัน"),
                          onPressed: () async {
                            try {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const CircularProcessComment();
                                  });

                              if (formkey.currentState!.validate()) {
                                var commentAgreeValue = widget
                                    .snapshot.data!.docs[widget.index]
                                    .get('commentAgreeValue');
                                var commentAgreeAmount = widget
                                    .snapshot.data!.docs[widget.index]
                                    .get('commentAgreeAmount');
                                var commentPositiveValue = widget
                                    .snapshot.data!.docs[widget.index]
                                    .get('commentPositiveValue');
                                var commentPositiveAmount = widget
                                    .snapshot.data!.docs[widget.index]
                                    .get('commentPositiveAmount');
                                String positive = "";

                                List tmp = await positiveNegative_AgreeDisagree(
                                    context, controller.text, "Comment");
                                double agreeValue = tmp[2];

                                String toxic = tmp[1];
                                final String subToxic =
                                    toxic.substring(1, toxic.length - 1);
                                final List subToxicList = subToxic.split(', ');
                                List mapToxic = [];
                                for (String text in subToxicList) {
                                  final List tmp = text.split('\': ');

                                  setState(() {
                                    mapToxic.add(
                                        tmp[0].substring(1, tmp[0].length));
                                    mapToxic.add(tmp[1]);
                                  });
                                }
                                final Map<String, double> map = {
                                  mapToxic[0]: double.parse(mapToxic[1]),
                                  mapToxic[2]: double.parse(mapToxic[3]),
                                  mapToxic[4]: double.parse(mapToxic[5]),
                                  mapToxic[6]: double.parse(mapToxic[7]),
                                  mapToxic[8]: double.parse(mapToxic[9]),
                                  mapToxic[10]: double.parse(mapToxic[11]),
                                  mapToxic[12]: double.parse(mapToxic[13]),
                                };

                                double agreeValuePost = widget
                                    .snapshot.data!.docs[widget.index]
                                    .get('agreeValue');
                                String agree = "";
                                if (agreeValue >=
                                        agreeValuePost -
                                            (agreeValuePost * .2) &&
                                    agreeValue <=
                                        agreeValuePost +
                                            (agreeValuePost * .2)) {
                                  agree = 'Agree';
                                  commentAgreeValue[0] += agreeValue;
                                  commentAgreeAmount[0] += 1;
                                } else if ((agreeValue <
                                            agreeValuePost -
                                                (agreeValuePost * .2) &&
                                        agreeValue >
                                            agreeValuePost -
                                                (agreeValuePost * .4)) ||
                                    (agreeValue >
                                            agreeValuePost +
                                                (agreeValuePost * .2) &&
                                        agreeValue <=
                                            agreeValuePost +
                                                (agreeValuePost * .4))) {
                                  agree = 'Neutral';
                                  commentAgreeValue[1] += agreeValue;
                                  commentAgreeAmount[1] += 1;
                                } else {
                                  agree = 'DisAgree';
                                  commentAgreeValue[2] += agreeValue;
                                  commentAgreeAmount[2] += 1;
                                }

                                List positiveValue = tmp[0];

                                if (positiveValue[1] != 0) {
                                  commentPositiveValue[0] += positiveValue[1];
                                  commentPositiveAmount[0] += 1;
                                }
                                if (positiveValue[3] != 0) {
                                  commentPositiveValue[1] += positiveValue[3];
                                  commentPositiveAmount[1] += 1;
                                }
                                if (positiveValue[5] != 0) {
                                  commentPositiveValue[2] += positiveValue[5];
                                  commentPositiveAmount[2] += 1;
                                }
                                if (positiveValue[1] > positiveValue[3] ||
                                    positiveValue[1] > positiveValue[5]) {
                                  positive = "Positive";
                                } else if (positiveValue[5] >
                                        positiveValue[3] ||
                                    positiveValue[5] > positiveValue[1]) {
                                  positive = "Negative";
                                } else {
                                  positive = "Neutral";
                                }
                                await FirebaseFirestore.instance
                                    .collection("Comment")
                                    .add({
                                  'uidpost': widget
                                      .snapshot.data!.docs[widget.index]
                                      .get("uid")
                                      .toString(),
                                  'grouppost': widget
                                      .snapshot.data!.docs[widget.index]
                                      .get("group"),
                                  'msgpost': widget
                                      .snapshot.data!.docs[widget.index]
                                      .get("msg")
                                      .toString(),
                                  'datepost': widget
                                      .snapshot.data!.docs[widget.index]
                                      .get("date"),
                                  'uidcomment': FirebaseAuth
                                      .instance.currentUser!.uid
                                      .toString(),
                                  'namecomment': FirebaseAuth
                                      .instance.currentUser!.displayName
                                      .toString(),
                                  'msgcomment': controller.text,
                                  'datecomment': DateTime.now(),
                                  'agreeValue': agreeValue,
                                  'agreeLevel': agree,
                                  'positiveValue': positiveValue,
                                  'positiveLevel': positive,
                                  'imagecomment': FirebaseAuth
                                      .instance.currentUser!.photoURL,
                                  'toxic': map,
                                });
                                if (color != 'amber') {
                                  setState(() {
                                    checkComment.addAll({
                                      'FirebaseAuth.instance.currentUser!.uid':
                                          'amber'
                                    });
                                  });
                                }
                                await widget
                                    .snapshot.data!.docs[widget.index].reference
                                    .update({
                                  'checkComment': checkComment,
                                  'comment': (widget
                                          .snapshot.data!.docs[widget.index]
                                          .get('comment') +
                                      1),
                                  'commentPositiveValue': commentPositiveValue,
                                  'commentPositiveAmount':
                                      commentPositiveAmount,
                                  'commentAgreeValue': commentAgreeValue,
                                  'commentAgreeAmount': commentAgreeAmount,
                                });
                                FirebaseFirestore.instance
                                    .collection('MostRankUser')
                                    .snapshots()
                                    .forEach((element) {
                                  for (var element in element.docs) {
                                    if (element.get('uid') ==
                                        FirebaseAuth
                                            .instance.currentUser!.uid) {
                                      element.reference.update({
                                        'commentScore': scoreComment + 1,
                                      });
                                    }
                                  }
                                });
                                setState(() {
                                  controller.clear();
                                });
                                Navigator.pop(context);
                              }

                              Navigator.pop(context);
                            } catch (e) {
                              Fluttertoast.showToast(
                                  msg: e.toString(),
                                  gravity: ToastGravity.CENTER);
                            }
                          },
                        ),
                        ElevatedButton(
                          child: const Text("ยกเลิก"),
                          onPressed: () {
                            controller.clear();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              );
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              elevation: 0,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.mobile_screen_share,
                  color: Colors.grey,
                ),
                Text(
                  widget.snapshot.data!.docs[widget.index]
                      .get('share')
                      .toString(),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  if (FirebaseAuth.instance.currentUser!.isAnonymous) {
                    return alertDialogForAnonymus(context);
                  } else {
                    return streamBuild(
                        TextEditingController.fromValue(TextEditingValue.empty),
                        context,
                        widget.index,
                        'Share',
                        'Database',
                        'date',
                        '',
                        [],
                        '',
                        Timestamp.now(),
                        'UnDocument',
                        "No checkAgreeValuePositiveValue");
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class CircularProcessComment extends StatefulWidget {
  const CircularProcessComment({Key? key}) : super(key: key);

  @override
  State<CircularProcessComment> createState() => _CircularProcessCommentState();
}

class _CircularProcessCommentState extends State<CircularProcessComment> {
  @override
  Widget build(BuildContext context) {
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
}
