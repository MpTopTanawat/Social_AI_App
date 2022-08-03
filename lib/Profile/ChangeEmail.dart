// ignore_for_file: file_names, use_build_context_synchronously, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

final globalKey = GlobalKey<FormState>();
var control = TextEditingController();
String email = '';
changeEmail(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.lightGreenAccent.shade100,
    body: SingleChildScrollView(
      child: Form(
        key: globalKey,
        child: Container(
          margin: const EdgeInsets.fromLTRB(25, 40, 25, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'New Email',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              Container(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: control,
                  validator: (value) {
                    if (value!.isEmpty) return 'กรุณากรอกอีเมลใหม่ของคุณ'.tr();
                    if (FirebaseAuth.instance.currentUser!.email == value) {
                      return 'กรุณากรอกอีเมลใหม่ที่ไม่ซ้ำกับอีเมลเดิมของคุณ'
                          .tr();
                    }
                    return null;
                  },
                  decoration: InputDecoration.collapsed(
                    hintText: 'กรุณากรอกอีเมลใหม่ของคุณ'.tr(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'เปลี่ยนอีเมล'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  if (globalKey.currentState!.validate()) {
                    globalKey.currentState!.save();
                    try {
                      email = control.text;
                      await FirebaseAuth.instance.currentUser!
                          .verifyBeforeUpdateEmail(email);
                      Fluttertoast.showToast(
                          msg: "การเปลี่ยนอีเมลของคุณใกล้เสร็จสมบูรณ์",
                          gravity: ToastGravity.CENTER);
                      Fluttertoast.showToast(
                        gravity: ToastGravity.CENTER,
                        msg:
                            'กรุณาตรวจสอบอีเมลใหม่ของคุณเพื่อยืนยันอีเมลอีกครั้ง',
                      );
                      control.clear();
                      Navigator.pop(context);
                    } on FirebaseAuthException catch (e) {
                      Fluttertoast.showToast(
                        msg: e.message!,
                        gravity: ToastGravity.CENTER,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
