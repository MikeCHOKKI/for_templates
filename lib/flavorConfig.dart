import 'package:flutter/material.dart';

enum EndPoints { ToolbarItemsParentData, details }

class FlavorConfig {
  String? appTitle;
  Map<EndPoints, String>? apiEndPoint;
  String? imageLocation;
  Widget? home;
  ThemeData? themeData;
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  Iterable<Locale> supportedLocales;

  FlavorConfig({
    this.appTitle,
    this.apiEndPoint,
    this.imageLocation,
    this.themeData,
    this.home,
    this.localizationsDelegates,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
  });
}
