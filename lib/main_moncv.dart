import 'dart:io';

import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:moncv/pages/MonCVLandingPage.dart';
import 'package:rabtech_fw/Fonctions/MyFonctions.dart';

final homeMonCv = MonCVLandingPage();

final themeMonCV = Styles().getDefaultAppStyle().copyWith(
      primaryColor: ConstantColor.accentColor,
      scaffoldBackgroundColor: Colors.grey.shade200,
      colorScheme: ColorScheme.fromSeed(seedColor: ConstantColor.primaryColor),
      dividerColor: ConstantColor.grisColor,
      visualDensity: VisualDensity.comfortable,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ConstantColor.accentColor,
        foregroundColor: Colors.white,
        iconSize: 12,
      ),
    );

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();
  //usePathUrlStrategy();

  if (!kIsWeb) {
    if (!Platform.isWindows) {
      await Firebase.initializeApp();
    }
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCiVX8RenQVNaatTmWcEe53u3CcrOmRuGs",
        authDomain: "buzup-896cc.firebaseapp.com",
        projectId: "buzup-896cc",
        storageBucket: "buzup-896cc.appspot.com",
        messagingSenderId: "458720174344",
        appId: "1:458720174344:web:1fcc55a6ce05582657ccbd",
      ),
    );
  }
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  runApp(
    MyFonctions().getDefaultMaterial(home: homeMonCv, theme: themeMonCV, title: "Mon CV"),
  );
}
