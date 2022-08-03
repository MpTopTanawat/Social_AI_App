// ignore_for_file: file_names, invalid_use_of_visible_for_testing_member, depend_on_referenced_packages, import_of_legacy_library_into_null_safe, use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:exchange_experience/DropDownButton/Agree_Positive.dart';
import 'package:exchange_experience/Group/GroupPage.dart';
import 'package:exchange_experience/HomePage/Comment_AddCategory.dart';
import 'package:exchange_experience/HomePage/ConfirmConsumerShowPostPage.dart';
import 'package:exchange_experience/HomePage/ConsumerShowPostPage_WritePostMessage.dart';
import 'package:exchange_experience/IconFlutter/my_flutter_app_icons.dart';
import 'package:exchange_experience/Post/Post.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:easy_localization/easy_localization.dart';

TextEditingController control = TextEditingController();
final GlobalKey<FormFieldState> checkValidator = GlobalKey();

File? filePost;
String txt =
    ''; // ตัวเช็คการแก้ข้อความไม่ให้ข้อความเดิมแสดงผลเมื่อทำการแก้ไขข้อความในโพสต์

bool checkPictureMsgEmpty = true;
List textInImage = [];
List item = [];
bool isShowAllScroll = true;
bool isLoadEdit = false;
var tagList = [];
String setTagList(String tag) {
  tagList.clear();
  tagList.add(tag);
  return tag;
}

class ImageTagOnEditPost extends StatefulWidget {
  const ImageTagOnEditPost({Key? key}) : super(key: key);

  @override
  State<ImageTagOnEditPost> createState() => _ImageTagOnEditPostState();
}

