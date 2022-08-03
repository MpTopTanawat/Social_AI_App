// ignore_for_file: file_names, depend_on_referenced_packages, import_of_legacy_library_into_null_safe, use_build_context_synchronously, deprecated_member_use

import 'package:exchange_experience/DropDownButton/DropDownButtonMethod.dart';
import 'package:exchange_experience/Post/Like_(All)Comment_ShareMethod.dart';
import 'package:exchange_experience/Post/Post.dart';
import 'package:exchange_experience/Post/TextNameMethod.dart';
import 'package:exchange_experience/Scaffold.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';

int colorTranslate = 0;
Color selectColor = Colors.grey;
Color colorTemp = Colors.grey;
String rGBA = '';
bool isShowIcon = false;
bool checkTagColor = true;
bool isShowTag = false;
Map toxicity = {};
bool isOpenToxic = false;

class PostBox extends StatefulWidget {
  const PostBox({
    Key? key,
    required this.snapshot,
    required this.index,
  }) : super(key: key);
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int index;

  @override
  State<PostBox> createState() => _PostBoxState();
}

class _PostBoxState extends State<PostBox> {
  @override
  void initState() {
    try {
      toxicity = widget.snapshot.data!.docs[widget.index].get('toxic') ?? {};
      isOpenToxic = toxicity['toxicity'] < .25 &&
          toxicity['severe_toxicity'] < .25 &&
          toxicity['obscene'] < .25 &&
          toxicity['identity_attack'] < .25 &&
          toxicity['insult'] < .25 &&
          toxicity['threat'] < .25 &&
          toxicity['sexual_explicit'] < .25;
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      setState(() {
        selectColor = Colors.grey;
        rGBA = '';
      });
      final List textInImage =
          widget.snapshot.data!.docs[widget.index].get('subCategory');
      final List aRGB = widget.snapshot.data!.docs[widget.index].get('RGBA');
      for (var element in aRGB) {
        final String checkARGB = element;
        final List aARGB = checkARGB.split(',');
        if (aARGB[0] == FirebaseAuth.instance.currentUser!.uid) {
          setState(() {
            rGBA = '';
            selectColor = Color.fromARGB(int.parse(aARGB[4]),
                int.parse(aARGB[1]), int.parse(aARGB[2]), int.parse(aARGB[3]));
          });
        }
      }
      if (isOpenTag) {
        setState(() {
          checkTagColor = selectColor != Colors.grey;
        });
      }
      var tag = widget.snapshot.data!.docs[widget.index].get('group');

      if (checkTagColor) {
        return Card(
          elevation: 3,
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.only(top: 6),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: Image.network(
                      widget.snapshot.data!.docs[widget.index].get('image'),
                    ).image,
                    backgroundColor: Colors.white,
                    child: const FittedBox(),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!FirebaseAuth.instance.currentUser!.isAnonymous)
                      DropDown(
                        snapshot: widget.snapshot,
                        index: widget.index,
                        uid: 'uid',
                        msg: 'msg',
                        group: 'group',
                        item: 'วิเคราะห์ความคิดเห็น',
                        item2: "ความคิดเห็นเชิงบวกและเชิงลบ",
                        control: control,
                        formkey: formkey,
                      ),
                    if (FirebaseAuth.instance.currentUser!.isAnonymous)
                      Container(
                        height: 20,
                      ),
                    textName(
                        widget.snapshot, context, widget.index, 'name', 'uid'),
                  ],
                ),
                subtitle: Row(
                  children: [
                    Text(
                      timeagoText(widget.snapshot.data!.docs[widget.index]
                              .get("date"))
                          .toString(),
                    ),
                    if (!FirebaseAuth.instance.currentUser!.isAnonymous)
                      IconButton(
                        color: colorTranslate == 0
                            ? Colors.blueAccent[100]
                            : Colors.red,
                        icon: const Icon(
                          Icons.music_note,
                          size: 30,
                        ),
                        onPressed: () async {
                          colorTranslate = 1;
                          setState(() {
                            colorTranslate = 1;
                          });
                          await FlutterTts().setLanguage('th-TH');
                          await FlutterTts().setPitch(1);
                          await FlutterTts().speak(widget
                              .snapshot.data!.docs[widget.index]
                              .get('msg'));
                          FlutterTts().setCompletionHandler(
                            () => setState(() {
                              colorTranslate = 0;
                            }),
                          );
                        },
                      ),
                    if (!FirebaseAuth.instance.currentUser!.isAnonymous)
                      IconButton(
                        iconSize: 30,
                        color: selectColor,
                        icon: const Icon(
                          Icons.bookmark,
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => DiaLogColor(
                            snapshot: widget.snapshot,
                            index: widget.index,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 7,
                  right: 7,
                ),
                child: isOpenToxic
                    ? Text(
                        widget.snapshot.data!.docs[widget.index]
                            .get("msg")
                            .toString(),
                        style: const TextStyle(
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : Container(
                        color: Colors.grey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('warning toxic'.tr()),
                            const SizedBox(
                              width: 20,
                            ),
                            TextButton(
                              child: Text(
                                'ดูเพิ่มเติม'.tr(),
                                style: const TextStyle(
                                  color: Colors.tealAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () => setState(() {
                                isOpenToxic = true;
                              }),
                            ),
                          ],
                        ),
                      ),
              ),
              if (widget.snapshot.data!.docs[widget.index].get('shareToFeed') ==
                  'yes')
                Container(
                  color: Colors.grey[100],
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Text(
                            'Shared',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.tealAccent),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Icon(
                            Icons.screen_share_outlined,
                            size: 15,
                            color: Colors.tealAccent,
                          ),
                        ],
                      ),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.only(top: 6),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage: Image.network(
                              widget.snapshot.data!.docs[widget.index]
                                  .get('imagepostshared'),
                            ).image,
                            child: const FittedBox(),
                          ),
                        ),
                        title: Text(
                          widget.snapshot.data!.docs[widget.index]
                              .get("namepostshared")
                              .toString(),
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          timeagoText(widget.snapshot.data!.docs[widget.index]
                                  .get("datepostshared"))
                              .toString(),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        widget.snapshot.data!.docs[widget.index]
                            .get("msgpostshared")
                            .toString(),
                        style: const TextStyle(
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              widget.snapshot.data!.docs[widget.index].get('imagePost')[0] == ''
                  ? Container()
                  : Column(
                      children: [
                        Image.network(
                          widget.snapshot.data!.docs[widget.index]
                              .get('imagePost')[0],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                    child: Text('  $text  '),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  child: isShowTag
                      ? const Icon(Icons.arrow_drop_down)
                      : const Icon(Icons.arrow_drop_up),
                  onTap: () => setState(() => isShowTag = !isShowTag),
                ),
              ),
              isShowTag
                  ? Column(
                      children: [
                        for (int i = 0; i <= tag.length - 1; i++)
                          if (tag[i] != 'Other')
                            Text(
                              '# ${tag[i]}',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                      ],
                    )
                  : Container(),
              const SizedBox(
                height: 15,
              ),
              LikeCommentShare(snapshot: widget.snapshot, index: widget.index),
              CommentInPost(index: widget.index, snapshot: widget.snapshot),
            ],
          ),
        );
      }
      return Container();
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      return Container();
    }
  }
}

class DiaLogColor extends StatefulWidget {
  const DiaLogColor({Key? key, required this.snapshot, required this.index})
      : super(key: key);
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int index;

