// ignore_for_file: file_names, invalid_use_of_visible_for_testing_member, non_constant_identifier_names, prefer_typing_uninitialized_variables, import_of_legacy_library_into_null_safe, depend_on_referenced_packages, use_build_context_synchronously, avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'dart:typed_data';

import 'package:exchange_experience/Group/GroupPage.dart';
import 'package:exchange_experience/Profile/Upload&ChangePicture.dart';
import 'package:flutter/material.dart';
import 'package:opencv/core/core.dart';
import 'package:opencv/opencv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageOpenCV extends StatefulWidget {
  const ImageOpenCV({Key? key}) : super(key: key);

  @override
  State<ImageOpenCV> createState() => _ImageOpenCVState();
}

class _ImageOpenCVState extends State<ImageOpenCV> {
  var image;
  Uint8List? UintList;
  bool isChangeImage = false;
  String nameValueDropDown = "None";
  Image images = Image.asset("Images/LogoApp.png");
  String msgError = 'กรุณาใส่ภาพ';
  String url =
      'https://firebasestorage.googleapis.com/v0/b/amongexperience.appspot.com/o/Original_ProfilePicture%2FAnatomy-Complete%2BStructure-evation2-edit2.png?alt=media&token=f26fe6ee-8390-4a29-a3cc-3f46f4a472be';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.black),
                    child: Image(
                      image: file != null
                          ? Image.file(file!).image
                          : Image.asset('Images/LogoApp.png').image,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              DropdownButton<String>(
                value: nameValueDropDown,
                items: <String>[
                  'None',
                  'blur',
                  'GaussianBlur',
                  'medianBlur',
                  'bilateralFilter',
                  'boxFilter',
                  'sqrBoxFilter',
                  'filter2D',
                  'dilate',
                  'erode',
                  'morphologyEx',
                  'pyrUp',
                  'pyrDown',
                  'pyrMeanShiftFiltering',
                  'threshold',
                  'adaptiveThreshold',
                  'copyMakeBorder',
                  'sobel',
                  'scharr',
                  'laplacian',
                  'distanceTransform',
                  'resize',
                  'applyColorMap',
                  'houghLines',
                  'houghLinesProbabilistic',
                  'houghCircles',
                  'warpPerspectiveTransform',
                  'grabCut'
                ].map<DropdownMenuItem<String>>((itemValue) {
                  return DropdownMenuItem<String>(
                    value: itemValue,
                    child: Text(itemValue),
                  );
                }).toList(),
                onChanged: (value) async {
                  try {
                    setState(() {
                      nameValueDropDown = value!;
                    });
                    UintList = value == 'None'
                        ? isChangeImage = false
                        : value == 'blur'
                            ? await ImgProc.blur(await file!.readAsBytes(),
                                [45, 45], [20, 30], Core.borderReflect)
                            : value == 'GaussianBlur'
                                ? UintList = await ImgProc.gaussianBlur(
                                    await file!.readAsBytes(), [45, 45], 0)
                                : value == 'medianBlur'
                                    ? await ImgProc.medianBlur(
                                        await file!.readAsBytes(), 45)
                                    : value == 'bilateralFilter'
                                        ? await ImgProc.bilateralFilter(
                                            await file!.readAsBytes(),
                                            15,
                                            80,
                                            80,
                                            Core.borderConstant)
                                        : value == 'boxFilter'
                                            ? await ImgProc.boxFilter(
                                                await file!.readAsBytes(),
                                                50,
                                                [45, 45],
                                                [-1, -1],
                                                true,
                                                Core.borderConstant)
                                            : value == 'sqrBoxFilter'
                                                ? await ImgProc.sqrBoxFilter(
                                                    await file!.readAsBytes(),
                                                    -1,
                                                    [1, 1])
                                                : value == 'filter2D'
                                                    ? await ImgProc.filter2D(
                                                        await file!
                                                            .readAsBytes(),
                                                        -1,
                                                        [2, 2])
                                                    : value == 'dilate'
                                                        ? await ImgProc.dilate(
                                                            await file!
                                                                .readAsBytes(),
                                                            [2, 2])
                                                        : value == 'erode'
                                                            ? await ImgProc.erode(
                                                                await file!
                                                                    .readAsBytes(),
                                                                [2, 2])
                                                            : value == 'morphologyEx'
                                                                ? await ImgProc.morphologyEx(await file!.readAsBytes(), ImgProc.morphTopHat, [5, 5])
                                                                : value == 'pyrUp'
                                                                    ? await ImgProc.pyrUp(await file!.readAsBytes(), [563 * 2, 375 * 2], Core.borderDefault)
                                                                    : value == 'pyrDown'
                                                                        ? await ImgProc.pyrDown(await file!.readAsBytes(), [563 ~/ 2.toInt(), 375 ~/ 2.toInt()], Core.borderDefault)
                                                                        : value == 'pyrMeanShiftFiltering'
                                                                            ? await ImgProc.pyrMeanShiftFiltering(await file!.readAsBytes(), 10, 15)
                                                                            : value == 'threshold'
                                                                                ? await ImgProc.threshold(await file!.readAsBytes(), 80, 255, ImgProc.threshBinary)
                                                                                : value == 'adaptiveThreshold'
                                                                                    ? await ImgProc.adaptiveThreshold(await file!.readAsBytes(), 125, ImgProc.adaptiveThreshMeanC, ImgProc.threshBinary, 11, 12)
                                                                                    : value == 'copyMakeBorder'
                                                                                        ? await ImgProc.copyMakeBorder(await file!.readAsBytes(), 20, 20, 20, 20, Core.borderConstant)
                                                                                        : value == 'sobel'
                                                                                            ? await ImgProc.sobel(await file!.readAsBytes(), -1, 1, 1)
                                                                                            : value == 'scharr'
                                                                                                ? await ImgProc.scharr(await file!.readAsBytes(), ImgProc.cvSCHARR, 0, 1)
                                                                                                : value == 'laplacian'
                                                                                                    ? await ImgProc.laplacian(await file!.readAsBytes(), 10)
                                                                                                    : value == 'resize'
                                                                                                        ? await ImgProc.resize(await file!.readAsBytes(), [500, 500], 0, 0, ImgProc.interArea)
                                                                                                        : value == 'applyColorMap'
                                                                                                            ? await ImgProc.applyColorMap(await file!.readAsBytes(), ImgProc.colorMapHot)
                                                                                                            : value == 'warpPerspectiveTransform'
                                                                                                                ? await ImgProc.warpPerspectiveTransform(await file!.readAsBytes(), sourcePoints: [113, 137, 260, 137, 138, 379, 271, 340], destinationPoints: [0, 0, 612, 0, 0, 459, 612, 459], outputSize: [612, 459])
                                                                                                                : value == 'grabCut'
                                                                                                                    ? await ImgProc.grabCut(await file!.readAsBytes(), px: 0, py: 0, qx: 400, qy: 400, itercount: 1)
                                                                                                                    : null;
                    if (value == 'distanceTransform') {
                      UintList = await ImgProc.threshold(
                          await file!.readAsBytes(),
                          80,
                          255,
                          ImgProc.threshBinary);
                      UintList = await ImgProc.distanceTransform(
                          UintList, ImgProc.distC, 3);
                    } else if (value == 'houghLines') {
                      UintList = await ImgProc.canny(
                          await file!.readAsBytes(), 50, 200);
                      UintList = await ImgProc.houghLines(UintList,
                          threshold: 300, lineColor: "#ff0000");
                    } else if (value == 'houghLinesProbabilistic') {
                      UintList = await ImgProc.canny(
                          await file!.readAsBytes(), 50, 200);
                      UintList = await ImgProc.houghLinesProbabilistic(UintList,
                          threshold: 50,
                          minLineLength: 50,
                          maxLineGap: 10,
                          lineColor: "#ff0000");
                    } else if (value == 'houghCircles') {
                      UintList =
                          await ImgProc.cvtColor(await file!.readAsBytes(), 6);
                      UintList = await ImgProc.houghCircles(UintList,
                          method: 3,
                          dp: 2.1,
                          minDist: 0.1,
                          param1: 150,
                          param2: 100,
                          minRadius: 0,
                          maxRadius: 0);
                    }
                  } catch (e) {
                    Fluttertoast.showToast(msg: e.toString());
                  }
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber[500],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.only(
                        left: 70,
                        right: 70,
                      ),
                    ),
                    onPressed: file == null || nameValueDropDown == 'None'
                        ? () => Text(
                              msgError,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            )
                        : () async {
                            // final dir = await getTemporaryDirectory();
                            // final File files =
                            //     await File('${dir.path}/image.png').create();
                            setState(
                              () {
                                // file = files;
                                // file!.writeAsBytesSync(UintList!);
                                msgError = "";
                                images = Image.memory(UintList!);
                                isChangeImage = true;
                              },
                            );
                          },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: const Text(
                        "Contrast",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  isChangeImage
                      ? Container(
                          margin: const EdgeInsets.only(
                            bottom: 15,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.only(
                                left: 70,
                                right: 70,
                              ),
                            ),
                            onPressed: () async {
                              try {
                                final dir = await getTemporaryDirectory();
                                final File files =
                                    await File('${dir.path}/image.png')
                                        .create();
                                setState(
                                  () {
                                    file = files;
                                    file!.writeAsBytesSync(UintList!);
                                  },
                                );
                                FirebaseStorage storage =
                                    FirebaseStorage.instance;
                                Reference reference = storage.ref().child(
                                    'Profile/${FirebaseAuth.instance.currentUser!.uid}.png');
                                UploadTask uploadTask =
                                    reference.putFile(file!);

                                String task = await (await uploadTask)
                                    .ref
                                    .getDownloadURL();

                                url = task;
                                FirebaseFirestore.instance
                                    .collection('Database')
                                    .snapshots()
                                    .forEach((element) {
                                  for (var element in element.docs) {
                                    if (element.get('uid') ==
                                        FirebaseAuth
                                            .instance.currentUser!.uid) {
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
                                        FirebaseAuth
                                            .instance.currentUser!.uid) {
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
                                        FirebaseAuth
                                            .instance.currentUser!.uid) {
                                      element.reference.update({
                                        'url': url,
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
                                          FirebaseAuth
                                              .instance.currentUser!.uid) {
                                        element.reference.update({
                                          'image': url,
                                        });
                                      }
                                    }
                                  });
                                });
                                FirebaseFirestore.instance
                                    .collection('MostRankUser')
                                    .snapshots()
                                    .forEach((element) {
                                  for (var element in element.docs) {
                                    if (element.get('uid') ==
                                        FirebaseAuth
                                            .instance.currentUser!.uid) {
                                      element.reference.update({
                                        'image': url,
                                      });
                                    }
                                  }
                                });
                                await FirebaseAuth.instance.currentUser!
                                    .updatePhotoURL(url);
                                // setState(() {
                                //   file = null;
                                // });
                                file = null;

                                Navigator.pop(context);
                                Navigator.pop(context);
                              } catch (e) {
                                Fluttertoast.showToast(msg: e.toString());
                              }
                            },
                            child: Container(
                              width: double.maxFinite,
                              alignment: Alignment.center,
                              child: const Text(
                                "Change Image",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              isChangeImage
                  ? Image(
                      image: images.image,
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
