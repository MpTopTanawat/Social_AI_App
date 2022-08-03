// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:easy_localization/easy_localization.dart';

final formkey = GlobalKey<FormState>();
TextEditingController control = TextEditingController();
List<String> list = [
  'Education',
  'Career',
  'GeneralKnowledge',
  'Fashion',
  'Health',
  'Pet',
  'Food_Beverage',
  'Human_Social',
  'Religion',
  'Psychology',
  'Funny',
  'Other'
];

String timeagoText(Timestamp datetime) {
  var dateNow = DateTime.now(); // เวลาที่อยู่ในเครื่อง
  var diffTime = dateNow.difference(datetime.toDate());
  // เอาเวลาที่อยู่ในเครื่อง(date_now) เทียบกับ เวลาที่โพสถูกสร้างขึ้น
  var subTimeAgo = dateNow.subtract(diffTime);
  var timeAgo = timeago.format(subTimeAgo, locale: 'th'.tr());

  return timeAgo;
}
