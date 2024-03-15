import 'package:core/Api.dart';
import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/Fonctions/firebase_services.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyLoadingWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'HomeEglise.dart';
import 'WelcomePage.dart';

class EglizierHomePage extends StatefulWidget {
  const EglizierHomePage({Key? key}) : super(key: key);

  @override
  State<EglizierHomePage> createState() => _EglizierHomePageState();
}

class _EglizierHomePageState extends State<EglizierHomePage> {
  bool showConnexionForm = false;

  void verify() async {
    final data = await Preferences().getUsersListFromLocal(
        id: FirebaseServices.userConnectedFirebaseID ?? "azerrty");
    if (data.isNotEmpty) {
      Fonctions().openPageToGo(
        contextPage: context,
        replacePage: true,
        pageToGo: HomeEglise(),
      );
    } else {
      Fonctions().openPageToGo(
        contextPage: context,
        replacePage: true,
        pageToGo: WelcomePage(),
      );
    }
  }

  void sendToken() async {
    try {
      final token = await FirebaseServices().getTokenUser();
      final usersInfos = await Preferences()
          .getUsersListFromLocal(
              id: FirebaseServices.userConnectedFirebaseID ?? "azerty")
          .then((value) => value.isNotEmpty ? value.first : null);
      if (!kIsWeb) {
        await FirebaseMessaging.instance.subscribeToTopic("Eglizier");
        if (usersInfos != null) {
          if (usersInfos.fcm_token != null) {
            if (usersInfos.fcm_token!.isNotEmpty) {
              if (token != null) {
                if (token != usersInfos.fcm_token) {
                  final dataToSend = usersInfos;
                  dataToSend.fcm_token = token;
                  await Api.saveObjetApi(
                    arguments: dataToSend,
                    url: ConstantUrl.UsersUrl,
                  );
                }
              }
            } else {
              if (token != null) {
                final dataToSend = usersInfos;
                dataToSend.fcm_token = token;
                await Api.saveObjetApi(
                  arguments: dataToSend,
                  url: ConstantUrl.UsersUrl,
                );
              }
            }
          }
        }
      }
    } catch (e) {}
  }

  @override
  void initState() {
    verify();
    super.initState();
    sendToken();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final args = ModalRoute.of(context)!.settings.arguments;
    print("argu: $args");
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyTextWidget(
              text: "EGLIZIER",
              theme: BASE_TEXT_THEME.DISPLAY,
              textColor: theme.primaryColor),
          MyTextWidget(
            text: "Gérez votre communauté réligieuse.",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24),
                child: MyLoadingWidget(
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
