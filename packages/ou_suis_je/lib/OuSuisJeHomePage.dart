import 'dart:convert';

import 'package:annuaire/AnnuairePage.dart';
import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/Fonctions/firebase_services.dart';
import 'package:core/common_folder/constantes/enums.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyLoadingWidget.dart';
import 'package:core/common_folder/widgets/MyMenuWidgets.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/pages/LoginPage.dart';
import 'package:core/pages/objet_list/EntrepriseListWidget.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mdi/mdi.dart';
import 'package:ou_suis_je/AdressesEnregistreesPage.dart';
import 'package:ou_suis_je/GoogleMapAddress.dart';
import 'package:ou_suis_je/TypeEnregistrementPage.dart';

class OuSuisJeHomePage extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final bool? showAppBar;

  OuSuisJeHomePage({Key? key, this.showAppBar = true, this.appBar}) : super(key: key);

  @override
  State<OuSuisJeHomePage> createState() => _OuSuisJeHomePageState();
}

class _OuSuisJeHomePageState extends State<OuSuisJeHomePage> {
  bool loadingLocation = false, loadingLocationInfo = false;

  bool isTtsSpeaking = false;
  FlutterTts flutterTts = FlutterTts();
  int readingPortionArticleIndex = 0;
  ThemeData theme = ThemeData();
  String currentAddress = "";
  Position? currentPosition;
  List<DrawerItem> menuItemsList = [];

  speak(String text, bool mayRestart) async {
    /*double volume = await Preferences().getVolumeLectureDefaut();
    double rate = await Preferences().getVitesseLecture();
    double pitch = await Preferences().getIntonationLecture();
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);*/

    if (isTtsSpeaking) {
      await flutterTts.stop().then((value) {
        setState(() {
          isTtsSpeaking = false;
        });
      });
    }
    await flutterTts.speak(text.toLowerCase()).then((value) {
      setState(() {
        isTtsSpeaking = true;
      });
      return 1;
    });
  }

