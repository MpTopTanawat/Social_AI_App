// ignore_for_file: depend_on_referenced_packages, file_names, library_private_types_in_public_api

import 'package:exchange_experience/Group/GroupPage.dart';
import 'package:exchange_experience/HomePage/HomePage.dart';
import 'package:exchange_experience/Profile/Profile.dart';
import 'package:exchange_experience/Rank/Rank.dart';
import 'package:exchange_experience/Scaffold.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';

int numItem = 0;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> bottomNavigation = [
    const Icon(
      Icons.home,
      size: 36,
    ),
    const Icon(
      Icons.group,
      size: 36,
    ),
    const Icon(
      Icons.analytics_outlined,
      size: 36,
    ),
    const Icon(
      Icons.person_outline,
      size: 36,
    ),
  ];
  List list = [
    Center(
      child: SecondScaffold(
        name: 'หน้าหลัก'.tr(),
        func: () => const HomePage(),
      ),
    ),
    Center(
      child: SecondScaffold(
        name: 'กลุ่ม'.tr(),
        func: () => const GroupPage(),
      ),
    ),
    Center(
      child: SecondScaffold(
        name: '10 อันดับโพสต์นิยม'.tr(),
        func: () => const Rank(),
      ),
    ),
    Center(
      child: SecondScaffold(
        name: 'โปรไฟล์'.tr(),
        func: () => const Profile(),
      ),
    ),
  ];
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      setState(() {
        bottomNavigation.removeAt(3);
        bottomNavigation.removeAt(2);
        list.removeAt(2);
        list.removeAt(2);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      bottomNavigation;
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: list.elementAt(numItem),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          items: bottomNavigation,
          index: numItem,
          animationCurve: Curves.easeInToLinear,
          buttonBackgroundColor: Colors.amber,
          backgroundColor: Colors.grey.shade200,
          color: const Color.fromARGB(119, 21, 227, 242),
          onTap: (index) {
            setState(() {
              numItem = index;
              if (numItem != 2) {
                setShowFeedPostFirebaseFirestore('Post');
              } // ชื่อชั้นวางฐานข้อมูล ดาต้าเบส
              if (numItem == 2) {
                setShowFeedPostFirebaseFirestore('Rank');
              }
              if (numItem == 3) setShowFeedPostFirebaseFirestore('Profile');
            });
          },
        ),
      ),
    );
  }
}

void numItemValue(int numItemValue) {
  numItem = numItemValue;
}
