import 'dart:math';

import 'package:annuaire/components/UserProfileMenu.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/Fonctions/firebase_services.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/enums.dart';
import 'package:core/common_folder/widgets/MyLoadingWidget.dart';
import 'package:core/objet/Users.dart';
import 'package:core/pages/objet_list/EntrepriseListWidget.dart';
import 'package:core/pages/objet_list/UserAdresseListWidget.dart';
import 'package:core/preferences.dart';
import 'package:flutter/material.dart';

class AdressesEnregistreesPage extends StatefulWidget {
  final Users? userConnected;
  final int indexTab;
  final bool showAppBar;
  final AppBar? appBar;
  List<String>? tabsTitles;

  AdressesEnregistreesPage(
      {Key? key, this.appBar, this.userConnected, this.indexTab = 0, this.tabsTitles, this.showAppBar = false})
      : super(key: key);

  @override
  State<AdressesEnregistreesPage> createState() => _AdressesEnregistreesPageState();
}

class _AdressesEnregistreesPageState extends State<AdressesEnregistreesPage> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false,
      isUserConnexionRequired = true,
      isOwnerConnected = false,
      isForPublic = false,
      isEditable = true,
      showBtnSuivant = false;
  List<String> tabsTitles = [];
  Users userConnectedInfos = Users();

  late TabController tabController;

  void rebuildTab() {
    // print("RebuildStart");
    setState(() {
      isLoading = false;
      final oldIndex = tabController.index;
      int tabLength = getTabs().length;
      tabController.dispose();
      tabController = TabController(
        length: tabLength,
        initialIndex: max(0, min(oldIndex, tabLength - 1)),
        vsync: this,
      );

      //print("RebuildEnd $tabLength  ${tabController.length}");
    });
  }

  void getUserConnected() {
    Preferences().getUsersListFromLocal(id: "${userConnectedInfos.id}").then((value) => {
          setState(() {
            userConnectedInfos = value.isNotEmpty ? value.single : Users();
          })
        });
  }

  void reloadPage() {
    setState(() {
      isLoading = true;
      getUserConnected();
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    tabsTitles = widget.tabsTitles ?? [];
    tabController = TabController(vsync: this, length: getTabs().length, initialIndex: widget.indexTab);

    if (widget.userConnected != null) {
      userConnectedInfos = widget.userConnected!;
    } else {
      if (FirebaseServices.userConnectedFirebaseID != null) {
        userConnectedInfos = Users(id: FirebaseServices.userConnectedFirebaseID);
      }
    }
    isLoading = true;
    getUserConnected();
    rebuildTab();

    super.initState();
  }

  void didUpdateWidget(covariant AdressesEnregistreesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    rebuildTab();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: widget.appBar ??
          (widget.showAppBar == true
              ? (widget.appBar ??
                  (Fonctions().defaultAppBar(
                      context: context,
                      homeContext: context,
                      object: userConnectedInfos,
                      scaffoldKey: scaffoldKey,
                      showAccount: true,
                      titre: 'Mes Adresses',
                      titreColor: theme.primaryColor,
                      backgroundColor: Colors.white)))
              : null),
      endDrawer: UserProfileMenu(
        userConnected: userConnectedInfos,
        context: context,
        scaffoldKey: scaffoldKey,
        pageToGo: AdressesEnregistreesPage(),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!isLoading && getTabs().length > 0)
              Expanded(
                child: Column(
                  children: [
                    if (getTabs().length > 1)
                      Column(
                        children: [
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: TabBar(
                              tabs: getTabs().map((e) => e.onglet).toList(),
                              controller: tabController,
                              isScrollable: true,
                              indicatorColor: theme.primaryColor,
                              labelColor: theme.primaryColor,
                              indicatorSize: TabBarIndicatorSize.label,
                              unselectedLabelColor: ConstantColor.textColor,
                            ),
                          ),
                          Divider(
                            color: theme.primaryColor,
                            thickness: 0.7,
                            height: 0.7,
                          ),
                        ],
                      ),
                    Expanded(
                      child: Container(
                        color: ConstantColor.backgroundColor,
                        child: TabBarView(
                          controller: tabController,
                          children: getTabs().map((e) => e.page).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (isLoading) Expanded(child: Center(child: MyLoadingWidget())),
          ],
        ),
      ),
    );
  }

  List<TabObject> getTabs() {
    setState(() {});
    return [
      TabObject(
        onglet: Tab(
          text: OngletsAdresse.ONGLET_PRIVEES.titre,
        ),
        page: UserAdresseListWidget(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          canAddItem: true,
          showAsGrid: true,
          canEditItem: true,
          canDeleteItem: true,
          backColor: ConstantColor.backgroundColor,
        ),
      ),
      TabObject(
        onglet: Tab(
          text: OngletsAdresse.ONGLET_ENTREPRISES.titre,
        ),
        page: EntrepriseListWidget(
          padding: EdgeInsets.symmetric(vertical: 0),
          idUsers: userConnectedInfos.id,
          idOwner: userConnectedInfos.id,
          skipLocal: true,
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        ),
      ),
      TabObject(
        onglet: Tab(
          text: OngletsAdresse.ONGLET_PUBLIQUES.titre,
        ),
        page: EntrepriseListWidget(
          padding: EdgeInsets.symmetric(vertical: 0),
          idUsers: userConnectedInfos.id,
          idOwner: userConnectedInfos.id,
          id_categorie: "cat_points_d_interet",
          id_sous_categorie: "",
          skipLocal: true,
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        ),
      ),
    ];
  }
}

class TabObject {
  Tab onglet;
  Widget page;

  TabObject({required this.onglet, required this.page});
}
