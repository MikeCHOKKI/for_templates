// import 'package:core/common_folder/Fonctions/Fonctions.dart';
// import 'package:core/common_folder/constantes/colorConstant.dart';
// import 'package:core/common_folder/widgets/MyButtonWidget.dart';
// import 'package:core/common_folder/widgets/MyTextInputWidget.dart';
// import 'package:core/pages/objet_list/ActualitesListWidget.dart';
// import 'package:core/pages/objet_list/CategorieEntrepriseListWidget.dart';
// import 'package:core/pages/objet_list/RubriqueAccueilListWidget.dart';
// import 'package:core/pages/objet_list/SchoolDiplomesListWidget.dart';
// import 'package:core/pages/objet_list/SchoolFilieresListWidget.dart';
// import 'package:core/pages/objet_list/SchoolMatieresListWidget.dart';
// import 'package:core/pages/objet_list/SchoolTemoignagesListWidget.dart';
// import 'package:core/pages/objet_list/SousCategorieEntrepriseListWidget.dart';
// import 'package:flutter/material.dart';
// class BoutiquierHome extends StatefulWidget {
//   const BoutiquierHome({super.key});

import 'package:core/Api.dart';
import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/Fonctions/firebase_services.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/enums.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyResponsiveWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/preferences.dart';
import 'package:espace_entreprise/DashboardEspaceEntreprise.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BoutiquierHome extends StatefulWidget {
  const BoutiquierHome({super.key});

  @override
  State<BoutiquierHome> createState() => _BoutiquierHomeState();
}

class _BoutiquierHomeState extends State<BoutiquierHome> {
  int selectedPage = 0;
  PageController controller = PageController(initialPage: 0);

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  void sendToken() async {
    final token = await FirebaseServices().getTokenUser();
    final usersInfos = await Preferences()
        .getUsersListFromLocal(id: FirebaseServices.userConnectedFirebaseID ?? "azerty")
        .then((value) => value.isNotEmpty ? value.first : null);
    if (!kIsWeb) {
      await FirebaseMessaging.instance.subscribeToTopic("School");
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
  }

  @override
  void initState() {
    // TODO: implement initState
    _initGoogleMobileAds();
    super.initState();
    sendToken();
  }

  double tailleImage = 500, tailleTitle = 18, tailleSubtitle = 12, tailleOptionText = 12, tailleOptionIcon = 24;

  @override
  Widget build(BuildContext context) {
    tailleImage = Fonctions().isLargeScreen(context)
        ? 500
        : Fonctions().isMediumScreen(context)
            ? 400
            : 250;
    tailleTitle = Fonctions().isLargeScreen(context)
        ? 48
        : Fonctions().isMediumScreen(context)
            ? 36
            : 32;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        /* appBar: AppBar(
          title: MyTextWidget(
          text:"School'App"),
        ),*/
        body: PageView(
          scrollDirection: Axis.vertical,
          controller: controller,
          children: [
            MyResponsiveWidget(
              largeScreen: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "assets/images/abstract_cover.jpg",
                        ),
                        fit: BoxFit.cover)),
                child: Container(
                  color: Colors.white.withOpacity(0.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 800),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 36),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  MyImageModel(
                                    margin: const EdgeInsets.all(8),
                                    height: 36,
                                    width: 36,
                                    urlImage: "assets/images/logo_buzup.png",
                                  ),
                                  MyTextWidget(
                                    text: "Boutiquier",
                                    theme: BASE_TEXT_THEME.TITLE,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      _blocColone2(),
                                    ],
                                  )),
                                  SizedBox(
                                    width: 72,
                                  ),
                                  Expanded(child: _blocColone1())
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              smallScreen: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "assets/images/abstract_cover.jpg",
                        ),
                        fit: BoxFit.cover)),
                child: Container(
                  color: Colors.white.withOpacity(0.4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Spacer(),
                      Column(
                        children: [
                          MyImageModel(
                            margin: const EdgeInsets.all(8),
                            height: 46,
                            width: 46,
                            urlImage: "assets/images/logo_buzup.png",
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyTextWidget(
                                text: "Boutiquier",
                                theme: BASE_TEXT_THEME.TITLE,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      _blocColone2(),
                      Container(padding: EdgeInsets.all(24), child: _blocColone1()),
                      Spacer()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blocColone1() {
    return Column(
      mainAxisAlignment: Fonctions().isSmallScreen(context) ? MainAxisAlignment.center : MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextWidget(
          text: "Délivre des factures",
          textColor: Theme.of(context).primaryColor,
          theme: BASE_TEXT_THEME.TITLE,
        ),
        Container(
          child: MyTextWidget(
            text: "Gère ta boutique",
            theme: BASE_TEXT_THEME.DISPLAY,
          ),
        ),
        Visibility(
          visible: true,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: 16,
            ),
            child: MyTextWidget(
              text:
                  "Améliorez la gestion de votre boutique de vente de produits et services. Délivrez vos factures, gérez les stocks de vos produits et obtenez des bilans réguliers.",
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: 300),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                children: [
                  MyButtonWidget(
                    text: "Ma boutique",
                    iconData: Icons.school,
                    iconColor: Colors.white,
                    backColor: ConstantColor.accentColor,
                    action: () {
                      Fonctions().openPageToGo(
                        contextPage: context,
                        pageToGo: DashboardEspaceEntreprisePage(
                          singleOngletToShow: OngletsEntreprise.ONGLET_BOUTIQUE,
                        ),
                        replacePage: true,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        /* Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    selectedPage = 1;
                    controller.jumpToPage(1);
                  });
                },
                icon: Icon(
                  Icons.arrow_downward_sharp,
                  size: 24,
                ))
          ],
        )*/
      ],
    );
  }

  Widget _blocColone2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            Expanded(
              child: MyImageModel(
                width: tailleImage,
                height: tailleImage,
                urlImage: 'assets/images/student_2.png',
                fit: BoxFit.contain,
                size: tailleImage,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
