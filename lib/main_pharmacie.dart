import 'package:buzuppro/flavorConfig.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:flutter/material.dart';
import 'package:pharmacie/PharmacieHomePage.dart';

import 'main_core.dart';

final themePharmacie = Styles().getDefaultAppStyle().copyWith(
      primaryColor: ConstantColor.colorVertPharma,
      iconTheme: Styles().getDefaultAppStyle().iconTheme.copyWith(color: ConstantColor.accentColor),
      scaffoldBackgroundColor: ConstantColor.backgroundColor,
      colorScheme: ColorScheme(
        background: ConstantColor.grisColor,
        brightness: Brightness.light,
        primary: ConstantColor.accentColor,
        onPrimary: ConstantColor.accentColor,
        secondary: ConstantColor.secondColor,
        onSecondary: ConstantColor.secondColor,
        error: ConstantColor.redErrorColor,
        onError: ConstantColor.redErrorColor,
        onBackground: ConstantColor.backgroundColor,
        surface: ConstantColor.backgroundColor,
        onSurface: ConstantColor.backgroundColor,
      ),
      dividerColor: ConstantColor.grisColor,
      visualDensity: VisualDensity.comfortable,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ConstantColor.accentColor,
        foregroundColor: Colors.white,
      ),
    );
final homePharmacie = PharmacieHomePage();

FlavorConfig PharmacieFlavorConfig = FlavorConfig()
  ..appTitle = "Pharmacie"
  ..imageLocation = "assets/images/cfa_icon.png"
  ..home = homePharmacie
  ..themeData = themePharmacie;
void main() {
  mainCommon(PharmacieFlavorConfig);
}
