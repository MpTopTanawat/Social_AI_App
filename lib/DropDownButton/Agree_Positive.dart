// ignore_for_file: file_names, non_constant_identifier_names, depend_on_referenced_packages

import 'dart:convert';

import 'package:exchange_experience/HomePage/ConfirmConsumerShowPostPage.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:translator/translator.dart';
import 'package:flutter/material.dart';

positiveNegative_AgreeDisagree(
    BuildContext context, String msg, String post_Comment) async {
  try {
    final translator = GoogleTranslator();
    final translationEng = await translator.translate(msg);
    final translationThai =
        await translator.translate(translationEng.text, to: 'th');
    // https://sites.google.com/view/geeky-traveller/app-development/flutter/how-to-link-python-script-py-file-with-flutter-app
    // สามารถทดสอบโดยการรันบนเว็บ http://127.0.0.1:5000/api?Query="ข้อความภาษาไทย``` ````:฿*ข้อความภาษาอังกฤษ"
    String text = '$msg``` ````:฿*${translationEng.text}';
    if (translationEng.sourceLanguage.toString() != 'Thai') {
      text = '${translationThai.text}``` ````:฿*${translationEng.text}';
    }

    final String url = 'http://10.0.2.2:5000/api?Query=$text';

    // เอาข้อมูลมาเก็บไว้ใน dart
    http.Response httpResponse = await http.get(Uri.parse(url));
    var data = httpResponse.body;
    var decodeData = jsonDecode(data);

    List negativePositive = [
      'Positive',
      decodeData['confidence1'],
      "Negative",
      decodeData['confidence2'],
      'Neutral',
      decodeData['confidence3']
    ];
    return [negativePositive, decodeData['toxic'], decodeData['value']];
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
    isLoad = false;
    if (post_Comment == "Comment") {
      Navigator.pop(context);
    }
  }
}
