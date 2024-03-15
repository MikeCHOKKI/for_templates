import 'dart:async';
import 'dart:io';

import 'package:annuaire/AnnuairePage.dart';
import 'package:core/Api.dart';
import 'package:core/ConstantUrl.dart';
import 'package:core/PwaLink.dart';
import 'package:mdi/mdi.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/Fonctions/firebase_services.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyTextInputWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/pages/objet_list/ActualitesListWidget.dart';
import 'package:core/pages/objet_list/ProduitListWidget.dart';
import 'package:core/preferences.dart';
import 'package:immo/ImmoHomePage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pharmacie/PharmacieHomePage.dart';
import 'package:oryx/OryxHomePage.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:espace_entreprise/EspaceEntreprise.dart';
import 'package:schools/SchoolHome.dart';
import 'package:vote_enligne/pages/VotePageHome.dart';
import 'package:eservice_prive/EserviceHome.dart';

class AnnuaireHome extends StatefulWidget {
  const AnnuaireHome({Key? key}) : super(key: key);

  @override
  State<AnnuaireHome> createState() => _AnnuaireHomeState();
}

class _AnnuaireHomeState extends State<AnnuaireHome> {
  int selectedPage = 0;
  int currentMenuIndex = 0;
  PageController controller = PageController(initialPage: 0);
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrController;
  double moreButtonScale = 1;

  void moveToNextSection() {
    setState(() {
      selectedPage++;
      controller.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInBack);
    });
  }

  void sendToken() async {
    final token = await FirebaseServices().getTokenUser();
    final usersInfos = await Preferences()
        .getUsersListFromLocal(id: FirebaseServices.userConnectedFirebaseID ?? "azerty")
        .then((value) => value.isNotEmpty ? value.first : null);
    if (!kIsWeb) {
      await FirebaseMessaging.instance.subscribeToTopic("Annuaire");
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
  void reassemble() {
    super.reassemble();
    if (qrController != null) {
      if (Platform.isAndroid) {
        qrController!.pauseCamera();
      } else if (Platform.isIOS) {
        qrController!.resumeCamera();
      }
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.qrController = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        Navigator.pop(context);
        Fonctions().openPageToGo(
          contextPage: context,
          pageToGo: AnnuairePage(
            indexPageToShow: 1,
            theme: "${result!.code}",
          ),
        );
      });
    });
  }

  void annimateButton() {
    Timer.periodic(
      const Duration(milliseconds: 250),
      (timer) async {
        setState(() {
          moreButtonScale = moreButtonScale == 1 ? 0.9 : 1;
        });
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    sendToken();
    Fonctions().checkUpdateAvailability(context: context);
    // annimateButton();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/global_home_back.jpg",
                  ),
                  fit: BoxFit.cover)),
          child: Container(
            color: Colors.white.withOpacity(0.95),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 36),
                            constraints: BoxConstraints(maxWidth: 500),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                MyImageModel(
                                  urlImage: "assets/images/ic_buzup.png",
                                  size: 150,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MyTextWidget(
                                      text: "Buz'Up Annuaire",
                                      theme: BASE_TEXT_THEME.TITLE_LARGE,
                                      textAlign: TextAlign.center,
                                      textColor: ConstantColor.blackMalt,
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                  child: MyTextWidget(
                                    text:
                                        "Trouvez des partenaires et faites la promotions de votre entreprise. L'annuaire Buz'Up vous donne accès à plus de 10.000 entreprises béninoises.",
                                    textAlign: TextAlign.center,
                                    theme: BASE_TEXT_THEME.BODY_SMALL,
                                  ),
                                ),
                                MyTextInputWidget(
                                  border: Border.all(color: ConstantColor.accentColor),
                                  backColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  hint: "Rechercher",
                                  onTap: () {
                                    Fonctions().openPageToGo(
                                      contextPage: context,
                                      pageToGo: AnnuairePage(
                                        indexPageToShow: 1,
                                      ),
                                    );
                                  },
                                  readOnly: true,
                                  leftWidget: Icon(
                                    Icons.search_outlined,
                                    size: 12,
                                    color: ConstantColor.accentColor,
                                  ),
                                  rightWidget: !kIsWeb && (Platform.isAndroid || Platform.isIOS)
                                      ? Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Fonctions().showWidgetAsDialog(
                                                    context: context,
                                                    widget: Container(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              MyTextWidget(
                                                                  text: "QrCode", theme: BASE_TEXT_THEME.LABEL_MEDIUM),
                                                              Container(
                                                                child: MyTextWidget(
                                                                  text: "Scanner",
                                                                  theme: BASE_TEXT_THEME.LABEL_MEDIUM,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.symmetric(vertical: 16),
                                                            child: MyTextWidget(
                                                              text:
                                                                  "Recherche rapide! Scannez un qr code d'entreprise pour la retrouver plus facillement.",
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 300,
                                                            width: 300,
                                                            child: QRView(
                                                              key: qrKey,
                                                              onQRViewCreated: _onQRViewCreated,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    title: "");
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8),
                                                child: Icon(
                                                  Icons.qr_code_scanner_outlined,
                                                  color: ConstantColor.accentColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : null,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    buzupServiceCard(
                                        icon: Icons.account_tree_outlined,
                                        title: "Entreprises par\ncatégories",
                                        action: () {
                                          Fonctions().openPageToGo(
                                            contextPage: context,
                                            pageToGo: AnnuairePage(
                                              indexPageToShow: 0,
                                            ),
                                          );
                                        }),
                                    buzupServiceCard(
                                        icon: Icons.location_on_outlined,
                                        title: "Entreprises de\nproximité",
                                        action: () {
                                          Fonctions().openPageToGo(
                                            contextPage: context,
                                            pageToGo: AnnuairePage(
                                              indexPageToShow: 1,
                                              showByProximity: true,
                                            ),
                                          );
                                        }),
                                    buzupServiceCard(
                                        icon: Icons.dashboard_outlined,
                                        title: "Espace\nEntreprise",
                                        action: () {
                                          Fonctions().openPageToGo(
                                            contextPage: context,
                                            pageToGo: EspaceEntreprisePage(),
                                          );
                                        }),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buzupServiceCard(
      {String? title,
      String? description,
      IconData? icon,
      Color? iconBackColor,
      Color? cardBackColor,
      Color? btBackColor,
      Color? btTextColor,
      TextStyle? titleStyle,
      TextStyle? descriptionStyle,
      String? btText,
      Function? action}) {
    return GestureDetector(
      onTap: () {
        if (action != null) action();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null)
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24,
                color: Colors.white,
              ),
            ),
          if (title != null)
            MyTextWidget(
              text: title,
              textAlign: TextAlign.center,
              theme: BASE_TEXT_THEME.BODY_SMALL,
            ),
        ],
      ),
    );
  }
}