class _ImageTagOnEditPostState extends State<ImageTagOnEditPost> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      textInImage = textInImage;
    });
    return Container(
      alignment: Alignment.topCenter,
      child: filePost == null
          ? Container()
          : Column(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    child: const Icon(Icons.close),
                    onTap: () {
                      setState(() {
                        filePost = null;
                      });
                    },
                  ),
                ),
                Image.file(filePost!),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Row(
                      children: [
                        for (String text in textInImage)
                          Container(
                            padding: const EdgeInsets.only(
                              left: 2,
                              right: 2,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.black,
                              ),
                              padding: const EdgeInsets.all(2),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange[200],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Row(
                                  children: [
                                    Text('  $text  '),
                                    GestureDetector(
                                      child: const Icon(
                                        Icons.close,
                                        size: 15,
                                      ),
                                      onTap: () {
                                        int i = 0;
                                        while (i <= textInImage.length - 1) {
                                          if (textInImage[i] == text) {
                                            textInImage.removeAt(i);
                                          }
                                          i++;
                                        }
                                        setState(() {
                                          textInImage;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        TextButton(
                          child: const Text('Add SubCategory'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const CommentAddCategory(),
                            );
                            setState(() {
                              textInImage;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class ShowMsgDialog extends StatefulWidget {
  const ShowMsgDialog({
    Key? key,
    this.msg = '',
    required this.snapshot,
    this.index = 0,
    required this.tag,
  }) : super(key: key);
  final String msg;
  final List tag;
  final AsyncSnapshot snapshot;
  final int index;

  @override
  State<ShowMsgDialog> createState() => _ShowMsgDialogState();
}

class _ShowMsgDialogState extends State<ShowMsgDialog> {
  Future<QuerySnapshot> user =
      FirebaseFirestore.instance.collection('GroupName').get();
  @override
  void initState() {
    checkPictureMsgEmpty = widget.msg == '';
    txt = '';
    control.clear();
    super.initState();
  }

  void setStatePicture() {
    setState(() {
      textInImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: user,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Something went wrong'),
            ),
            body: Center(
              child: Text(snapshot.hasError.toString()),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 550,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (isLoadEdit) {
          return Container(
            padding: const EdgeInsets.all(60),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Just A Minute',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 223, 177, 107),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                CircularProgressIndicator(
                  color: Color.fromARGB(255, 223, 177, 107),
                ),
              ],
            ),
          );
        }

        item = snapshot.data!.docs[0].get('enName');

        return Form(
          key: formkey,
          child: SingleChildScrollView(
            child: AlertDialog(
              insetPadding: const EdgeInsets.fromLTRB(12, 70, 12, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.5),
              ),
              backgroundColor: Colors.lightGreenAccent,
              title: Text(
                'เขียนข้อความ'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actionsPadding: const EdgeInsets.only(
                left: 5,
                right: 5,
              ),
              actions: [
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        color: Colors.white,
                        child: TextFormField(
                          controller: textSpeechMsg != ""
                              ? control =
                                  TextEditingController(text: textSpeechMsg)
                              : widget.msg != '' && txt == ''
                                  ? control =
                                      TextEditingController(text: widget.msg)
                                  : control,
                          style: const TextStyle(
                            fontSize: 27,
                          ),
                          autofocus: true,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'ลองแชร์แนวคิดเจ๋งๆของคุณดูสิ !!'.tr(),
                            hintStyle: const TextStyle(fontSize: 18),
                            border: InputBorder.none,
                          ),
                          onChanged: (text) => setState(() {
                            txt = text;
                            if (text == '') txt = 'text';
                          }),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'กรุณาใส่รายละเอียดเนื้อหา ^ ^'.tr();
                            }
                            if (tagList == [] || tagList.isEmpty) {
                              return 'กรุณาเลือก Tag ที่เกี่ยวข้อง ^ ^'.tr();
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      checkPictureMsgEmpty
                          ? Container()
                          : filePost != null
                              ? const ImageTagOnEditPost()
                              : Container(),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              MyFlutterApp.doc_text_inv,
                              color: Color.fromARGB(255, 84, 83, 83),
                            ),
                            iconSize: 35,
                            onPressed: () async {
                              try {
                                final image = await ImagePicker.platform
                                    .pickImage(source: ImageSource.gallery);
                                File file = File(image!.path);

                                final GoogleVisionImage googleVisionImage =
                                    GoogleVisionImage.fromFile(file);

                                final TextRecognizer textRecognizer =
                                    GoogleVision.instance.textRecognizer();
                                final VisionText visionText =
                                    await textRecognizer
                                        .processImage(googleVisionImage);

                                String text = '';
                                for (TextBlock textBlock in visionText.blocks) {
                                  final String? textB = textBlock.text;
                                  text += textB!;
                                }
                                setState(() {
                                  textSpeechMsg = text;
                                });
                                textRecognizer.close();
                              } catch (e) {
                                Fluttertoast.showToast(
                                    msg: 'Something ERROR\nPLS TRY AGAIN');
                                Fluttertoast.showToast(msg: e.toString());
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              isSpeech ? Icons.mic : Icons.mic_none,
                              color: const Color.fromARGB(255, 84, 83, 83),
                            ),
                            iconSize: 35,
                            onPressed: () async {
                              // https://www.youtube.com/watch?v=wDWoD1AaLu8
                              try {
                                if (!isSpeech) {
                                  setState(() {
                                    textSpeechMsg = '';
                                  });

                                  bool available =
                                      await speechToText.initialize();

                                  if (available) {
                                    speechToText.listen(
                                      onResult: (result) => setState(() {
                                        textSpeechMsg = result.recognizedWords;
                                      }),
                                    );
                                    setState(() => isSpeech = true);
                                  }
                                } else {
                                  setState(() => isSpeech = false);
                                  speechToText.stop();
                                }
                              } catch (e) {
                                Fluttertoast.showToast(
                                    msg: 'Something ERROR\nPLS TRY AGAIN');
                                Fluttertoast.showToast(msg: e.toString());
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Color.fromARGB(255, 130, 91, 32),
                      ),
                      iconSize: 35,
                      onPressed: () async {
                        var image = await ImagePicker.platform.pickImage(
                          maxHeight: 600,
                          maxWidth: 600,
                          source: ImageSource.camera,
                        );
                        setState(() {
                          textInImage.clear();
                          filePost = File(image!.path);
                          checkPictureMsgEmpty = false;
                        });
                        final GoogleVisionImage googleVisionImage =
                            GoogleVisionImage.fromFile(filePost!);
                        final ImageLabeler imageLabeler =
                            GoogleVision.instance.imageLabeler();
                        final List<ImageLabel> labels =
                            await imageLabeler.processImage(googleVisionImage);

                        for (ImageLabel label in labels) {
                          textInImage.add(label.text);
                        }

                        setStatePicture();
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.image,
                        color: Color.fromARGB(255, 13, 132, 17),
                      ),
                      iconSize: 35,
                      onPressed: () async {
                        var image = await ImagePicker.platform.pickImage(
                          maxHeight: 600,
                          maxWidth: 600,
                          source: ImageSource.gallery,
                        );
                        setState(() {
                          textInImage.clear();
                          filePost = File(image!.path);
                          checkPictureMsgEmpty = false;
                        });

                        final GoogleVisionImage googleVisionImage =
                            GoogleVisionImage.fromFile(filePost!);
                        final ImageLabeler imageLabeler =
                            GoogleVision.instance.imageLabeler();
                        final List<ImageLabel> labels =
                            await imageLabeler.processImage(googleVisionImage);

                        for (ImageLabel label in labels) {
                          textInImage.add(label.text);
                        }

                        setStatePicture();
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                MultiSelectChipField(
                  initialValue: widget.tag == []
                      ? [
                          for (int i = 0; i <= item.length - 1; i++)
                            if (item[i] == showFeedPostFirebaseFirestore())
                              setTagList(item[i]),
                        ]
                      : widget.tag,
                  key: checkValidator,
                  items: item.map<MultiSelectItem<dynamic>>((value) {
                    return MultiSelectItem(value, value);
                  }).toList(),
                  title: null,
                  showHeader: false,
                  selectedChipColor: Colors.orangeAccent,
                  scroll: isShowAllScroll,
                  decoration:
                      const BoxDecoration(color: Colors.lightGreenAccent),
                  onTap: (value) {
                    setState(() {
                      tagList = value;
                    });
                  },
                ),
                GestureDetector(
                  child: Icon(isShowAllScroll
                      ? Icons.arrow_drop_down
                      : Icons.arrow_drop_up),
                  onTap: () => setState(() {
                    isShowAllScroll = !isShowAllScroll;
                  }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.msg == ''
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              primary: Colors.green,
                            ),
                            child: Text(
                              '\t ${'โพสต์'.tr()} \t',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () async {
                              if (formkey.currentState!.validate() &&
                                  tagList.isNotEmpty) {
                                isSpeech = false;
                                showDialog(
                                  context: context,
                                  builder: (context) => ConfirmPost(
                                    control: control,
                                    postData: postData,
                                    textSpeechMsg: textSpeechMsg,
                                  ),
                                );
                              }
                            },
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              primary: Colors.green,
                            ),
                            child: Text(
                              '\t ${'แก้ไข'.tr()} \t',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () async {
                              try {
                                setState(() {
                                  isLoadEdit = true;
                                });
                                String url = '';
                                int i = Random().nextInt(10000000);
                                if (filePost != null) {
                                  UploadTask dirImage = FirebaseStorage.instance
                                      .ref()
                                      .child('ImagePost/$i.png')
                                      .putFile(filePost!);
                                  String urlTemp = await (await dirImage)
                                      .ref
                                      .getDownloadURL();
                                  setState(() {
                                    url = urlTemp;
                                  });
                                }
                                List tmp = await positiveNegative_AgreeDisagree(
                                    context, control.text, "EditPost");
                                double agreeValue = tmp[2];
                                String toxic = tmp[1];
                                final String subToxic =
                                    toxic.substring(1, toxic.length - 1);
                                final List subToxicList = subToxic.split(', ');
                                List mapToxic = [];
                                for (String text in subToxicList) {
                                  final List tmp = text.split('\': ');

                                  setState(() {
                                    mapToxic.add(
                                        tmp[0].substring(1, tmp[0].length));
                                    mapToxic.add(tmp[1]);
                                  });
                                }
                                final Map<String, double> map = {
                                  mapToxic[0]: double.parse(mapToxic[1]),
                                  mapToxic[2]: double.parse(mapToxic[3]),
                                  mapToxic[4]: double.parse(mapToxic[5]),
                                  mapToxic[6]: double.parse(mapToxic[7]),
                                  mapToxic[8]: double.parse(mapToxic[9]),
                                  mapToxic[10]: double.parse(mapToxic[11]),
                                  mapToxic[12]: double.parse(mapToxic[13]),
                                };

                                await widget
                                    .snapshot.data!.docs[widget.index].reference
                                    .update({
                                  'imagePost': [url, i],
                                  'subCategory': textInImage,
                                  "msg": control.text,
                                  'agreeValue': agreeValue,
                                  'group': tagList,
                                  'toxic': map,
                                });

                                await FirebaseFirestore.instance
                                    .collection('Comment')
                                    .get()
                                    .then((QuerySnapshot querySnapshot) {
                                  for (var element in querySnapshot.docs) {
                                    if (FirebaseAuth
                                                .instance.currentUser!.uid ==
                                            element.get('uidpost') &&
                                        widget.snapshot.data!.docs[widget.index]
                                                .get('msg') ==
                                            element.get('msgpost') &&
                                        widget.snapshot.data!.docs[widget.index]
                                                .get('group') ==
                                            element.get('grouppost') &&
                                        widget.snapshot.data!.docs[widget.index]
                                                .get('date') ==
                                            element.get('datepost')) {
                                      element.reference.update({
                                        'msgpost': widget
                                            .snapshot.data!.docs[widget.index]
                                            .get('msg'),
                                      });
                                    }
                                  }
                                });
                                setState(() {
                                  filePost = null;
                                  isLoadEdit = false;
                                });
                                control.clear();
                                Navigator.pop(context);
                              } catch (e) {
                                Fluttertoast.showToast(
                                    msg: e.toString(),
                                    gravity: ToastGravity.CENTER);
                              }
                            },
                          ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (control.text.isEmpty) {
                          setState(() {
                            isSpeech = false;
                            tagList = [];
                          });

                          control.clear();
                          Navigator.pop(context);
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('คุณกำลังจะออกจากหน้านี้ !!'.tr()),
                                content: Text(
                                  'มีข้อความที่คุณเขียนทิ้งไว้อยู่\nต้องการออกจากหน้านี้หรือไม่ ???'
                                      .tr(),
                                  textAlign: TextAlign.center,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isSpeech = false;
                                            textSpeechMsg = "";
                                            tagList = [];
                                          });
                                          control.clear();
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          '\t ${'ใช่'.tr()} \t',
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            filePost = null;
                                          });
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.grey,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          '\t ${'ไม่'.tr()} \t',
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text(
                        '\t ${'ยกเลิก'.tr()} \t',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
