// ignore_for_file: file_names, depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ChangeMultiLingual extends StatefulWidget {
  const ChangeMultiLingual({Key? key}) : super(key: key);

  @override
  State<ChangeMultiLingual> createState() => _ChangeMultiLingualState();
}

class _ChangeMultiLingualState extends State<ChangeMultiLingual> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            title: Text('ภาษาไทย'.tr()),
            onTap: () {
              setState(() {
                context.locale = const Locale('th', 'TH');
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('ภาษาอังกฤษ'.tr()),
            onTap: () {
              setState(() {
                context.locale = const Locale('en', 'US');
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
