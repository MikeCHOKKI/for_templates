import 'package:buzuppro/flavorConfig.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:flutter/material.dart';
import 'package:immo/ImmoHomePage.dart';

import 'main_core.dart';

final themeImmo = Styles().getDefaultAppStyle().copyWith(
      primaryColor: Color(0xFF0699DC),
      iconTheme: Styles().getDefaultAppStyle().iconTheme.copyWith(color: ConstantColor.accentColor),
      scaffoldBackgroundColor: ConstantColor.backgroundColor,
      colorScheme: ColorScheme(
        background: Colors.transparent,
        brightness: Brightness.light,
        primary: Color(0xFF0699DC),
        onPrimary: Color(0xFF0699DC),
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
final homeImmo = ImmoHomePage();

FlavorConfig immoFlavorConfig = FlavorConfig()
  ..appTitle = "Immobilier"
  ..imageLocation = "assets/images/cfa_icon.png"
  ..home = homeImmo
  ..themeData = themeImmo;
void main() {
  mainCommon(immoFlavorConfig);
}
