// ignore_for_file: file_names, depend_on_referenced_packages, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

class Report extends StatefulWidget {
  const Report({
    Key? key,
    required this.msg,
    required this.uidPost,
  }) : super(key: key);
  final uidPost;
  final msg;

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  String reportMsg = '';
  String reportMsgTemp = '';
  String reportMsgTemp2 = ''; // เก็บข้อความใน TextField กรณีคลิ๊กปุ่มอื่น
  String feedback = '';
  bool setValue = false;

  radioFunc(String title) {
    if (title != 'อื่นๆ (เพิ่มเติม)') {
      return ListTile(
        title: Text(title.tr()),
        leading: Radio(
          groupValue: reportMsgTemp,
          value: title,
          onChanged: (String? value) {
            setState(() {
              reportMsgTemp = value!;
              reportMsg = value;
            });
          },
        ),
      );
    } else {
      return ListTile(
        title: Row(
          children: [
            Text(title.tr()),
            const SizedBox(
              width: 8,
            ),
            SizedBox(
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'โปรดระบุ ถ้ามี'.tr(),
                ),
                enabled: setValue =
                    reportMsgTemp != 'อื่นๆ (เพิ่มเติม)' ? false : true,
                onChanged: (String msg) {
                  setState(() {
                    reportMsg = msg;
                    reportMsgTemp2 = msg;
                  });
                },
              ),
            ),
          ],
        ),
        leading: Radio(
          groupValue: reportMsgTemp,
          value: title,
          onChanged: (String? value) {
            setState(() {
              reportMsgTemp = 'อื่นๆ (เพิ่มเติม)';
              reportMsg = reportMsgTemp2;
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<QuerySnapshot> report =
        FirebaseFirestore.instance.collection('Report').get();
    return FutureBuilder<QuerySnapshot>(
      future: report,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.lightGreenAccent,
            centerTitle: true,
            title: Text(
              'รายงาน'.tr(),
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                radioFunc('ใช้คำที่ไม่เหมาะสม'),
                radioFunc('เนื้อหาที่ไม่เกี่ยวข้อง'),
                radioFunc('อื่นๆ (เพิ่มเติม)'),
                Container(
                  height: 260,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
                  color: Colors.grey[100],
                  child: TextFormField(
                    onChanged: (String msg) {
                      setState(() {
                        feedback = msg;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'หากมีข้อเสนอแนะเพิ่มเติม โปรดระบุ !!'.tr(),
                    ),
                    maxLines: 12,
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    primary: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: reportMsg == ''
                      ? null
                      : () async {
                          int i = 0;
                          bool isHavenotData = true;
                          for (var element in snapshot.data!.docs) {
                            if (element.get('uid') == widget.uidPost &&
                                element.get('msg') == widget.msg) {
                              List uidReport = element.get('uidReport');
                              List msgReport = element.get('msgReport');
                              List feedbackReport =
                                  element.get('feedbackReport');
                              setState(() {
                                msgReport.add(reportMsg);
                                feedbackReport.add(feedback);
                                uidReport.add(
                                    FirebaseAuth.instance.currentUser!.uid);
                                isHavenotData = false;
                              });
                              element.reference.update({
                                'amountReport': element.get('amountReport') + 1,
                                'msgReport': msgReport,
                                'feedbackReport': feedbackReport,
                                'uidReport': uidReport,
                              });
                            } else if (i == snapshot.data!.docs.length - 1 &&
                                isHavenotData) {
                              FirebaseFirestore.instance
                                  .collection('Report')
                                  .add({
                                'uid': widget.uidPost,
                                'msg': widget.msg,
                                'msgReport': [reportMsg],
                                'feedbackReport': [feedback],
                                'amountReport': 1,
                                'uidReport': [
                                  FirebaseAuth.instance.currentUser!.uid
                                ],
                              });
                            }
                            setState(() {
                              i++;
                            });
                          }

                          Navigator.pop(context);
                        },
                  child: Text(
                    'SUBMIT'.tr(),
                    style: const TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
