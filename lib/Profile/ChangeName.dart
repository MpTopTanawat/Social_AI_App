// ignore_for_file: file_names, depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:exchange_experience/Group/GroupPage.dart';
import 'package:exchange_experience/Login/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:exchange_experience/Profile/Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

class ChangeName extends StatefulWidget {
  const ChangeName({Key? key}) : super(key: key);

  @override
  State<ChangeName> createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        'ชื่อโปรไฟล์'.tr(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: TextFormField(
        controller: control,
        decoration: InputDecoration(
          hintText: 'ใส่ชื่อใหม่เจ๋งๆของคุณดูสิ !'.tr(),
        ),
        style: const TextStyle(
          fontSize: 20,
        ),
        autofocus: true,
        maxLength: 50,
        maxLines: null,
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
              child: Text(
                '\t ${'ยืนยัน'.tr()} \t',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () async {
                String controlText = control.text;

                if (control.text.isNotEmpty) {
                  await FirebaseAuth.instance.currentUser!
                      .updateDisplayName(control.text);

                  setState(() {
                    nameTemp = controlText;
                  });
                  FirebaseFirestore.instance
                      .collection('Database')
                      .snapshots()
                      .forEach((element) {
                    for (var element in element.docs) {
                      if (element.get('uid') ==
                          FirebaseAuth.instance.currentUser!.uid) {
                        element.reference.update({
                          'name': controlText,
                        });
                      }
                    }
                  });
                  FirebaseFirestore.instance
                      .collection('Comment')
                      .snapshots()
                      .forEach((element) {
                    for (var element in element.docs) {
                      if (element.get('uidcomment') ==
                          FirebaseAuth.instance.currentUser!.uid) {
                        element.reference.update({
                          'namecomment': controlText,
                        });
                      }
                    }
                  });
                  for (var element in groupENLang) {
                    FirebaseFirestore.instance
                        .collection(element)
                        .snapshots()
                        .forEach((element) {
                      for (var element in element.docs) {
                        if (element.get('uid') ==
                            FirebaseAuth.instance.currentUser!.uid) {
                          element.reference.update({
                            'name': controlText,
                          });
                        }
                      }
                    });
                  }

                  FirebaseFirestore.instance
                      .collection('MostRankUser')
                      .snapshots()
                      .forEach((element) {
                    for (var element in element.docs) {
                      if (element.get('uid') ==
                          FirebaseAuth.instance.currentUser!.uid) {
                        element.reference.update({
                          'name': controlText,
                        });
                      }
                    }
                  });

                  control.clear();
                  Navigator.pop(context);
                }
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                primary: Colors.grey[400],
              ),
              child: Text(
                '\t ${'ยกเลิก'.tr()} \t',
                style: const TextStyle(
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
  }
}

Widget elevatedBox(BuildContext context, String name, Function() method) {
  Color primary = Colors.white;
  Color textColor = Colors.black;
  double height = 50;
  double left = 22;
  double right = 22;

  if (FirebaseAuth.instance.currentUser!.isAnonymous && name == 'เข้าสู่ระบบ') {
    primary = Colors.lightGreenAccent;
  }

  if (showFeedPostFirebaseFirestore() == "Rank" ||
      showFeedPostFirebaseFirestore() == 'MoreApp') {
    height += right = left = 12;
    textColor = Colors.green;
  }

  return Container(
    margin: EdgeInsets.only(left: left, right: right),
    child: Column(
      children: [
        SizedBox(
          width: double.maxFinite,
          height: height,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: primary,
                elevation: 10,
              ),
              child: Text(
                name.tr(),
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                ),
              ),
              onPressed: () async {
                if (name == 'ออกจากระบบ') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                } else if (name == 'เข้าสู่ระบบ') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => method(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => method(),
                    ),
                  );
                }
              }),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    ),
  );
}
