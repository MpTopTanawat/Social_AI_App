// ignore_for_file: file_names, use_build_context_synchronously, library_private_types_in_public_api, depend_on_referenced_packages

import 'package:exchange_experience/Login/Login.dart';
import 'package:exchange_experience/Login/keepAccEachUser_Login&Post.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final globalKey = GlobalKey<FormState>();
  AccountUserLogin accUser = AccountUserLogin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: globalKey,
            child: Container(
              margin: const EdgeInsets.fromLTRB(25, 40 /*80*/, 25, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                      onSaved: (String? email) {
                        accUser.email = email;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'กรุณากรอก Email ของคุณ'.tr();
                        }
                        return null;
                      },
                      decoration: InputDecoration.collapsed(
                        hintText: 'กรุณากรอก Email ของคุณ'.tr(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                    child: Text(
                      'รีเซ็ต'.tr(),
                      style: const TextStyle(
                        color: Colors.lightGreen,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      if (globalKey.currentState!.validate()) {
                        globalKey.currentState!.save();
                        try {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(
                                email: "${accUser.email}",
                              )
                              .then((value) => () {
                                    globalKey.currentState!.reset();
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const Login();
                                    }));
                                  });
                          Fluttertoast.showToast(
                              msg:
                                  "การเปลี่ยนรหัสผ่านได้ถูกส่งไปยังอีเมลของคุณแล้ว"
                                      .tr(),
                              gravity: ToastGravity.CENTER);
                          Navigator.pop(context);
                        } on FirebaseAuthException catch (e) {
                          Fluttertoast.showToast(
                              msg: e.message!, gravity: ToastGravity.CENTER);
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
