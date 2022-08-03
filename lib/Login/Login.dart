// ignore_for_file: file_names, use_build_context_synchronously, library_private_types_in_public_api, depend_on_referenced_packages

import 'package:exchange_experience/Admin/home.dart';
import 'package:exchange_experience/Login/ForgetPassword.dart';
import 'package:exchange_experience/Login/Register.dart';
import 'package:exchange_experience/Login/keepAccEachUser_Login&Post.dart';
import 'package:exchange_experience/Profile/ChangeLanguage.dart';
import 'package:exchange_experience/Scaffold.dart';
import 'package:exchange_experience/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:easy_localization/easy_localization.dart';

// https://www.youtube.com/watch?v=zNjxDUmkseA&list=PLltVQYLz1BMBUgyhxZFA31of-EKjazC8G&index=5

String checkCurrentUser = '';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final globalKey = GlobalKey<FormState>();
  final Future<FirebaseApp> fireBase = Firebase.initializeApp();
  AccountUserLogin accUser = AccountUserLogin();
  bool obscure = true;
  Color color = Colors.white;
  var icon = Icons.visibility_off;

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

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: SizedBox(
                height: MediaQuery.of(context).size.height * .5,
                child: const CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: Colors.lightGreen,
              body: SingleChildScrollView(
                child: Form(
                  key: globalKey,
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
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
                          height: 60,
                        ),
                        Center(
                          child: Text(
                            'เข้าสู่ระบบ'.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            icon: const Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            hintText: 'Email'.tr(),
                            hintStyle: const TextStyle(color: Colors.white),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText:
                                    'กรุณากรอกอีเมลของคุณให้ถูกต้อง'.tr()),
                            EmailValidator(
                                errorText:
                                    'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง'.tr())
                          ]),
                          onSaved: (String? email) {
                            accUser.email = email;
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          obscureText: obscure,
                          decoration: InputDecoration(
                            icon: const Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
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
                            hintText: 'รหัสผ่าน'.tr(),
                            hintStyle: const TextStyle(color: Colors.white),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (password) {
                            if (password!.isEmpty) {
                              return 'กรุณากรอกรหัสผ่านของคุณให้ถูกต้อง'.tr();
                            }
                            return null;
                          },
                          onSaved: (String? password) {
                            accUser.password = password;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextButton(
                          child: Text(
                            'ลืมรหัสผ่าน'.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const ForgetPassword();
                            }));
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              padding:
                                  const EdgeInsets.fromLTRB(35, 20, 35, 20),
                            ),
                            onPressed: () async {
                              if (globalKey.currentState!.validate()) {
                                globalKey.currentState!.save();
                                try {
                                  FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: accUser.email!,
                                          password: accUser.password!)
                                      .then((value) async {
                                    globalKey.currentState!.reset();

                                    if (accUser.email == 'admin@exchange.com') {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ShowData(),
                                        ),
                                      );
                                    } else {
                                      numItemValue(0);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MainPage(),
                                        ),
                                      );
                                    }
                                  });
                                } on FirebaseAuthException catch (e) {
                                  Fluttertoast.showToast(
                                      msg: e.message!,
                                      gravity: ToastGravity.CENTER);
                                }
                              }
                            },
                            child: Text(
                              'เข้าสู่ระบบ'.tr(),
                              style: const TextStyle(
                                color: Colors.lightGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            child: Text(
                              'สมัครสมาชิก'.tr(),
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.lightGreenAccent[100],
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const Register();
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: const Text(
                            '__________________ or __________________',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () async {
                              GoogleSignIn googleSignIn = GoogleSignIn(
                                scopes: [
                                  'https://www.googleapis.com/auth/cloud-platform',
                                ],
                              );
                              GoogleSignInAccount? account =
                                  await googleSignIn.signIn();
                              GoogleSignInAuthentication authentication =
                                  await account!.authentication;
                              FirebaseAuth.instance
                                  .signInWithCredential(
                                GoogleAuthProvider.credential(
                                  accessToken: authentication.accessToken,
                                  idToken: authentication.idToken,
                                ),
                              )
                                  .then(
                                (value) async {
                                  FirebaseFirestore.instance
                                      .collection('Picture')
                                      .add({
                                    'uid': FirebaseAuth
                                        .instance.currentUser!.uid
                                        .toString(),
                                    'url':
                                        'https://firebasestorage.googleapis.com/v0/b/amongexperience.appspot.com/o/Original_ProfilePicture%2FAnatomy-Complete%2BStructure-evation2-edit2.png?alt=media&token=f26fe6ee-8390-4a29-a3cc-3f46f4a472be',
                                  });
                                  FirebaseFirestore.instance
                                      .collection('MostRankUser')
                                      .snapshots()
                                      .forEach((element) {
                                    for (var element in element.docs) {
                                      if (element.get('uid') ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid) {
                                        setState(() {
                                          checkCurrentUser = 'OK';
                                        });
                                      }
                                    }
                                  });
                                  if (checkCurrentUser == '') {
                                    FirebaseFirestore.instance
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
                                    });
                                  }
                                  numItemValue(0);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MainPage(),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 35,
                              width: MediaQuery.of(context).size.width * .6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.g_mobiledata,
                                    size: 30,
                                    color: Colors.orange,
                                  ),
                                  Text(
                                    'เข้าสู่ระบบด้วย Google'.tr(),
                                    style: const TextStyle(
                                        fontSize: 17, color: Colors.orange),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: TextButton(
                            child: Text(
                              'เข้าสู่ระบบโดยไม่ใช้บัญชี'.tr(),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.lightGreenAccent[100],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              try {
                                await FirebaseAuth.instance
                                    .signInAnonymously()
                                    .then((value) {
                                  numItemValue(0);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return const MainPage();
                                    }),
                                  );
                                });
                              } on FirebaseAuthException catch (e) {
                                Fluttertoast.showToast(
                                    msg: e.message!,
                                    gravity: ToastGravity.CENTER);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
