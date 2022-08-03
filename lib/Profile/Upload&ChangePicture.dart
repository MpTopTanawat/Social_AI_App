// ignore_for_file: file_names, invalid_use_of_visible_for_testing_member, non_constant_identifier_names, depend_on_referenced_packages, use_build_context_synchronously, avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:exchange_experience/Group/GroupPage.dart';
import 'package:exchange_experience/ImageOpenCV.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

File? file;
String url =
    'https://firebasestorage.googleapis.com/v0/b/amongexperience.appspot.com/o/Original_ProfilePicture%2FAnatomy-Complete%2BStructure-evation2-edit2.png?alt=media&token=f26fe6ee-8390-4a29-a3cc-3f46f4a472be';

// https://www.youtube.com/watch?v=7NpOONp-VhI&list=PLHk7DPiGKGNBPxPQQkB4royQ9QgjJXAsI&index=60
// https://www.youtube.com/watch?v=jIO00eifRvg&list=PLHk7DPiGKGNBPxPQQkB4royQ9QgjJXAsI&index=209

class UploadPicture extends StatefulWidget {
  const UploadPicture({Key? key}) : super(key: key);

  @override
  State<UploadPicture> createState() => _UploadPictureState();
}

class _UploadPictureState extends State<UploadPicture> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      titlePadding: const EdgeInsets.all(0),
      title: Container(
        alignment: Alignment.topRight,
        child: IconButton(
          icon: const Icon(
            Icons.clear,
            size: 25,
          ),
          onPressed: () {
            setState(() {
              file = null;
            });
            Navigator.pop(context);
          },
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .3,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: file == null
                  ? Image.network(
                      FirebaseAuth.instance.currentUser!.photoURL.toString(),
                    ).image
                  : Image.file(file!).image,
              child: Container(
                alignment: Alignment.lerp(
                    Alignment.bottomCenter, Alignment.bottomRight, .5),
                child: FittedBox(
                  child: file == null
                      ? null
                      : IconButton(
                          icon: const Icon(
                            Icons.brightness_medium,
                            color: Colors.black,
                            size: 40,
                          ),
                          onPressed: file == null
                              ? null
                              : () => showDialog(
                                    context: context,
                                    builder: (context) => const ImageOpenCV(),
                                  ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.add_a_photo),
                iconSize: 38,
                onPressed: () async {
                  var image = await ImagePicker.platform.pickImage(
                    source: ImageSource.camera,
                    maxHeight: 600,
                    maxWidth: 600,
                  );
                  setState(() {
                    file = File(image!.path);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.add_photo_alternate),
                iconSize: 38,
                onPressed: () async {
                  var image = await ImagePicker.platform.pickImage(
                    source: ImageSource.gallery,
                    maxHeight: 600,
                    maxWidth: 600,
                  );
                  setState(() {
                    file = File(image!.path);
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: const Text(
                  'Upload',
                ),
                onPressed: () async {
                  try {
                    if (file != null) {
                      FirebaseStorage storage = FirebaseStorage.instance;
                      Reference reference = storage.ref().child(
                          'Profile/${FirebaseAuth.instance.currentUser!.uid}.png');
                      UploadTask uploadTask = reference.putFile(file!);

                      var task = await (await uploadTask).ref.getDownloadURL();
                      setState(() {
                        url = task.toString();
                      });

                      FirebaseFirestore.instance
                          .collection('Database')
                          .snapshots()
                          .forEach((element) {
                        for (var element in element.docs) {
                          if (element.get('uid') ==
                              FirebaseAuth.instance.currentUser!.uid) {
                            element.reference.update({
                              'image': url,
                            });
                          }
                        }
                      });

                      FirebaseFirestore.instance
                          .collection('Comment')
                          .snapshots()
                          .forEach((element) {
                        for (var element in element.docs) {
                          if (element.get('uidcomment') ==
                              FirebaseAuth.instance.currentUser!.uid) {
                            element.reference.update({
                              'image': url,
                            });
                          }
                        }
                      });

                      FirebaseFirestore.instance
                          .collection("Picture")
                          .snapshots()
                          .forEach((element) {
                        for (var element in element.docs) {
                          if (element.get('uid') ==
                              FirebaseAuth.instance.currentUser!.uid) {
                            element.reference.update({
                              'url': url,
                            });
                          }
                        }
                      });
                      FirebaseFirestore.instance
                          .collection('MostRankUser')
                          .snapshots()
                          .forEach((element) {
                        for (var element in element.docs) {
                          if (element.get('uid') ==
                              FirebaseAuth.instance.currentUser!.uid) {
                            element.reference.update({
                              'image': url,
                            });
                          }
                        }
                      });

                      groupENLang.forEach((element) async {
                        await FirebaseFirestore.instance
                            .collection(element)
                            .snapshots()
                            .forEach((element) {
                          for (var element in element.docs) {
                            if (element.get('uid') ==
                                FirebaseAuth.instance.currentUser!.uid) {
                              element.reference.update({
                                'image': url,
                              });
                            }
                          }
                        });
                      });

                      await FirebaseAuth.instance.currentUser!
                          .updatePhotoURL(url);
                      setState(() {
                        file = null;
                      });

                      Navigator.pop(context);
                    }
                  } catch (e) {
                    Fluttertoast.showToast(msg: e.toString());
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
