//ignore_for_file: file_names, depend_on_referenced_packages

// import 'package:exchange_experience/Group/GroupPage.dart';
// import 'package:exchange_experience/Post/AlertDialogAnonymus.dart';
// import 'package:exchange_experience/Post/Like_(All)Comment_ShareMethod.dart';
// import 'package:exchange_experience/Post/StreamBuild.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// Color isLike = Colors.grey;
// // int likeNumber = 0;
// String checkLike = '';

// class LikeClick extends StatefulWidget {
//   const LikeClick({Key? key}) : super(key: key);

//   @override
//   State<LikeClick> createState() => _LikeClickState();
// }

// class _LikeClickState extends State<LikeClick> {
//   int index = setIndex();

//   @override
//   Widget build(BuildContext context) {
//     return streamBuild(
//         TextEditingController.fromValue(TextEditingValue.empty),
//         context,
//         index,
//         'LikeClick',
//         'Database',
//         showFeedPostFirebaseFirestore() == "Rank" ? "like" : "date",
//         '',
//         [],
//         '',
//         Timestamp.now(),
//         'UnDocument',
//         "No checkAgreeValuePositiveValue");
//   }
// }

// // Widget like(AsyncSnapshot snapshot, BuildContext context, int index) {
// //   try {
// //     likeNumber = snapshot.data!.docs[index].get('like');
// //     String checkLikeTemp = '^ ^';
// //     List checkLike = snapshot.data!.docs[index].get('checklike');
// //     for (var element in checkLike) {
// //       if (element == FirebaseAuth.instance.currentUser!.uid) {
// //         checkLikeTemp = 'Have UID User in Field of on Database Collection';
// //       }
// //     }
// //     if (checkLikeTemp == '^ ^') {
// //       snapshot.data!.docs[index].reference.update({
// //         FirebaseAuth.instance.currentUser!.uid: 'grey',
// //         'checklike': '$checkLike${FirebaseAuth.instance.currentUser!.uid}_',
// //       });
// //     }