  @override
  State<DiaLogColor> createState() => _DiaLogColorState();
}

class _DiaLogColorState extends State<DiaLogColor> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Container(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: const Text(
            'PICK A COLOR 😋',
            style: TextStyle(
              fontSize: 30,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        BlockPicker(
          pickerColor: selectColor,
          onColorChanged: (Color value) => setState(() {
            colorTemp = value;
            rGBA = '${value.red},${value.green},${value.blue},${value.alpha}';
          }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              child: const Text('Clear'),
              onPressed: () {
                List rgb = widget.snapshot.data!.docs[widget.index].get('RGBA');
                for (int i = 0; i <= rgb.length - 1; i++) {
                  final String string = rgb[i];
                  final List tmp = string.split(',');
                  if (tmp[0] == FirebaseAuth.instance.currentUser!.uid) {
                    rgb.removeAt(i);
                    widget.snapshot.data!.docs[widget.index].reference.update({
                      'RGBA': rgb,
                    });
                  }
                }
                setState(() {
                  rgb;
                });
              },
            ),
            TextButton(
              child: const Text('more...'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actions: [
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: const Text(
                                'PICK A COLOR 😋',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ColorPicker(
                          showLabel: true,
                          pickerColor: selectColor,
                          onColorChanged: (Color value) {
                            setState(() {
                              colorTemp = value;
                              rGBA =
                                  '${value.red},${value.green},${value.blue},${value.alpha}';
                            });
                          },
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ),
                            child: const Text('SELECT!!'),
                            onPressed: () async {
                              List rGBATemp = widget
                                  .snapshot.data!.docs[widget.index]
                                  .get('RGBA');
                              setState(() {
                                selectColor = colorTemp;
                                rGBATemp.add(
                                    '${FirebaseAuth.instance.currentUser!.uid},$rGBA');
                              });
                              await widget
                                  .snapshot.data!.docs[widget.index].reference
                                  .update({
                                'RGBA': rGBATemp,
                              });
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
            child: const Text('SELECT!!'),
            onPressed: () async {
              List rGBATemp =
                  widget.snapshot.data!.docs[widget.index].get('RGBA');
              setState(() {
                selectColor = colorTemp;
                rGBATemp.add('${FirebaseAuth.instance.currentUser!.uid},$rGBA');
              });
              await widget.snapshot.data!.docs[widget.index].reference.update({
                'RGBA': rGBATemp,
              });
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
