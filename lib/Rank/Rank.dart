// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:exchange_experience/Profile/ChangeName.dart';
import 'package:exchange_experience/Rank/LikeCommentShare.dart';
import 'package:exchange_experience/Rank/PostCommentShareRank.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

bool isOpenElevatedBox = false;

class Rank extends StatefulWidget {
  const Rank({Key? key}) : super(key: key);

  @override
  State<Rank> createState() => _RankState();
}

class _RankState extends State<Rank> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              elevatedBox(
                context,
                'อันดับไลค์สูงสุด',
                () => likeCommentShareRank('Like', 'like'),
              ),
              elevatedBox(
                context,
                'อันดับความคิดเห็นสูงสุด',
                () => likeCommentShareRank('Comment', 'comment'),
              ),
              elevatedBox(
                context,
                'อันดับแชร์สูงสุด',
                () => likeCommentShareRank('Share', 'share'),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.amber,
                  ),
                  Text(
                    'คะแนนที่ผู้ใช้ตอบสนองมากที่สุด'.tr(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[400],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.amber,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              elevatedBox(
                context,
                'อันดับคะแนนโพสต์สูงสุด',
                () => postCommentShareRank('postScore'),
              ),
              elevatedBox(
                context,
                'อันดับคะแนนความคิดเห็นสูงสุด',
                () => postCommentShareRank('commentScore'),
              ),
              elevatedBox(
                context,
                'อันดับคะแนนแชร์สูงสุด',
                () => postCommentShareRank('shareScore'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
