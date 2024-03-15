import 'dart:async';

import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyLoadingWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:eglizier/mobile/HomeBibleApp.dart';
import 'package:flutter/material.dart';

class LoadBibleDataPage extends StatefulWidget {
  const LoadBibleDataPage({Key? key}) : super(key: key);

  @override
  State<LoadBibleDataPage> createState() => _LoadBibleDataPageState();
}

class _LoadBibleDataPageState extends State<LoadBibleDataPage> {
  void verify() async {
    Timer(
      Duration(seconds: 2),
      () {
        Fonctions().openPageToGo(
          contextPage: context,
          replacePage: true,
          pageToGo: HomeBibleApp(),
        );
      },
    );
  }

  @override
  void initState() {
    verify();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyTextWidget(
            text: "EGLIZIER",
            theme: BASE_TEXT_THEME.DISPLAY,
            textColor: theme.primaryColor,
          ),
          MyTextWidget(
            text: "Ton espace réligieux personnel",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24),
                child: MyLoadingWidget(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
