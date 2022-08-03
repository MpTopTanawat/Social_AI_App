// ignore_for_file: depend_on_referenced_packages, file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

String txt = '';

class GroupUser extends StatefulWidget {
  const GroupUser({Key? key}) : super(key: key);

  @override
  State<GroupUser> createState() => _GroupUserState();
}

class _GroupUserState extends State<GroupUser> {
  final stream = FirebaseFirestore.instance.collection('GroupName').snapshots();
  @override
  void initState() {
    txt = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
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

        List groupName = snapshot.data!.docs[0].get('thName');
        return Scaffold(
          appBar: AppBar(
            title: const Text('Group'),
            backgroundColor: Colors.lightGreen,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            'เพิ่มข้อความ',
                            textAlign: TextAlign.center,
                          ),
                          content: TextFormField(
                            validator: (String? value) {
                              if (value == '' || value!.isEmpty) {
                                return 'กรุณาใส่ชื่อกลุ่มที่ต้องการเพิ่ม';
                              }
                              return null;
                            },
                            onChanged: (value) => setState(
                              () => txt = value,
                            ),
                          ),
                          actionsAlignment: MainAxisAlignment.spaceBetween,
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.green,
                              ),
                              onPressed: () {
                                groupName.add(txt);
                                snapshot.data!.docs[0].reference.update({
                                  'thName': groupName,
                                });
                                Fluttertoast.showToast(
                                    msg: 'ทำการเพิ่มข้อมูลสำเร็จ');
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "เพิ่ม",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.grey,
                              ),
                              child: const Text(
                                'ยกเลิก',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  txt = '';
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      });
                },
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i <= groupName.length - 1; i++)
                    Container(
                      margin: const EdgeInsets.only(
                        right: 6,
                        left: 6,
                      ),
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              groupName[i],
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            DropdownButton(
                              items: ['แก้ไข', 'ลบ']
                                  .map((String button) => DropdownMenuItem(
                                        value: button,
                                        child: Text(button),
                                      ))
                                  .toList(),
                              onChanged: (String? button) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    if (button == 'ลบ') {
                                      return AlertDialog(
                                        title: const Text(
                                          'ต้องการลบหรือไม่ ?',
                                          textAlign: TextAlign.center,
                                        ),
                                        actionsAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        actions: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              primary: Colors.green,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                groupName.removeAt(i);
                                                snapshot.data!.docs[0].reference
                                                    .update({
                                                  'thName': groupName,
                                                });
                                              });
                                              Fluttertoast.showToast(
                                                  msg: 'ทำการลบสำเร็จ');
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              button!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              primary: Colors.grey,
                                            ),
                                            child: const Text(
                                              'ยกเลิก',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ],
                                      );
                                    }

                                    return AlertDialog(
                                      title: Text(
                                        '$buttonข้อความ',
                                        textAlign: TextAlign.center,
                                      ),
                                      content: TextFormField(
                                        validator: (String? value) {
                                          if (value == '' || value!.isEmpty) {
                                            return 'กรุณาใส่ชื่อกลุ่มที่ต้องการแก้ไข';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) => setState(
                                          () => txt = value,
                                        ),
                                      ),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      actions: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.green,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              groupName[i] = txt;
                                              snapshot.data!.docs[0].reference
                                                  .update({
                                                'thName': groupName,
                                              });
                                            });
                                            Fluttertoast.showToast(
                                                msg: 'ทำการแก้ไขเรียบร้อย');
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            button!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.grey,
                                          ),
                                          child: const Text(
                                            'ยกเลิก',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              txt = '';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              underline: const Text(''),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
