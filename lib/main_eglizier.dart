import 'package:core/common_folder/constantes/styles.dart';
import 'package:eglizier/mobile/LoadBibleDataPage.dart';
import 'package:eglizier/web/EglizierHomePage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'flavorConfig.dart';
import 'main_core.dart';

final accentColor = Color(0xFF000000);
final backgroundColor = Color(0xFFECF0F1);
final grisColor = Color(0xFFE9E9E9);
final primaryMaterialPrimary = MaterialColor(
  0xFF000000,
  const <int, Color>{
    50: Color.fromRGBO(0, 0, 0, .1),
    100: Color.fromRGBO(0, 0, 0, .2),
    200: Color.fromRGBO(0, 0, 0, .3),
    300: Color.fromRGBO(0, 0, 0, .4),
    400: Color.fromRGBO(0, 0, 0, .5),
    500: Color.fromRGBO(0, 0, 0, .6),
    600: Color.fromRGBO(0, 0, 0, .7),
    700: Color.fromRGBO(0, 0, 0, .8),
    800: Color.fromRGBO(0, 0, 0, .9),
    900: Color.fromRGBO(0, 0, 0, 1),
  },
);

final themeEglizier = Styles().getDefaultAppStyle().copyWith(
      primaryColor: accentColor,
      iconTheme: Styles().getDefaultAppStyle().iconTheme.copyWith(color: Colors.white),
      scaffoldBackgroundColor: backgroundColor,
      dividerColor: grisColor,
      visualDensity: VisualDensity.comfortable,
    );
final homeEglizier = kIsWeb ? EglizierHomePage() : LoadBibleDataPage();

FlavorConfig eglizierFlavorConfig = FlavorConfig()
  ..appTitle = "Eglizier"
  ..imageLocation = "assets/images/logo_eglizier_512.png"
  ..home = homeEglizier
  ..themeData = themeEglizier;

void main() {
  mainCommon(eglizierFlavorConfig);
}