  getAddessFromLagLong() async {
    setState(() {
      loadingLocation = true;
      currentPosition = null;
      currentAddress = "";
    });
    Position? position = await Fonctions().getCurrentUserPosition();
    setState(() {
      currentPosition = position;
      loadingLocation = false;
      loadingLocationInfo = true;
    });

    Map<String, String> params = {
      "latlng": "${position!.latitude},${position!.longitude}",
      "key": "AIzaSyBe8Ja2oKzJZCvq1xxYdKJNpPazJRa2b_Y"
    };
    Uri uri = Uri.https("maps.googleapis.com", "/maps/api/geocode/json", params);

    http.Response response = await http.get(
      uri,
    );

    String json = jsonEncode(jsonDecode(response.body)['results']).toString();
    List<dynamic> body = jsonDecode(json);
    List<GoogleMapAddress> list = body.map((dynamic item) => GoogleMapAddress.fromMap(item)).toList();
    String? addressToRead = list[0].formatted_address;
    speak(addressToRead != null ? "Votre position actuelle indique que vous à $addressToRead" : "", true);

    setState(() {
      currentAddress = addressToRead ?? "";
      loadingLocationInfo = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    menuItemsList.add(DrawerItem(
        iconData: FluentIcons.bed_16_regular,
        name: "Hotels",
        visible: true,
        page: _entrepriseListModel(title: "Hotels", theme: "hotel")));
    menuItemsList.add(DrawerItem(
        iconData: FluentIcons.food_16_regular,
        name: "Restaurant",
        visible: true,
        page: _entrepriseListModel(title: "Restaurant", theme: "Restaurant")));

    menuItemsList.add(DrawerItem(
        iconData: FluentIcons.card_ui_20_regular,
        name: "GAB",
        visible: true,
        page:
            _entrepriseListModel(title: "Guichets Automatiques de Banque", theme: ThemeEntreprisePincipale.GAB.theme)));

    menuItemsList.add(DrawerItem(
        iconData: FluentIcons.doctor_20_regular,
        name: "Pharmarcie",
        visible: true,
        page: _entrepriseListModel(
            title: "Pharmacies", id_sous_categorie: SousCategorieEntreprisePincipale.PHARMACIE.id)));
    menuItemsList.add(DrawerItem(
        iconData: Mdi.hospitalBuilding,
        name: "Hôpital",
        visible: true,
        page: _entrepriseListModel(
            title: "Centre de santé", id_sous_categorie: SousCategorieEntreprisePincipale.HOPITAL.id)));
    menuItemsList.add(DrawerItem(iconData: Mdi.viewDashboard, name: "Plus", visible: true, page: AnnuairePage()));
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      appBar: widget.showAppBar == true
          ? widget.appBar != null
              ? widget.appBar
              : Fonctions().defaultAppBar(
                  context: context,
                  tailleAppBar: 56,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  titleWidget: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            MyTextWidget(
                              text: "Où suis-je",
                              theme: BASE_TEXT_THEME.TITLE_LARGE,
                              textColor: ConstantColor.blackMalt,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actionWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyButtonWidget(
                        text: "Mes adresses",
                        margin: EdgeInsets.only(right: 24),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        action: () {
                          if (FirebaseServices.userConnectedFirebaseID != null) {
                            Fonctions().openPageToGo(
                              contextPage: context,
                              pageToGo: AdressesEnregistreesPage(
                                showAppBar: true,
                              ),
                            );
                          } else {
                            Fonctions().openPageToGo(
                              contextPage: context,
                              pageToGo: LoginPage(
                                onConnexionSuccess: (ctx, user) {
                                  Fonctions().openPageToGo(
                                    contextPage: ctx,
                                    pageToGo: AdressesEnregistreesPage(
                                      showAppBar: true,
                                    ),
                                    replacePage: true,
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ))
          : null,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (loadingLocation || loadingLocationInfo)
                    Expanded(
                      child: MyLoadingWidget(
                        style: MyLoadingWidgetStyle.RIPPLED,
                        message: loadingLocation
                            ? "Récupéation de votre adresse..."
                            : loadingLocationInfo
                                ? "Récupéation des infomations votre adresse..."
                                : "",
                        color: theme.primaryColor,
                      ),
                    ),
                  if (!(loadingLocation || loadingLocationInfo))
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            getAddessFromLagLong();
                          },
                          customBorder: new CircleBorder(),
                          child: Container(
                            margin: EdgeInsets.all(16),
                            padding: EdgeInsets.all(48),
                            decoration:
                                BoxDecoration(shape: BoxShape.circle, color: theme.primaryColor.withOpacity(0.1)),
                            child: Container(
                              padding: EdgeInsets.all(48),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: theme.primaryColor),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Icon(
                                      Icons.not_listed_location,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(children: [
                  if (currentAddress.isNotEmpty)
                    Column(
                      children: [
                        MyTextWidget(
                          text: "Votre adresse",
                          theme: BASE_TEXT_THEME.TITLE,
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            color: ConstantColor.grisColor.withOpacity(0.8),
                            child: Text(
                              currentAddress,
                              style: Styles().getDefaultTextStyle(),
                            ))
                      ],
                    ),
                  MyButtonWidget(
                    text: "Enregistrer cette adresse",
                    showShadow: false,
                    backColor: theme.primaryColor.withOpacity(0.2),
                    textColor: theme.primaryColor,
                    margin: EdgeInsets.all(4),
                    radiusButton: 12,
                    action: () {
                      setState(() {});
                      if (FirebaseServices.userConnectedFirebaseID != null) {
                        Fonctions().openPageToGo(
                          contextPage: context,
                          pageToGo: TypeEnregistrementPage(
                            latitude: currentPosition != null ? currentPosition!.latitude.toString() : "",
                            longitude: currentPosition != null ? currentPosition!.longitude.toString() : "",
                          ),
                        );
                      } else {
                        Fonctions().openPageToGo(
                          contextPage: context,
                          pageToGo: LoginPage(
                            onConnexionSuccess: (ctx, user) {
                              Fonctions().openPageToGo(
                                contextPage: ctx,
                                pageToGo: TypeEnregistrementPage(
                                  latitude: currentPosition != null ? currentPosition!.latitude.toString() : "",
                                  longitude: currentPosition != null ? currentPosition!.longitude.toString() : "",
                                ),
                                replacePage: true,
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                  Column(
                    children: [
                      MyTextWidget(
                        text: "Autour de vous",
                        theme: BASE_TEXT_THEME.TITLE,
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      GridView(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 120, crossAxisSpacing: 12, mainAxisSpacing: 12),
                        physics: NeverScrollableScrollPhysics(),
                        primary: false,
                        shrinkWrap: true,
                        children: menuItemsList.map((e) => _VueAutourDeVousOption(option: e)).toList(),
                      ),
                    ],
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _VueAutourDeVousOption({required DrawerItem option}) {
    return InkWell(
      onTap: () {
        Fonctions().openPageToGo(contextPage: context, pageToGo: option.page!);
      },
      child: MyCardWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              option.iconData,
              color: theme.primaryColor.withOpacity(0.4),
              size: 36,
            ),
            MyTextWidget(
              text: "${option.name}",
              textAlign: TextAlign.center,
              theme: BASE_TEXT_THEME.TITLE_SMALL,
            ),
          ],
        ),
      ),
    );
  }

  Widget _entrepriseListModel({String? title, String? id_categorie, String? id_sous_categorie, String? theme}) {
    return EntrepriseListWidget(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      //themeRecherche: searchController.text,
      showAppBar: true,
      title: title,
      showCountStack: true,
      showByProximity: true,
      id_sous_categorie: id_sous_categorie,
      id_categorie: id_categorie,
      themeRecherche: theme,
      showSearchBar: true,
    );
  }
}
