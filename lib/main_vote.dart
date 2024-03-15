import 'package:buzuppro/flavorConfig.dart';
import 'package:buzuppro/main_core.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:flutter/material.dart';
import 'package:vote_enligne/pages/VotePageHome.dart';

final themeVote = Styles().getDefaultAppStyle().copyWith(
      primaryColor: Color(0xFF605E87),
      colorScheme: ColorScheme(
        background: Colors.transparent,
        brightness: Brightness.light,
        primary: Color(0xFF605E87),
        onPrimary: Color(0xFF605E87),
        secondary: ConstantColor.secondColor,
        onSecondary: ConstantColor.secondColor,
        error: ConstantColor.redErrorColor,
        onError: ConstantColor.redErrorColor,
        onBackground: Colors.transparent,
        surface: ConstantColor.backgroundColor,
        onSurface: ConstantColor.backgroundColor,
      ),
      iconTheme: Styles().getDefaultAppStyle().iconTheme.copyWith(color: Colors.white),
      scaffoldBackgroundColor: ConstantColor.backgroundColor,
      dividerColor: ConstantColor.grisColor,
      visualDensity: VisualDensity.comfortable,
    );

final homeVote = VotePageHome();

FlavorConfig voteFlavorConfig = FlavorConfig()
  ..appTitle = ""
  ..imageLocation = ""
  ..home = homeVote
  ..themeData = themeVote;

void main() {
  mainCommon(voteFlavorConfig);
}
