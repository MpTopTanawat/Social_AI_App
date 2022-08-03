// ignore_for_file: file_names, non_constant_identifier_names, depend_on_referenced_packages, library_private_types_in_public_api

import 'package:exchange_experience/Profile/Bio.dart';
import 'package:exchange_experience/Profile/ChangeEmail.dart';
import 'package:exchange_experience/Profile/ChangeLanguage.dart';
import 'package:exchange_experience/Profile/ChangeName.dart';
import 'package:exchange_experience/Profile/ChangePassword.dart';
import 'package:exchange_experience/Login/Login.dart';
import 'package:exchange_experience/Profile/History.dart';
import 'package:exchange_experience/Profile/Upload&ChangePicture.dart';
import 'package:exchange_experience/Scaffold.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

String textSnapshot = '';
String name = '';
String nameTemp = '';
CollectionReference bioProfile = FirebaseFirestore.instance.collection("Bio");
TextEditingController control = TextEditingController();

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    callProfileNameFirebase();
    super.initState();
  }

  callProfileNameFirebase() async {
    setState(() {
      if (FirebaseAuth.instance.currentUser!.displayName != null &&
          nameTemp == '') {
        name = FirebaseAuth.instance.currentUser!.displayName.toString();
      } else if (nameTemp != '') {
        name = nameTemp;
      } else {
        name = 'Anonymus';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      context.locale;
    });
    if (!FirebaseAuth.instance.currentUser!.isAnonymous) {
      return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                  padding: const EdgeInsets.fromLTRB(20, 20, 10, 15),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundImage: Image.network(FirebaseAuth
                                    .instance.currentUser!.photoURL
                                    .toString())
                                .image,
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(
                            width: 35,
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.lightGreenAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  const UploadPicture(),
                            ),
                            child: Text(
                              'แก้ไขรูปโปรไฟล์'.tr(),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.lightGreenAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'แก้ไขชื่อโปรไฟล์'.tr(),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  const ChangeName(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      bio(FirebaseAuth.instance.currentUser!.uid.toString(),
                          false),
                    ],
                  ),
                ),
                elevatedBox(
                  context,
                  'ประวัติการโพสต์',
                  () => SecondScaffold(
                    name: "ประวัติการโพสต์",
                    func: () => history(context),
                  ),
                ),
                elevatedBox(
                  context,
                  'เปลี่ยนภาษา',
                  () => SecondScaffold(
                    name: 'เปลี่ยนภาษา',
                    func: () => const ChangeMultiLingual(),
                  ),
                ),
                elevatedBox(
                  context,
                  'แก้ไขอีเมล',
                  () => SecondScaffold(
                    name: 'เปลี่ยนอีเมล',
                    func: () => changeEmail(context),
                  ),
                ),
                elevatedBox(
                  context,
                  'เปลี่ยนรหัสผ่าน',
                  () => SecondScaffold(
                    name: 'เปลี่ยนรหัสผ่าน',
                    func: () => const ChangePassword(),
                  ),
                ),
                elevatedBox(context, 'ออกจากระบบ', () async {
                  await FirebaseAuth.instance.signOut();
                  return const Login();
                }),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                padding: const EdgeInsets.fromLTRB(20, 20, 10, 15),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/amongexperience.appspot.com/o/Original_ProfilePicture%2FAnatomy-Complete%2BStructure-evation2-edit2.png?alt=media&token=f26fe6ee-8390-4a29-a3cc-3f46f4a472be'),
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        const Text(
                          'Anonymus',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    elevatedBox(context, 'เข้าสู่ระบบ', () => const Login()),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
