// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

commentAnalyze(
    BuildContext context,
    String agreePositive,
    var commentAmount,
    var commentValue,
    Function() method1,
    Function() method2,
    Function() method3) {
  final double commentvalue0 =
      commentAmount[0] == 0 ? 0 : (commentValue[0] / commentAmount[0]);
  final double commentvalue1 =
      commentAmount[1] == 0 ? 0 : (commentValue[1] / commentAmount[1]);
  final double commentvalue2 =
      commentAmount[2] == 0 ? 0 : (commentValue[2] / commentAmount[2]);
  final double valueTemp = commentvalue0 + commentvalue1 + commentvalue2;
  final double value = valueTemp == 0 ? 1 : valueTemp;

  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 226, 249, 201),
    appBar: AppBar(
      title: Text(
        'วิเคราะห์ความคิดเห็น'.tr(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
      ),
      centerTitle: true,
      backgroundColor: Colors.lightGreenAccent,
    ),
    body: Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .1,
        ),
        Text(
          'วิเคราะห์ความคิดเห็น'.tr(),
          style: const TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 45,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Image(
                          image: Image.asset('Images/Happy2.png').image,
                          height: 55,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          agreePositive == 'Positive' ? 'Positive' : 'Agree',
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      commentAmount[0] == 0
                          ? "0 %"
                          : "${((commentValue[0] / commentAmount[0]) * 100 / value).toStringAsFixed(2)}"
                              " %",
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Image(
                          image: Image.asset('Images/Soso1.png').image,
                          height: 55,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('Neutral'),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      commentAmount[1] == 0
                          ? "0 %"
                          : ((commentValue[1] / commentAmount[1]) * 100 / value)
                                  .toStringAsFixed(2) +
                              " %",
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Image(
                          image: Image.asset('Images/UnHappy.png').image,
                          height: 55,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          agreePositive == 'Positive' ? 'Negative' : 'DisAgree',
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      commentAmount[2] == 0
                          ? '0 %'
                          : ((commentValue[2] / commentAmount[2]) * 100 / value)
                                  .toStringAsFixed(2) +
                              ' %',
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .1,
        ),
        method1(),
        method2(),
        method3(),
      ],
    ),
  );
}
