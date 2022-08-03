// ignore_for_file: file_names, depend_on_referenced_packages

// import 'package:exchange_experience/Post/Comment.dart';
// import 'package:exchange_experience/DropDownButton/DropDownButtonMethod.dart';
// import 'package:exchange_experience/Post/Post.dart';
// import 'package:exchange_experience/Post/TextNameMethod.dart';
// import 'package:exchange_experience/Profile/Upload&ChangePicture.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// subAComment(
//     AsyncSnapshot<QuerySnapshot> snapshot,
//     BuildContext context,
//     TextEditingController control,
//     String setUidSecondPersonPost,
//     List setGroupSecondPersonPost,
//     String setMsgSecondPersonPost,
//     Timestamp setDateSecondPersonPost) {
//   // bool checkCondition = false;
//   for (int i = 0; i <= snapshot.data!.docs.length - 1; i++) {
//     // int j = 0;
//     // for (var element in setGroupSecondPersonPost) {
//     //   if (element == snapshot.data!.docs[i].get('grouppost')) {
//     //     checkCondition = true;
//     //   }
//     // }
//     print(setGroupSecondPersonPost);
//     print("snapshot = " + snapshot.data!.docs[i].get('grouppost').toString());
//     if (snapshot.data!.docs[i].get('uidpost') == setUidSecondPersonPost &&
//         setGroupSecondPersonPost.toString() ==
//             snapshot.data!.docs[i]
//                 .get('grouppost')
//                 .toString() && // checkCondition &&
//         snapshot.data!.docs[i].get('msgpost') == setMsgSecondPersonPost &&
//         snapshot.data!.docs[i].get('datepost') == setDateSecondPersonPost) {
//       // j = 1;
//       return Container(
//         color: Colors.grey[300],
//         margin: const EdgeInsets.all(10),
//         height: 190,
//         child: Card(
//           color: Colors.grey[100],
//           child: Column(
//             children: [
//               ListTile(
//                 leading: Container(
//                   padding: const EdgeInsets.only(top: 6),
//                   child: CircleAvatar(
//                     radius: 25,
//                     // backgroundImage: ImagePictureFirebase(
//                     //     snapshot.data!.docs[i].get('uidcomment')),
//                     backgroundImage: Image.network(
//                       snapshot.data!.docs[i].get('imagecomment'),
//                     ).image,
//                     child: const FittedBox(),
//                   ),
//                 ),
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     DropDown(
//                         index: i,
//                         snapshot: snapshot,
//                         uid: 'uidcomment',
//                         msg: 'msgcomment',
//                         group: 'grouppost',
//                         item: '',
//                         item2: '',
//                         control: controller,
//                         formkey: formkey),
//                     // dropDown(snapshot, context, i, 'uidcomment', 'msgcomment',
//                     //     'grouppost', '', "", controller, formkey),
//                     textName(snapshot, context, i, 'namecomment', 'uidcomment'),
//                   ],
//                 ),
//                 subtitle: Text(
//                     timeagoText(snapshot.data!.docs[i].get("datecomment"))
//                         .toString()),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               Container(
//                 padding: const EdgeInsets.only(
//                   left: 7,
//                   right: 7,
//                 ),
//                 child: Text(
//                   snapshot.data!.docs[i].get("msgcomment").toString(),
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     fontSize: 25,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Container(
//                 color: Colors.grey,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//     // if (j == 1) break;
//     if (i == snapshot.data!.docs.length - 1 &&
//         (snapshot.data!.docs[i].get('uidpost') != setUidSecondPersonPost ||
//             snapshot.data!.docs[i].get('grouppost') !=
//                 setGroupSecondPersonPost ||
//             snapshot.data!.docs[i].get('msgpost') != setMsgSecondPersonPost ||
//             snapshot.data!.docs[i].get('datepost') !=
//                 setDateSecondPersonPost)) {
//       return Container(
//         color: Colors.grey[300],
//         height: 0,
//         child: const Text(''),
//       );
//     }
//   }
//   return const Card();
// }
