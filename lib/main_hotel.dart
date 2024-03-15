import 'package:buzuppro/flavorConfig.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:flutter/material.dart';
import 'package:hotel/HotelHomePage.dart';

import 'main_core.dart';

final themeHotel = Styles().getDefaultAppStyle().copyWith(
      primaryColor: Color(0xFFFFA430),
      iconTheme: Styles().getDefaultAppStyle().iconTheme.copyWith(color: ConstantColor.accentColor),
      scaffoldBackgroundColor: ConstantColor.backgroundColor,
      colorScheme: ColorScheme(
        background: Colors.transparent,
        brightness: Brightness.light,
        primary: Color(0xFFFFA430),
        onPrimary: Color(0xFFFFA430),
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
final homeHotel = HotelHomePage();
FlavorConfig hotelFlavorConfig = FlavorConfig()
  ..appTitle = "Hôtel"
  ..imageLocation = "assets/images/cfa_icon.png"
  ..home = homeHotel
  ..themeData = themeHotel;
void main() {
  mainCommon(hotelFlavorConfig);
}
