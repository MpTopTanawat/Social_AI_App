// ignore_for_file: depend_on_referenced_packages

import 'package:exchange_experience/Login/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  timeago.setLocaleMessages('th', timeago.ThMessages());
  timeago.setLocaleMessages(
      'th_short', timeago.ThShortMessages()); // แบบมาตรฐาน

  runApp(
    EasyLocalization(
      fallbackLocale: const Locale('th', 'TH'),
      path: 'assets/Translate',
      supportedLocales: const [Locale('th', 'TH'), Locale('en', 'US')],
      useFallbackTranslations: true,
      startLocale: const Locale('th', 'TH'),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Logo App',
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        backgroundColor: Colors.lightGreen,
        splash: Image.asset('Images/LogoApp.png'),
        splashIconSize: 140,
        animationDuration: const Duration(seconds: 1),
        nextScreen: const Login(),
        pageTransitionType: PageTransitionType.leftToRight,
        splashTransition: SplashTransition.scaleTransition,
      ),
    );
  }
}
