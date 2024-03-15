// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/Fonctions/firebase_services.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyMenuWidgets.dart';
import 'package:core/common_folder/widgets/MyNoDataWidget.dart';
import 'package:core/objet/Eglise.dart';
import 'package:core/pages/objet_details/EgliseDetailsPage.dart';
import 'package:core/pages/objet_list/ActualitesListWidget.dart';
import 'package:core/pages/objet_list/EgliseListWidget.dart';
import 'package:core/pages/objet_list/ManagerListWidget.dart';
import 'package:core/pages/objet_list/MembreListWidget.dart';
import 'package:flutter/material.dart';

class HomeEglise extends StatefulWidget {
  int currentIndex;
  Eglise? selectedEglise;
  bool menuCollapsed;

  HomeEglise({
    Key? key,
    this.currentIndex = 0,
    this.selectedEglise,
    this.menuCollapsed = false,
  }) : super(key: key);

  @override
  State<HomeEglise> createState() => _HomeEgliseState();
}

class _HomeEgliseState extends State<HomeEglise> {
  int currentMenuIndex = 0;
  bool menuCollapsed = false;

  Eglise? selectedEglise;

  @override
  void initState() {
    menuCollapsed = widget.menuCollapsed;
    if (widget.selectedEglise != null) {
      setState(() {
        selectedEglise = widget.selectedEglise;
      });
    }
    currentMenuIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<DrawerItem> listMenu = <DrawerItem>[
      DrawerItem(
        iconData: Icons.newspaper_sharp,
        name: "Actualités",
        page: ActualiteListWidget(
          key: selectedEglise != null ? UniqueKey() : null,
          canAddItem: true,
          idSelectedEglise: selectedEglise != null ? selectedEglise!.id : "",
          showAsGrid: true,
        ),
        visible: true,
      ),
      /*DrawerItem(
        index: 1,
        iconData: Icons.date_range_sharp,
        name: "Agendas",
        page: AgendaListWidget(),
        visible: true,
      ),
      DrawerItem(
        index: 2,
        iconData: Icons.card_giftcard_sharp,
        name: "Celebrations",
        page: CelebrationListWidget(),
        visible: true,
      ),*/
      DrawerItem(
        //3,
        iconData: Icons.event_sharp,
        name: "Evènements",
        page: Container(),
        visible: true,
      ),
      /*DrawerItem(
        index: 4,
        iconData: Icons.group_sharp,
        name: "Groupes",
        page: GroupeListWidget(),
        visible: true,
      ),*/
      DrawerItem(
        //5,
        iconData: Icons.people_sharp,
        name: "Membres",
        page: MembreListWidget(
          key: selectedEglise != null ? UniqueKey() : null,
          idSelectedEglise: selectedEglise != null ? selectedEglise!.id : "",
          canAddItem: true,
          /*showAsListWithHeader: true,*/
        ),
        visible: true,
      ),
      /*DrawerItem(
        index: 6,
        iconData: Icons.miscellaneous_services_sharp,
        name: "Services Demandés",
        page: ServiceDemandeListWidget(),
        visible: true,
      ),*/
      DrawerItem(
        //7,
        iconData: Icons.people_outlined,
        name: "Manageurs",
        page: ManagerListWidget(
          key: selectedEglise != null ? UniqueKey() : null,
          idSelectedEglise: selectedEglise != null ? selectedEglise!.id : "",
          canAddItem: true,
          /*showAsListWithHeader: true,*/
        ),
        visible: true,
      ),
      DrawerItem(
        //8,
        iconData: Icons.church_sharp,
        name: "Profil Eglise",
        page: EgliseDetailsPage(
          eglise: selectedEglise != null ? selectedEglise! : Eglise(),
          isMainMenu: true,
          isEglise: true,
        ),
        visible: true,
      ),
      /* DrawerItem(
        index: 5,
        iconData: Icons.people_sharp,
        name: "EglisesList",
        page: EgliseListWidget(
          key: selectedEglise != null ? UniqueKey() : null,
          idUsers: FirebaseServices.userConnectedFirebaseID,
          canAddItem: true,
          showAsDropDown: false,
        ),
        visible: true,
      ),*/
    ];
    return Scaffold(
      body: Row(
        children: <Widget>[
          if (!Fonctions().isSmallScreen(context))
            MyMenuWidget(
              customHeader: Container(
                width: double.infinity,
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            alignment: Alignment.center,
                            child: Stack(
                              fit: StackFit.loose,
                              children: <Widget>[
                                Opacity(
                                  child: Image.asset(
                                    "assets/images/logo_eglizier_outline.png",
                                    color: Colors.white,
                                  ),
                                  opacity: 1,
                                ),
                                ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 2.0,
                                      sigmaY: 2.0,
                                      tileMode: TileMode.decal,
                                    ),
                                    child: Image.asset(
                                      "assets/images/logo_eglizier_outline.png",
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!menuCollapsed)
                      Container(
                        height: 50,
                        child: EgliseListWidget(
                          initialEglise: selectedEglise,
                          idUsers: FirebaseServices.userConnectedFirebaseID,
                          //"TvGRVgKrzfNxFy4coIQ6SSyhipJ2",
                          backColor: Colors.white,
                          showAsDropDown: true,
                          canAddItem: true,
                          canRefresh: true,
                          onItemPressed: (value) {
                            setState(() {
                              selectedEglise = value;
                            });
                          },
                        ),
                      )
                  ],
                ),
              ),
              orientation: Axis.vertical,
              itemList: listMenu,
              backColor: theme.primaryColor,
              iconActiveColor: Colors.white,
              iconNonActiveColor: Colors.grey,
              currentIndex: currentMenuIndex,
              textStyles: Styles().getDefaultTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w200,
                color: Colors.white,
              ),
              isCollapsed: menuCollapsed,
              onMenuCollapseChange: (collapsed) {
                setState(() {
                  menuCollapsed = collapsed;
                });
              },
              onTap: (item) {
                setState(
                  () {
                    currentMenuIndex = item;
                    Fonctions().openPageToGo(
                      contextPage: context,
                      replacePage: true,
                      pageToGo: HomeEglise(
                        currentIndex: item,
                        menuCollapsed: menuCollapsed,
                        selectedEglise: selectedEglise,
                      ),
                    );
                  },
                );
              },
            ),
          Expanded(
            child: Fonctions().getDefaultMaterial(
              home: selectedEglise != null
                  ? listMenu[currentMenuIndex].page
                  : Scaffold(
                      body: MyNoDataWidget(
                        message: "Veuillez créer une église afin d'accéder à cette fonctionnalité.",
                      ),
                    ),
              theme: theme,
            ),
          )
        ],
      ),
    );
  }
}
