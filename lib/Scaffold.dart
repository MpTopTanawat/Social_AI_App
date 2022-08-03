// ignore_for_file: file_names, depend_on_referenced_packages, use_build_context_synchronously

import 'package:exchange_experience/Post/PostBox.dart';
import 'package:exchange_experience/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool isOpenTag = false;

class SecondScaffold extends StatefulWidget {
  const SecondScaffold({Key? key, required this.func, required this.name})
      : super(key: key);
  final String name;
  final Function() func;

  @override
  State<SecondScaffold> createState() => _SecondScaffoldState();
}

class _SecondScaffoldState extends State<SecondScaffold> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      widget.name;
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent,
        centerTitle: true,
        title: Text(
          widget.name.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        actions: widget.name == 'หน้าหลัก'
            ? [
                if (!FirebaseAuth.instance.currentUser!.isAnonymous)
                  GestureDetector(
                    child: isOpenTag
                        ? const Icon(
                            Icons.toggle_on,
                            color: Colors.amber,
                            size: 30,
                          )
                        : const Icon(
                            Icons.toggle_off,
                            color: Colors.grey,
                            size: 30,
                          ),
                    onTap: () {
                      setState(
                        () {
                          isOpenTag = !isOpenTag;
                          checkTagColor = isOpenTag
                              ? selectColor != Colors.grey &&
                                  selectColor !=
                                      const Color.fromARGB(255, 158, 158, 158)
                              : true;
                        },
                      );
                      numItemValue(0);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainPage(),
                        ),
                      );
                    },
                  ),
                if (!FirebaseAuth.instance.currentUser!.isAnonymous)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(0, 255, 193, 7),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      String msgQRCode =
                          await FlutterBarcodeScanner.scanBarcode(
                              '#ff6666', 'CANCEL', true, ScanMode.DEFAULT);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SecondScaffold(
                            name: 'Message after Scanning QR Code',
                            func: () => Scaffold(
                              body: Container(
                                alignment: Alignment.center,
                                child: Text(msgQRCode),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.grey,
                    ),
                  ),
              ]
            : null,
      ),
      body: widget.func(),
    );
  }
}
