// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:exchange_experience/Post/Comment.dart';
import 'package:exchange_experience/Profile/Bio.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

Widget subProfileSecondPerson(
    AsyncSnapshot snapshot, BuildContext context, int index) {
  return Container(
    padding: const EdgeInsets.only(bottom: 40),
    child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.orangeAccent,
            ),
            child: SizedBox(
              width: double.maxFinite,
              height: 200,
              child: Container(
                alignment: const Alignment(0.0, 2.5),
                child: CircleAvatar(
                  backgroundImage: Image.network(
                    snapshot.data!.docs[index].get('image'),
                  ).image,
                  radius: 60.0,
                  child: Container(),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          Text(getName(),
              style:
                  const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          bio(getUid(), true),
          const ElevatedButton(
            onPressed: null,
            child: Text('Message'),
          ),
          Text(
            '***หมายเหตุ : ขณะนี้เรากำลังพัฒนา\nกล่องข้อความให้ดียิ่งขึ้น'.tr(),
            style: const TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
