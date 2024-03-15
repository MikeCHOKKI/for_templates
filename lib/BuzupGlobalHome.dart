// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:annuaire/AnnuairePage.dart';
import 'package:buzuppro/PresentationPage.dart';
import 'package:core/Api.dart';
import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/Fonctions/firebase_services.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyMenuWidgets.dart';
import 'package:core/pages/objet_list/ActualitesListWidget.dart';
import 'package:core/pages/objet_list/ProduitListWidget.dart';
import 'package:core/preferences.dart';
import 'package:eservice_prive/EserviceHome.dart';
import 'package:espace_entreprise/EspaceEntreprise.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GlobalHomePage extends StatefulWidget {
  int selectedPageIndex;
  bool menuCollapsed;

  GlobalHomePage({Key? key, this.selectedPageIndex = 0, this.menuCollapsed = false}) : super(key: key);

  @override
  State<GlobalHomePage> createState() => _GlobalHomePageState();
}

class _GlobalHomePageState extends State<GlobalHomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late PreferredSize globalAppBar;
  int currentMenuIndex = 0;
  List<DrawerItem> menuItemsList = [
    DrawerItem(
      iconData: Icons.home_outlined,
      name: "Accueil",
      page: PresentationPage(),
      visible: true,
      mayShowParentAppBar: false,
    ),
    DrawerItem(
      iconData: Icons.book_outlined,
      name: "Annuaire",
      page: AnnuairePage(),
      visible: true,
      mayShowParentAppBar: false,
    ),
    DrawerItem(
      iconData: Icons.newspaper,
      name: "Actualité",
      page: ActualiteListWidget(
        showItemAsCard: true,
        showAppBar: true,
        showAsGrid: true,
        canRefresh: true,
      ),
      visible: true,
      mayShowParentAppBar: false,
    ),
    DrawerItem(
      iconData: Icons.shopping_cart_outlined,
      name: "Boutique",
      page: ProduitListWidget(
        showAsGrid: true,
        showItemAsCard: true,
        showAppBar: true,
        canLikeItem: true,
        showSearchBar: true,
      ),
      visible: true,
      mayShowParentAppBar: false,
    ),
    DrawerItem(
      iconData: Icons.room_service_outlined,
      name: "E-Service",
      page: EserviceHome(),
      visible: true,
      mayShowParentAppBar: false,
    ),
    DrawerItem(
      iconData: Icons.dashboard_outlined,
      name: "Espace Entreprise",
      page: EspaceEntreprisePage(),
      visible: true,
      mayShowParentAppBar: false,
    ),
    /*DrawerItem(index: 5, iconData: Mdi.formTextbox, name: "Forms", page: FormHomePage(), visible: true),
    DrawerItem(
        index: 6,
        iconData: Mdi.church,
        name: "Eglizier",
        page: EglizierHomePage(),
        visible: true,
        destinatinLink: PwaLink.eglizier),
    DrawerItem(
        index: 7,
        iconData: Icons.work_outline,
        name: "School",
        page: SchoolHome(),
        visible: true,
        destinatinLink: PwaLink.school),*/
    /*DrawerItem(
      index: 5,
      iconData: Mdi.officeBuilding,
      name: "Espace Entreprise",
      destinatinLink: PwaOnlineDomaine.business,
      visible: true,
    ),*/
  ];

  bool menuCollapsed = false;

  void sendToken() async {
    final token = await FirebaseServices().getTokenUser();
    final usersInfos = await Preferences()
        .getUsersListFromLocal(id: FirebaseServices.userConnectedFirebaseID ?? "azerty")
        .then((value) => value.isNotEmpty ? value.first : null);
    if (!kIsWeb) {
      await FirebaseMessaging.instance.subscribeToTopic("Buzup");
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
    currentMenuIndex = widget.selectedPageIndex;
    menuCollapsed = widget.menuCollapsed;

    super.initState();
    sendToken();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    globalAppBar = Fonctions().defaultAppBar(
      context: context,
      elevation: 0,
      tailleAppBar: 64,
      titre: menuItemsList[currentMenuIndex].name,
      titreColor: theme.primaryColor,
      backgroundColor: Colors.white,
      iconColor: ConstantColor.accentColor,
      actionWidget: Row(
        children: <Widget>[
          //if (!getusers)
          MyButtonWidget(
            text: "Mon profil",
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.symmetric(vertical: 8.0),
            backColor: Colors.white,
            showShadow: false,
            action: () {
              if (scaffoldKey.currentState!.hasEndDrawer) {
                scaffoldKey.currentState!.openEndDrawer();
              }
            },
          ),
          SizedBox(width: 8.0),
          /*if (users != null)
              MyButtonWidget(
                text: "Déconnexion",
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(vertical: 8.0),
                height: null,
                width: null,
                backColor: Colors.white,
                textStyle: Styles().getDefaultTextStyle(fontSize: 14.0, color: ConstantColor.textColor),
                showShadow: false,
                action: () async {
                  FirebaseServices().deconnexion().then((value) async {
                    await Preferences.clearData().then((value) async {
                      getUsersInfos();
                      ScaffoldMessenger.of(context).clearSnackBars();
                      MySnakBar().showSnackBarStyle2(
                        context,
                        alerteetat: ALERTEETAT.REUSSI,
                        message: "Déconnexion réussi",
                      );
                    });
                  });
                },
              ),*/

          SizedBox(width: 8.0),
        ],
      ),
    );
    return Scaffold(
      key: scaffoldKey,
      //drawer:  Fonctions().isSmallScreen(context) ? myMenuWidget : null,
      //appBar: Fonctions().isSmallScreen(context) ? globalAppBar : null,
      body: Row(
        children: [
          if (!Fonctions().isSmallScreen(context))
            Container(
                width: menuCollapsed ? 80 : 220,
                child: MyMenuWidget(
                    customHeader: Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              alignment: Alignment.center,
                              child: Stack(children: [
                                Opacity(
                                  child: Image.asset(
                                    "assets/images/ic_buzup.png",
                                    color: Colors.white,
                                  ),
                                  opacity: 1,
                                ),
                                ClipRect(
                                    child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0, tileMode: TileMode.decal),
                                        child: Image.asset(
                                          "assets/images/ic_buzup.png",
                                        )))
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //orientation: Axis.vertical,
                    itemList: menuItemsList,
                    headerHeight: 150,
                    backColor: ConstantColor.accentColor,
                    currentIndex: currentMenuIndex,
                    iconActiveColor: ConstantColor.lightColor,
                    iconNonActiveColor: ConstantColor.lightColor.withOpacity(0.7),
                    //textStyles: Styles().getDefaultTextStyle(fontSize: 14, fontWeight: FontWeight.w200, color: Colors.white),
                    isCollapsed: menuCollapsed,
                    onMenuCollapseChange: (collapsed) {
                      setState(() {
                        menuCollapsed = collapsed;
                      });
                    },
                    onTap: (item) {
                      setState(() {
                        currentMenuIndex = item;
                        Fonctions().openPageToGo(
                          contextPage: context,
                          replacePage: true,
                          pageToGo: GlobalHomePage(selectedPageIndex: item, menuCollapsed: menuCollapsed),
                        );
                      });
                    })),
          Expanded(
            child: Column(
              children: [
                if (!Fonctions().isSmallScreen(context) && menuItemsList[currentMenuIndex].mayShowParentAppBar == true)
                  globalAppBar,
                Expanded(
                  child: Fonctions().getDefaultMaterial(
                    home: menuItemsList[currentMenuIndex].page,
                    theme: theme,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
