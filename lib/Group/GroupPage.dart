// ignore_for_file: file_names, library_private_types_in_public_api, depend_on_referenced_packages

import 'package:exchange_experience/Group/AllGroup.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

String firebaseCloudStore = 'Post';
String showFeedPostFirebaseFirestore() => firebaseCloudStore;
void setShowFeedPostFirebaseFirestore(String post) => firebaseCloudStore = post;
List groupTHLang = [
  // "การศึกษา",
  // "อาชีพ",
  // "ความรู้ทั่วไป",
  // "แฟชัน",
  // "สุขภาพ",
  // "สัตว์เลี้ยง",
  // 'อาหารและเครื่องดื่ม',
  // 'มนุษย์และสังคม',
  // 'ศาสนาและความเชื่อ',
  // "จิตวิทยา",
  // 'วิดีโอ/เกมส์/การ์ตูนและการบันเทิง',
  // "อื่นๆ"
];
List groupENLang = [
  // 'Education',
  // 'Career',
  // 'General Knowledge',
  // 'Fashion',
  // 'Health',
  // 'Pet',
  // 'Food Beverage',
  // 'Human Social',
  // 'Religion',
  // 'Psychology',
  // 'Entertainment',
  // 'Other'
];

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  Future<QuerySnapshot> user =
      FirebaseFirestore.instance.collection('GroupName').get();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: user,
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
        groupTHLang = snapshot.data!.docs[0].get('thName');
        groupENLang = snapshot.data!.docs[0].get('enName');
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: Column(
                  children: [
                    if (groupENLang.length.isEven)
                      for (int i = 0; i <= groupENLang.length - 1; i += 2)
                        elevatedGroup(
                          context,
                          groupTHLang[i],
                          () => AllGroup(
                              groupName:
                                  'หมวด'.tr() + '${groupTHLang[i]}'.tr()),
                          groupTHLang[i + 1],
                          () => AllGroup(
                              groupName:
                                  'หมวด'.tr() + '${groupTHLang[i + 1]}'.tr()),
                          groupENLang[i],
                          groupENLang[i + 1],
                        ),
                    if (groupENLang.length.isOdd)
                      Column(
                        children: [
                          for (int i = 0; i <= groupENLang.length - 2; i += 2)
                            elevatedGroup(
                              context,
                              groupTHLang[i],
                              () => AllGroup(
                                  groupName:
                                      'หมวด'.tr() + '${groupTHLang[i]}'.tr()),
                              groupTHLang[i + 1],
                              () => AllGroup(
                                  groupName: 'หมวด'.tr() +
                                      '{groupTHLang[i + 1]}'.tr()),
                              groupENLang[i],
                              groupENLang[i + 1],
                            ),
                          elevatedGroup(
                            context,
                            groupTHLang[groupTHLang.length - 1],
                            () => AllGroup(
                                groupName: 'หมวด'.tr() +
                                    '{groupTHLang[groupTHLang.length - 1]}'
                                        .tr()),
                            '',
                            () => const AllGroup(groupName: 'หมวด...'),
                            groupENLang[groupENLang.length - 1],
                            '',
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Container elevatedGroup(
    BuildContext context,
    String text1,
    Function() subGroup1,
    String text2,
    Function() subGroup2,
    String showFeedDatabase1,
    String showFeedDatabase2) {
  return Container(
    padding: const EdgeInsets.only(top: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 175,
          height: 145,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              primary: Colors.lightGreenAccent[100],
            ),
            child: Text(
              text1.tr(),
              style: const TextStyle(
                fontSize: 21,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              firebaseCloudStore = showFeedDatabase1;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => subGroup1(),
                ),
              );
            },
          ),
        ),
        if (text2 != '')
          SizedBox(
            width: 175,
            height: 145,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                primary: Colors.lightGreenAccent[100],
              ),
              child: Text(
                text2.tr(),
                style: const TextStyle(
                  fontSize: 21,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                firebaseCloudStore = showFeedDatabase2;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => subGroup2(),
                  ),
                );
              },
            ),
          ),
      ],
    ),
  );
}
