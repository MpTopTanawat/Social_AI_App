// ignore_for_file: file_names

import 'package:exchange_experience/HomePage/ShowMsgDialog.dart';
import 'package:flutter/material.dart';

class CommentAddCategory extends StatefulWidget {
  const CommentAddCategory({Key? key}) : super(key: key);

  @override
  State<CommentAddCategory> createState() => _CommentAddCategoryState();
}

class _CommentAddCategoryState extends State<CommentAddCategory> {
  String text = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(2),
      actions: [
        TextField(
          maxLength: 16,
          onChanged: (value) => setState(
            () => text = value,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: text.length < 2
                  ? null
                  : () {
                      setState(() {
                        textInImage.add(text);
                        textInImage;
                      });
                      Navigator.pop(context);
                    },
              child: const Text('OKay'),
            ),
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ],
    );
  }
}
