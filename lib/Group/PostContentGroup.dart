// ignore_for_file: file_names, depend_on_referenced_packages, use_build_context_synchronously

import 'package:exchange_experience/Group/GroupPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class PostContentGroup extends StatefulWidget {
  const PostContentGroup({Key? key}) : super(key: key);

  @override
  State<PostContentGroup> createState() => _PostContentGroupState();
}

class _PostContentGroupState extends State<PostContentGroup> {
  String subCategory = '';
  String title = '';
  String content = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amberAccent[100],
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'หมวดหมู่ย่อย'.tr(),
                    border: InputBorder.none,
                  ),
                  onChanged: (String text) {
                    setState(() {
                      subCategory = text;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'หัวข้อ'.tr(),
                    border: InputBorder.none,
                  ),
                  onChanged: (String text) {
                    setState(() {
                      title = text;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * .75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'เนื้อหา'.tr(),
                    border: InputBorder.none,
                  ),
                  onChanged: (String text) {
                    setState(() {
                      content = text;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orangeAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Text(
                    'ส่งพิจารณา'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection(showFeedPostFirebaseFirestore())
                      .add({
                    'passConsider': false,
                    'uid': FirebaseAuth.instance.currentUser!.uid,
                    'name': FirebaseAuth.instance.currentUser!.displayName,
                    'subCategory': subCategory,
                    'title': title,
                    'content': content,
                    'date': DateTime.now(),
                  });
                  setState(() {
                    title = '';
                    subCategory = '';
                    content = '';
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
