// ignore_for_file: file_names, depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

final globalKey = GlobalKey<FormState>();
var newPassword = TextEditingController();

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreenAccent.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: globalKey,
            child: Container(
              margin: const EdgeInsets.fromLTRB(25, 40, 25, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'New Password',
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
                      obscureText: true,
                      controller: newPassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'กรุณากรอกรหัสผ่านใหม่ของคุณ'.tr();
                        }
                        return null;
                      },
                      decoration: InputDecoration.collapsed(
                        hintText: 'กรุณากรอกรหัสผ่านใหม่ของคุณ'.tr(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'กรุณากรอกรหัสผ่านใหม่ของคุณ'.tr();
                        }
                        if (value != newPassword.text) {
                          return 'กรุณากรอกรหัสผ่านใหม่ให้ตรงกัน'.tr();
                        }
                        return null;
                      },
                      decoration: InputDecoration.collapsed(
                        hintText: 'กรุณากรอกรหัสผ่านใหม่ของคุณอีกครั้ง'.tr(),
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
                      'เปลี่ยนรหัสผ่าน'.tr(),
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
                          await FirebaseAuth.instance.currentUser!
                              .updatePassword(newPassword.text);
                          Fluttertoast.showToast(
                              msg: "การเปลี่ยนรหัสผ่านของคุณเสร็จสมบูรณ์".tr(),
                              gravity: ToastGravity.CENTER);
                          newPassword.clear();
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
      ),
    );
  }
}