// //     return ElevatedButton(
// //       style: ElevatedButton.styleFrom(
// //         padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
// //         primary: Colors.grey[200],
// //         elevation: 0,
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(0),
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           Icon(
// //             Icons.favorite,
// //             color: snapshot.data!.docs[index]
// //                         .get(FirebaseAuth.instance.currentUser!.uid) ==
// //                     'red'
// //                 ? Colors.red
// //                 : Colors.grey, //isLike,
// //           ),
// //           Text(
// //             '${snapshot.data!.docs[index].get('like')}',
// //             style: const TextStyle(
// //               color: Colors.black,
// //             ),
// //           ),
// //         ],
// //       ),
// //       onPressed: () {
// //         if (FirebaseAuth.instance.currentUser!.isAnonymous) {
// //           showDialog(
// //             context: context,
// //             builder: (BuildContext context) => alertDialogForAnonymus(context),
// //           );
// //         } else if (!FirebaseAuth.instance.currentUser!.isAnonymous) {
// //           likeNumber = snapshot.data!.docs[index].get('like');

// //           if (snapshot.data!.docs[index]
// //                   .get(FirebaseAuth.instance.currentUser!.uid) ==
// //               'red') {
// //             isLike = Colors.red;
// //           } else {
// //             isLike = Colors.grey;
// //           }

// //           if (isLike == Colors.grey) {
// //             snapshot.data!.docs[index].reference.update({
// //               FirebaseAuth.instance.currentUser!.uid: 'red',
// //               'like': ++likeNumber,
// //               'likeRankTopTen': snapshot.data!.docs[index].get('like') + 1,
// //             });
// //           } else // if (isLike == Colors.red)
// //           {
// //             snapshot.data!.docs[index].reference.update({
// //               FirebaseAuth.instance.currentUser!.uid: 'grey',
// //               'like': --likeNumber,
// //               'likeRankTopTen': snapshot.data!.docs[index].get('like') - 1,
// //             });
// //           }
// //         }
// //       },
// //     );
// //   } catch (e) {
// //     return Container();
// //   }
// // }

// class Like extends StatefulWidget {
//   const Like({Key? key, required this.snapshot, required this.index})
//       : super(key: key);
//   final AsyncSnapshot<QuerySnapshot> snapshot;
//   final int index;

//   @override
//   State<Like> createState() => _LikeState();
// }

// class _LikeState extends State<Like> {
//   // int index = setIndex();
//   @override
//   Widget build(BuildContext context) {
//     try {
//       int likeNumber = widget.snapshot.data!.docs[widget.index].get('like');
//       Map<String, dynamic> checkLikeClick =
//           widget.snapshot.data!.docs[widget.index].get('checkLikeClick');
//       String checkLikeTemp = '^ ^';
//       List checkLike =
//           widget.snapshot.data!.docs[widget.index].get('checklike');
//       for (var element in checkLike) {
//         if (element == FirebaseAuth.instance.currentUser!.uid) {
//           // setState(() {
//           //   checkLikeTemp =
//           //       'Have UID User in Field of on Database Collection';
//           // });
//           checkLikeTemp = 'Have UID User in Field of on Database Collection';
//         }
//       }
//       String? color = checkLikeClick[FirebaseAuth.instance.currentUser!.uid];
//       return ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
//           primary: Colors.grey[200],
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(0),
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               Icons.favorite,
//               color: color == 'red' ? Colors.red : Colors.grey, //isLike,
//             ),
//             Text(
//               '${widget.snapshot.data!.docs[widget.index].get('like')}',
//               style: const TextStyle(
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//         onPressed: () {
//           if (FirebaseAuth.instance.currentUser!.isAnonymous) {
//             showDialog(
//               context: context,
//               builder: (BuildContext context) =>
//                   alertDialogForAnonymus(context),
//             );
//           } else if (!FirebaseAuth.instance.currentUser!.isAnonymous) {
//             if (checkLikeTemp == '^ ^') {
//               setState(() {
//                 checkLike.add(FirebaseAuth.instance.currentUser!.uid);
//                 checkLikeClick
//                     .addAll({FirebaseAuth.instance.currentUser!.uid: 'grey'});
//               });
//               widget.snapshot.data!.docs[widget.index].reference.update({
//                 // FirebaseAuth.instance.currentUser!.uid: 'grey',
//                 'checkLikeClick': checkLikeClick,
//                 'checklike': checkLike,
//               });
//             }

//             if (color == 'red') {
//               setState(() {
//                 isLike = Colors.red;
//               });
//             } else {
//               setState(() {
//                 isLike = Colors.grey;
//               });
//             }
//             if (isLike == Colors.grey) {
//               setState(() {
//                 checkLikeClick.update(
//                     FirebaseAuth.instance.currentUser!.uid, (value) => 'red');
//               });
//               widget.snapshot.data!.docs[widget.index].reference.update({
//                 // FirebaseAuth.instance.currentUser!.uid: 'red',
//                 'checkLikeClick': checkLikeClick,
//                 'like': ++likeNumber,
//                 // 'likeRankTopTen':
//                 //     widget.snapshot.data!.docs[widget.index].get('like') + 1,
//               });
//             } else // if (isLike == Colors.red)
//             {
//               setState(() {
//                 checkLikeClick.update(
//                     FirebaseAuth.instance.currentUser!.uid, (value) => 'grey');
//               });
//               widget.snapshot.data!.docs[widget.index].reference.update({
//                 // FirebaseAuth.instance.currentUser!.uid: 'grey',
//                 'checkLikeClick': checkLikeClick,
//                 'like': --likeNumber,
//                 // 'likeRankTopTen':
//                 //     widget.snapshot.data!.docs[widget.index].get('like') - 1,
//               });
//             }
//           }
//         },
//       );
//     } catch (e) {
//       return Container();
//     }
//   }
// }
