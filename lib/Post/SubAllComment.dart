// ignore_for_file: file_names, non_constant_identifier_names, depend_on_referenced_packages

import 'package:exchange_experience/HomePage/ConsumerShowPostPage_WritePostMessage.dart';
import 'package:exchange_experience/DropDownButton/DropDownButtonMethod.dart';
import 'package:exchange_experience/Post/Post.dart';
import 'package:exchange_experience/Post/TextNameMethod.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var Agree_Positive = [];

Widget subAllComment(
  BuildContext context,
  AsyncSnapshot<QuerySnapshot> snapshot,
  TextEditingController control,
  String setUidSecondPersonPost,
  List setGroupSecondPersonPost,
  String setMsgSecondPersonPost,
  Timestamp setDateSecondPersonPost,
  String checkAgreeValuePositiveValue,
) {
  bool isAgreeValuePositiveValue = true;

  return Container(
    margin: const EdgeInsets.all(10),
    height: height(context),
    child: ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, int index) {
        final Map toxicity = snapshot.data!.docs[index].get('toxic');
        final bool isOpenToxic = toxicity['toxicity'] < .25 &&
            toxicity['severe_toxicity'] < .25 &&
            toxicity['obscene'] < .25 &&
            toxicity['identity_attack'] < .25 &&
            toxicity['insult'] < .25 &&
            toxicity['threat'] < .25 &&
            toxicity['sexual_explicit'] < .25;

        isAgreeValuePositiveValue = checkAgreeValuePositiveValue == "Agree"
            ? snapshot.data!.docs[index].get('agreeLevel') == "Agree"
            : checkAgreeValuePositiveValue == "Neutral Agree"
                ? snapshot.data!.docs[index].get('agreeLevel') == "Neutral"
                : checkAgreeValuePositiveValue == "DisAgree"
                    ? snapshot.data!.docs[index].get('agreeLevel') == "DisAgree"
                    : checkAgreeValuePositiveValue == "Positive"
                        ? snapshot.data!.docs[index].get("positiveLevel") ==
                            "Positive"
                        : checkAgreeValuePositiveValue == "Neutral"
                            ? snapshot.data!.docs[index].get('positiveLevel') ==
                                "neutral"
                            : checkAgreeValuePositiveValue == "Negative"
                                ? snapshot.data!.docs[index]
                                        .get('positiveLevel') ==
                                    "Negative"
                                : true;

        if (snapshot.data!.docs[index].get('uidpost') ==
                setUidSecondPersonPost &&
            setGroupSecondPersonPost.toString() ==
                snapshot.data!.docs[index].get('grouppost').toString() &&
            snapshot.data!.docs[index].get('msgpost') ==
                setMsgSecondPersonPost &&
            snapshot.data!.docs[index].get('datepost') ==
                setDateSecondPersonPost &&
            isAgreeValuePositiveValue) {
          return Card(
            elevation: 3,
            child: isOpenToxic
                ? Column(
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.only(top: 6),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage: Image.network(
                              snapshot.data!.docs[index].get('imagecomment'),
                            ).image,
                            child: const FittedBox(),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropDown(
                                index: index,
                                snapshot: snapshot,
                                uid: 'uidcomment',
                                msg: 'msgcomment',
                                group: 'grouppost',
                                item: '',
                                item2: '',
                                control: control,
                                formkey: formkey),
                            textName(snapshot, context, index, 'namecomment',
                                'uidcomment'),
                          ],
                        ),
                        subtitle: Text(timeagoText(
                                snapshot.data!.docs[index].get("datecomment"))
                            .toString()),
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
                          snapshot.data!.docs[index]
                              .get("msgcomment")
                              .toString(),
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.grey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                      ),
                    ],
                  )
                : Container(
                    color: Colors.grey,
                    child: const Text(
                        'เนื้อหานี้ถูกปิดแสดงความคิดเห็นเนื่องจากมีการใช้คำที่ไม่เหมาะสม%n'
                        'ซึ่งอาจทำร้ายจิตใจหรือทำให้เกิดความหวาดกลัว เป็นต้น'),
                  ),
          );
        }
        return Container();
      },
    ),
  );
}
