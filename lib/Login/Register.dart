// ignore_for_file: file_names, depend_on_referenced_packages, library_private_types_in_public_api, invalid_use_of_visible_for_testing_member

import 'dart:io';

import 'package:exchange_experience/Login/Login.dart';
import 'package:exchange_experience/Login/keepAccEachUser_Login&Post.dart';
import 'package:exchange_experience/Profile/ChangeLanguage.dart';
import 'package:exchange_experience/Scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:easy_localization/easy_localization.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final globalKey = GlobalKey<FormState>();
  File? file;
  String getPath = '';
  String url =
      'https://firebasestorage.googleapis.com/v0/b/amongexperience.appspot.com/o/Original_ProfilePicture%2FAnatomy-Complete%2BStructure-evation2-edit2.png?alt=media&token=f26fe6ee-8390-4a29-a3cc-3f46f4a472be';
  AccountUserLogin accUser = AccountUserLogin();
  final Future<FirebaseApp> fireBase = Firebase.initializeApp();
  String name = '';
  bool obscure = true;
  Color color = Colors.white;
  var icon = Icons.visibility_off;
  @override
  void initState() {
    name = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      context.locale;
    });
    return FutureBuilder(
      future: fireBase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("it has some Error"),
            ),
            body: Center(
              child: Text("${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.lightGreen,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: globalKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(
                                Icons.language,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SecondScaffold(
                                    func: () => const SafeArea(
                                      child: ChangeMultiLingual(),
                                    ),
                                    name: 'เปลี่ยนภาษา'.tr(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Center(
                            child: Text(
                              "สมัครสมาชิก".tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 45,
                          ),
                          Text(
                            'กรุณากรอกชื่อของคุณ'.tr(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          TextFormField(
                            validator: RequiredValidator(
                              errorText: "กรุณากรอกชื่อของคุณ".tr(),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            keyboardType: TextInputType.text,
                            onSaved: (name) {
                              setState(() {
                                this.name = name!;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            'กรุณากรอกอีเมลของคุณ'.tr(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          TextFormField(
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "กรุณากรอกอีเมลของคุณ".tr()),
                              EmailValidator(
                                  errorText:
                                      'กรุณากรอกอีเมลของคุณให้ถูกต้อง'.tr())
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            onSaved: (String? email) {
                              accUser.email = email!;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            'กรุณากรอกรหัสผ่านของคุณ'.tr(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  icon,
                                  color: color,
                                ),
                                onTap: () {
                                  setState(() {
                                    obscure = !obscure;
                                    if (color == Colors.white) {
                                      color = const Color.fromARGB(
                                          255, 248, 204, 140);
                                    } else {
                                      color = Colors.white;
                                    }

                                    if (icon == Icons.visibility) {
                                      icon = Icons.visibility_off;
                                    } else {
                                      icon = Icons.visibility;
                                    }
                                  });
                                },
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            validator: RequiredValidator(
                              errorText: "กรุณากรอกรหัสผ่านของคุณ".tr(),
                            ),
                            // สำหรับยังไม่ได้กรอกรหัสผ่าน
                            obscureText: obscure,

                            onSaved: (String? password) {
                              accUser.password = password;
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    ClipRRect(
                                      clipBehavior: Clip.hardEdge,
                                      child: file == null
                                          ? Container()
                                          : Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image:
                                                      Image.file(file!).image,
                                                ),
                                              ),
                                            ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                      ),
                                      child: Text(
                                        'อัพโหลดรูป'.tr(),
                                        style: const TextStyle(
                                          color: Colors.lightGreen,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () async {
                                        var image = await ImagePicker.platform
                                            .pickImage(
                                          source: ImageSource.gallery,
                                          maxHeight: 600,
                                          maxWidth: 600,
                                        );
                                        setState(() {
                                          file = File(image!.path);
                                          getPath = image.path;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: Text(
                                    getPath,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 10),
                              ),
                              onPressed: () async {
                                if (globalKey.currentState!.validate()) {
                                  globalKey.currentState!.save();
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: accUser.email!,
                                            password: accUser.password!);
                                    await FirebaseAuth.instance.currentUser!
                                        .sendEmailVerification();
                                    if (file != null) {
                                      FirebaseStorage storage =
                                          FirebaseStorage.instance;
                                      Reference reference = storage.ref().child(
                                          'Profile/${FirebaseAuth.instance.currentUser!.uid}.png');
                                      UploadTask uploadTask =
                                          reference.putFile(file!);

                                      var task = await (await uploadTask)
                                          .ref
                                          .getDownloadURL();
                                      setState(() {
                                        url = task;
                                      });
                                    }
                                    await FirebaseFirestore.instance
                                        .collection('Picture')
                                        .add({
                                      'uid': FirebaseAuth
                                          .instance.currentUser!.uid
                                          .toString(),
                                      'url': url,
                                    });
                                    await FirebaseAuth.instance.currentUser!
                                        .updatePhotoURL(url);

                                    await FirebaseAuth.instance.currentUser!
                                        .updateDisplayName(name);

                                    await FirebaseFirestore.instance
                                        .collection('MostRankUser')
                                        .add({
                                      'uid': FirebaseAuth
                                          .instance.currentUser!.uid,
                                      'name': FirebaseAuth
                                          .instance.currentUser!.displayName,
                                      'image': FirebaseAuth
                                          .instance.currentUser!.photoURL,
                                      'postScore': 0,
                                      'commentScore': 0,
                                      'shareScore': 0,
                                    }).then((value) {
                                      globalKey.currentState!.reset();
                                      Fluttertoast.showToast(
                                          msg: "คุณได้สมัครสมาชิกเรียบร้อยแล้ว"
                                              .tr(),
                                          gravity: ToastGravity.CENTER);
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const Login();
                                      }));
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    Fluttertoast.showToast(
                                        msg: e.message!,
                                        gravity: ToastGravity.CENTER);
                                  }
                                }
                              },
                              child: Text(
                                'สมัครสมาชิก'.tr(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.lightGreen,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'คุณมีบัญชีแล้วใช่ไหม? '.tr(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Login(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'เข้าสู่ระบบ'.tr(),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.lightGreenAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return const Login();
      },
    );
  }
}
