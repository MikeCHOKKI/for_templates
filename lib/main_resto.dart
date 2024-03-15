import 'package:buzuppro/flavorConfig.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:flutter/material.dart';
import 'package:resto/RestoHomePage.dart';

import 'main_core.dart';

final themeResto = Styles().getDefaultAppStyle().copyWith(
      primaryColor: Color(0xFFEC9300),
      iconTheme: Styles().getDefaultAppStyle().iconTheme.copyWith(color: ConstantColor.accentColor),
      scaffoldBackgroundColor: ConstantColor.backgroundColor,
      colorScheme: ColorScheme(
        background: Colors.transparent,
        brightness: Brightness.light,
        primary: Color(0xFFEC9300),
        onPrimary: Color(0xFFEC9300),
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
final homeResto = RestoHomePage();

FlavorConfig restoFlavorConfig = FlavorConfig()
  ..appTitle = "Restaurant"
  ..imageLocation = "assets/images/cfa_icon.png"
  ..home = homeResto
  ..themeData = themeResto;
void main() {
  mainCommon(restoFlavorConfig);
}
