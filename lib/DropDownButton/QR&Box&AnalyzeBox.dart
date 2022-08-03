// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:exchange_experience/Post/StreamBuild.dart';
import 'package:exchange_experience/Profile/ChangeName.dart';
import 'package:exchange_experience/Scaffold.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:translator/translator.dart';
import 'package:qr_flutter/qr_flutter.dart';

qRCode(BuildContext context, String msg, String name, String date) {
  String message = 'Author : $name\nDate : $date \nMessage : $msg';
  return SecondScaffold(
    name: 'QR Code for read Message',
    func: () => Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: QrImage(
          embeddedImage: Image.asset('Images/LogoApp.png').image,
          embeddedImageStyle: QrEmbeddedImageStyle(
            size: const Size(70, 70),
          ),
          data: message,
          version: QrVersions.auto,
          size: 320,
          gapless: false,
          errorStateBuilder: (context, error) {
            return Container(
              alignment: Alignment.center,
              color: Colors.red,
              child: Text(error.toString()),
            );
          },
        ),
      ),
    ),
  );
}

commentAnalyzeButton(
    BuildContext context,
    TextEditingController control,
    String checkAgreeValuePositiveValue,
    String nameButton,
    int index,
    String uid,
    List group,
    String msg,
    Timestamp date) {
  return elevatedBox(
    context,
    nameButton,
    (() => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightGreenAccent,
            centerTitle: true,
            title: Text(
              nameButton,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SafeArea(
            child: streamBuild(
              control,
              context,
              index,
              'AllComment',
              'Comment',
              'datecomment',
              uid,
              group,
              msg,
              date,
              'Document',
              checkAgreeValuePositiveValue,
            ),
          ),
        )),
  );
}

elevatedSmallBox(BuildContext context, AsyncSnapshot snapshot, String language,
    String sublang, int index, String msg) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      fixedSize: const Size(120, 40),
      primary: Colors.orangeAccent[400],
    ),
    child: Text(
      language,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 8, 78, 11),
      ),
    ),
    onPressed: () async {
      try {
        final translator = GoogleTranslator();
        var input = snapshot.data!.docs[index].get(msg);
        var translation = await translator.translate(input, to: sublang);

        String translationSource =
            '${translation.source} (${translation.sourceLanguage}) == ${translation.text} (${translation.targetLanguage})';

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              scrollable: true,
              backgroundColor: Colors.orangeAccent[100],
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  alignment: Alignment.topRight,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      translation.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      translationSource,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                  ],
                ),
              ],
            );
          },
        );
      } catch (e) {
        Scaffold(
          body: Text(
            'Has Error => $e',
          ),
        );
      }
    },
  );
}
