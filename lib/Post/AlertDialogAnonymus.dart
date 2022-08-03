// ignore_for_file: file_names

import 'package:exchange_experience/Login/Login.dart';
import 'package:flutter/material.dart';

Widget alertDialogForAnonymus(BuildContext context) {
  return AlertDialog(
    title: const Text(
      'กรุณาเข้าสู่ระบบด้วยบัญชี เพื่อใช้งาน !!',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 23,
      ),
    ),
    actionsAlignment: MainAxisAlignment.spaceAround,
    actions: [
      ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Login()));
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'ล็อกอิน',
          style: TextStyle(
            fontSize: 22.5,
          ),
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(
          'กลับ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.5,
          ),
        ),
      ),
    ],
  );
}
