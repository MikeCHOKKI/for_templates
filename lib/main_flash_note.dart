import 'package:buzuppro/flavorConfig.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:flash_note/FlashNoteHome.dart';
import 'package:flutter/material.dart';

import 'main_core.dart';

final themeFlashNote = Styles().getDefaultAppStyle().copyWith(
      primaryColor: Color(0xFF000000),
      iconTheme: Styles().getDefaultAppStyle().iconTheme.copyWith(color: ConstantColor.accentColor),
      scaffoldBackgroundColor: ConstantColor.backgroundColor,
      colorScheme: ColorScheme(
        background: Colors.transparent,
        brightness: Brightness.light,
        primary: Color(0xFF000000),
        onPrimary: Color(0xFF000000),
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
final homeFlashNote = FlashNoteHome();
FlavorConfig flashNoteFlavorConfig = FlavorConfig()
  ..appTitle = "FlashNote"
  ..imageLocation = "assets/images/ic_buzup.png"
  ..home = homeFlashNote
  ..themeData = themeFlashNote;
void main() {
  mainCommon(flashNoteFlavorConfig);
}
