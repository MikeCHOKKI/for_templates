import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:flutter/material.dart';

import 'HomeEglise.dart';
import 'LoginPage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool showConnexionForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: MyImageModel(
                    width: 100,
                    height: 100,
                    urlImage: "assets/images/logo_eglizier_outline.png",
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          constraints: BoxConstraints(maxWidth: 400),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              MyTextWidget(
                                text: "Gérez votre communauté réligieuse.",
                                textAlign: TextAlign.start,
                                theme: BASE_TEXT_THEME.DISPLAY,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              MyTextWidget(
                                text:
                                    "Eglizier vous aide à gérer votre communauté réligieuse. Créer votre compte pour accéder à une panoplie d'outils pour la gestion des membres, des célébration de la conptabilité et aux autres activités du quotidien de votre Eglise",
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              if (showConnexionForm)
                                SizedBox(
                                  height: 250,
                                  child: LoginPage(
                                    onlyForm: true,
                                    canIgnore: false,
                                    onConnexionSuccess: (context) {
                                      Fonctions().openPageToGo(
                                        contextPage: context,
                                        pageToGo: HomeEglise(),
                                      );
                                    },
                                  ),
                                ),
                              Row(
                                children: [
                                  if (!showConnexionForm)
                                    MyButtonWidget(
                                      text: "Rejoindre",
                                      action: () {
                                        setState(() {
                                          showConnexionForm = true;
                                        });
                                      },
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: MyImageModel(
                            size: 400,
                            urlImage: "assets/images/globe_reseau.png",
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
