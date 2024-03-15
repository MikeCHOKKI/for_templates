import 'dart:math';

import 'package:annuaire/components/UserProfileMenu.dart';
import 'package:boutiquier/BoutiquierDashboard.dart';
import 'package:boutiquier/DashboardBoutiquierPage.dart';
import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/Fonctions/firebase_services.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/constant.dart';
import 'package:core/common_folder/constantes/enums.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyErrorWidget.dart';
import 'package:core/common_folder/widgets/MyLoadingWidget.dart';
import 'package:core/common_folder/widgets/MyMediaWidget.dart';
import 'package:core/common_folder/widgets/MyMenuWidget.dart';
import 'package:core/common_folder/widgets/MyResponsiveWidget.dart';
import 'package:core/objet/CategorieEntreprise.dart';
import 'package:core/objet/Entreprise.dart';
import 'package:core/objet/Users.dart';
import 'package:core/pages/LoginPage.dart';
import 'package:core/pages/objet_details/EntrepriseDetailsPage.dart';
import 'package:core/pages/objet_details/UsersDetailsPage.dart';
import 'package:core/pages/objet_list/ActualitesListWidget.dart';
import 'package:core/pages/objet_list/EntrepriseListWidget.dart';
import 'package:core/pages/objet_list/MediasListWidget.dart';
import 'package:core/pages/objet_list/ProduitListWidget.dart';
import 'package:core/pages/objet_list/SchoolFilieresListWidget.dart';
import 'package:core/pages/objet_list/ServicesListWidget.dart';
import 'package:core/preferences.dart';
import 'package:espace_entreprise/InscriptionEntreprisePage.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'ConfigEntreprisePage.dart';

class DashboardEspaceEntreprisePage extends StatefulWidget {
  final BuildContext? menuHomeContext;
  final Users? userConnected;
  final int indexTab;
  final bool menuIsLeft;

  final String? selectedEntrepriseId;
  final bool showAppBar;
  final Entreprise? entrepriseToShowDetails;
  OngletsEntreprise? singleOngletToShow;

  final void Function(dynamic value)? onConnexionSuccess;
  final AppBar? appBar;
  List<String>? tabsTitles;

  DashboardEspaceEntreprisePage(
      {Key? key,
      this.menuIsLeft = true,
      this.appBar,
      this.menuHomeContext,
      this.userConnected,
      this.indexTab = 0,
      this.tabsTitles,
      this.showAppBar = false,
      this.singleOngletToShow,
      this.selectedEntrepriseId,
      this.entrepriseToShowDetails,
      this.onConnexionSuccess})
      : super(key: key);

  @override
  State<DashboardEspaceEntreprisePage> createState() => _DashboardEspaceEntreprisePageState();
}

class _DashboardEspaceEntreprisePageState extends State<DashboardEspaceEntreprisePage> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false,
      isUserConnexionRequired = true,
      isOwnerConnected = false,
      isForPublic = false,
      isEditable = true,
      showBtnSuivant = false;
  List<String> tabsTitles = [];
  List<Entreprise> userConnectedEntrepriseList = [];
  List<DrawerItem> menuItemsList = [];
  List<CategorieEntreprise> categorieEntrepriseList = [];
  Entreprise selectedEntreprise = Entreprise();
  Users userConnectedInfos = Users();
  String? selectedEntrepriseId;
  Widget pageToShow = Container();
  int countOnItemPressed = 0;

  late TabController tabController;

  void getCategorieList() async {
    Preferences(skipLocal: false).getCategorieEntrepriseListFromLocal().then((value) => {
          setState(() {
            categorieEntrepriseList.clear();
            categorieEntrepriseList.addAll(value);
            // getEntrepriseList();
          })
        });
  }

  // }
  void rebuildTab() {
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
          userConnectedInfos = value.isNotEmpty ? value.single : Users(),
          if (userConnectedInfos != Users())
            {
              getUserConnectedEntrepriseList(),
            },
          if (isForPublic)
            {
              setState(() {
                selectedEntreprise = widget.entrepriseToShowDetails!;
              }),
            }
          else
            {
              getCategorieList(),
            },
        });
  }

  void getUserConnectedEntrepriseList() async {
    Preferences(skipLocal: true)
        .getEntrepriseListFromLocal(
          id_owner: userConnectedInfos.id,
          id_users: userConnectedInfos.id,
        )
        .then((value) => {
              setState(() {
                userConnectedEntrepriseList.clear();
                if (value.isNotEmpty) {
                  userConnectedEntrepriseList.addAll(value);
                  print("userConnectedEntrepriseList: $userConnectedEntrepriseList");
                  selectedEntreprise = userConnectedEntrepriseList.first;
                  isOwnerConnected = selectedEntreprise.id_users == userConnectedInfos.id!;
                }
                getMenuItemsList();
                if (!isForPublic) {
                  isLoading = false;
                }
              })
            });
  }

  void reloadPage({String? id_entreprise}) {
    selectedEntrepriseId = id_entreprise != null ? id_entreprise : selectedEntrepriseId;
    setState(() {
      isLoading = true;
      getUserConnected();
    });
  }

  void getMenuItemsList() {
    /*if (mayShowOnglet(onglet: OngletsEntreprise.ONGLET_CONFIGURATION))
      menuItemsList.add(DrawerItem(
          iconData: FluentIcons.service_bell_16_regular,
          name: OngletsEntreprise.ONGLET_CONFIGURATION.titre,
          visible: true,
          page: ConfigEntreprisePage(
            entreprise: selectedEntreprise,
          )));*/
    if (mayShowOnglet(onglet: OngletsEntreprise.ONGLET_PRESENTATION))
      menuItemsList.add(DrawerItem(
        iconData: FluentIcons.note_20_regular,
        name: OngletsEntreprise.ONGLET_PRESENTATION.titre,
        visible: true,
        page: EntrepriseDetailsPage(
          key: ValueKey<Entreprise>(selectedEntreprise),
          isEspaceEntreprise: isEditable,
          entreprise: selectedEntreprise,
          homeContext: widget.menuHomeContext,
          userConnected: userConnectedInfos,
          espaceEntrepriseContext: context,
        ),
      ));

    if (mayShowOnglet(onglet: OngletsEntreprise.ONGLET_AGENCES))
      menuItemsList.add(DrawerItem(
        iconData: FluentIcons.history_24_regular,
        name: OngletsEntreprise.ONGLET_AGENCES.titre,
        visible: true,
        page: EntrepriseListWidget(
          padding: EdgeInsets.symmetric(vertical: 0),
          key: ValueKey<String?>("Agence_$selectedEntreprise"),
          idEntrepriseParente: selectedEntreprise.id,
          idUsers: userConnectedInfos.id,
          skipLocal: true,
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        ),
      ));

    if (mayShowOnglet(onglet: OngletsEntreprise.ONGLET_FILIERES))
      menuItemsList.add(DrawerItem(
        iconData: FluentIcons.person_20_regular,
        name: OngletsEntreprise.ONGLET_FILIERES.titre,
        visible: true,
        page: SchoolFilieresListWidget(
          key: ValueKey<String>("Filiere_${selectedEntreprise.toString()}"),
          showItemAsCard: true,
          backColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ecole: selectedEntreprise,
          showAsGridView: true,
          canAddItem: isOwnerConnected,
          canEditItem: isOwnerConnected,
          canDeleteItem: isOwnerConnected,
        ),
      ));

    if (mayShowOnglet(onglet: OngletsEntreprise.ONGLET_MEDIAS))
      menuItemsList.add(DrawerItem(
        iconData: FluentIcons.building_20_regular,
        name: OngletsEntreprise.ONGLET_MEDIAS.titre,
        visible: true,
        page: MediasListWidget(
          id_user: selectedEntreprise.id_users ?? "",
          id_cible: selectedEntreprise.id ?? "",
          cible: Constantes().constCibleMediaEntreprise,
          canAddItem: isOwnerConnected,
          canDeleteItem: isOwnerConnected,
          onItemPressed: (value) {
            setState(() {
              if (value.lien_fichier != null) {
                if (value.lien_fichier!.isNotEmpty) {
                  Fonctions().showMediaLargeDialog(
                      context: context,
                      imageLinkList: ["https://${ConstantUrl.urlServer}${ConstantUrl.base}${value.lien_fichier!}"]);
                }
              }
            });
          },
          backColor: Colors.white,
          // list: mediasList,
          showAsGrid: true,
          isEspaceEntreprise: !isForPublic,
        ),
      ));

    if (mayShowOnglet(onglet: OngletsEntreprise.ONGLET_ACTUALITES))
      menuItemsList.add(DrawerItem(
        iconData: FluentIcons.history_24_regular,
        name: OngletsEntreprise.ONGLET_ACTUALITES.titre,
        visible: true,
        page: ActualiteListWidget(
          key: ValueKey<String>("Actualite_${selectedEntreprise.toString()}"),
          showAsGrid: true,
          isEspaceEntreprise: isEditable,
          canAddItem: isOwnerConnected,
          canEditItem: isOwnerConnected,
          canDeleteItem: isOwnerConnected,
          idSelectedEntreprise: selectedEntreprise.id ?? "",
          homeContext: widget.menuHomeContext,
        ),
      ));

    if (mayShowOnglet(onglet: OngletsEntreprise.ONGLET_BOUTIQUE))
      menuItemsList.add(DrawerItem(
        iconData: FluentIcons.history_24_regular,
        name: OngletsEntreprise.ONGLET_BOUTIQUE.titre,
        visible: true,
        page: isOwnerConnected
            ? DashboardBoutiquierPage(
                idSelectedEntreprise: selectedEntreprise.id ?? "",
                entreprise: selectedEntreprise,
                connectedUser: userConnectedInfos,
                key: ValueKey<String>(selectedEntreprise.toString()),
              ) /*ProduitsBoutiquePage(
                    idSelectedEntreprise: selectedEntreprise.id ?? "",
                    homeContext: widget.menuHomeContext,
                    userConnected: userConnectedInfos,
                  )*/ /* */
            : ProduitListWidget(
                idSelectedEntreprise: selectedEntreprise.id ?? "",
                key: ValueKey<String>(selectedEntreprise.nom ?? ""),
                showAsGrid: true,
                isEspaceEntreprise: isEditable,
                canAddItem: isOwnerConnected,
                canEditItem: isOwnerConnected,
                canDeleteItem: isOwnerConnected,
                showAppBar: false,
                homeContext: widget.menuHomeContext,
              ),
      ));

    if (mayShowOnglet(onglet: OngletsEntreprise.ONGLET_SERVICES))
      menuItemsList.add(DrawerItem(
        iconData: FluentIcons.history_24_regular,
        name: OngletsEntreprise.ONGLET_SERVICES.titre,
        visible: true,
        page: ServicesListWidget(
          canAddItem: isOwnerConnected,
          canEditItem: isOwnerConnected,
          canDeleteItem: isOwnerConnected,
          entreprise: selectedEntreprise,
          idSelectedEntreprise: selectedEntreprise.id,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          showAsGridView: true,
        ),
      ));

    menuItemsList.add(DrawerItem(
      iconData: Icons.settings,
      name: OngletsEntreprise.ONGLET_CONFIGURATION.titre,
      visible: true,
      page: ConfigEntreprisePage(
        entreprise: selectedEntreprise,
      ),
    ));

    menuItemsList.add(DrawerItem(
      iconData: Icons.person,
      name: "Profil",
      visible: true,
      page: UsersDetailsPage(
        users: userConnectedInfos,
      ), /*UserProfileMenu(
        userConnected: userConnectedInfos,
        context: context,
        scaffoldKey: scaffoldKey,
        pageToGo: DashboardEspaceEntreprisePage(),
      ),*/
    ));

    setState(() {
      /*if (mayShowOnglet(onglet: OngletsEntreprise.ONGLET_PRESENTATION)) {
        setState(() {
          print("Yes i am in this");
        });
      }*/
      final firstMenuInMyMenuWidget = widget.singleOngletToShow != null
          ? menuItemsList.firstWhere((element) => element.name == widget.singleOngletToShow!.titre)
          : null;
      final firstMenuPageInMyMenuWidget = firstMenuInMyMenuWidget != null ? firstMenuInMyMenuWidget.page : null;
      pageToShow = firstMenuPageInMyMenuWidget ??
          EntrepriseDetailsPage(
            key: ValueKey<Entreprise>(selectedEntreprise),
            isEspaceEntreprise: isEditable,
            entreprise: selectedEntreprise,
            homeContext: widget.menuHomeContext,
            userConnected: userConnectedInfos,
            espaceEntrepriseContext: context,
          );
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    isForPublic = widget.entrepriseToShowDetails != null;
    isEditable = widget.entrepriseToShowDetails == null;
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
    //print('isForPublic: $isForPublic');
    if (isForPublic) {
      selectedEntreprise = widget.entrepriseToShowDetails!;
      rebuildTab();
    }

    /*if (mayShowOnglet(onglet: Constantes().ONGLET_BOUTIQUE) && isOwnerConnected)
        TabObject(
          onglet: Tab(
            text: Constantes().ONGLET_BOUTIQUE,
          ),
          page: ProduitsBoutiquePage(
            idSelectedEntreprise: selectedEntreprise.id ?? "",
            homeContext: widget.menuHomeContext,
            userConnected: userConnectedInfos,
          ),
        ),*/

    /*if (isOwnerConnected)
        TabObject(
          onglet: Tab(
            text: "Vérification de commande",
          ),
          page: VerificationFacturePage(
            //context: widget.menuHomeContext,
            backColor: Colors.white,
            userConnected: userConnectedInfos,
          ),
        ),
      if (isOwnerConnected)
        TabObject(
          onglet: Tab(
            text: "Produits",
          ),
          page: ProduitsBoutiquePage(
            //context: widget.menuHomeContext,
            userConnected: userConnectedInfos,
            idSelectedEntreprise: selectedEntreprise.id ?? "",
          ),
        ),
      if (isOwnerConnected)
        TabObject(
          onglet: Tab(
            text: "Journal de vente",
          ),
          page: JournalBoutiqueListPage(
            //context: widget.menuHomeContext,
            userConnected: userConnectedInfos,
            idSelectedEntreprise: selectedEntreprise.id ?? "",
          ),
        ),
      if (isOwnerConnected)
        TabObject(
          onglet: Tab(
            text: "Gérants",
          ),
          page: GestionnaireEntrepriseListPage(
            //context: widget.menuHomeContext,
            userConnected: userConnectedInfos,
            idEntreprise: selectedEntreprise.id ?? "",
          ),
        ),*/

    super.initState();
  }

  void didUpdateWidget(covariant DashboardEspaceEntreprisePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    rebuildTab();
  }

  @override
  Widget build(BuildContext context) {
    isOwnerConnected = userConnectedInfos.id == null ? false : selectedEntreprise.id_users == userConnectedInfos.id!;
    final theme = Theme.of(context);
    return (userConnectedInfos.id == null && !isForPublic)
        ? LoginPage(
            onConnexionSuccess: (ctx, user) {
              if (widget.onConnexionSuccess != null) {
                widget.onConnexionSuccess!(user);
              } else {
                Fonctions().openPageToGo(
                    contextPage: ctx,
                    pageToGo: DashboardEspaceEntreprisePage(
                      userConnected: user,
                      singleOngletToShow: widget.singleOngletToShow,
                    ),
                    replacePage: true);
              }
            },
          )
        : Scaffold(
            key: scaffoldKey,
            appBar: widget.appBar ??
                (widget.showAppBar == true
                    ? (widget.appBar ??
                        (widget.entrepriseToShowDetails != null
                            ? Fonctions().defaultAppBar(
                                context: context,
                                homeContext: widget.menuHomeContext,
                                object: userConnectedInfos,
                                scaffoldKey: scaffoldKey,
                                iconColor: ConstantColor.accentColor,
                                titreColor: ConstantColor.accentColor,
                                titre: '${widget.entrepriseToShowDetails!.nom}',
                                elevation: 0.0,
                                showAccount: true,
                                backgroundColor: Fonctions().isSmallScreen(context) ? Colors.white : Colors.white)
                            : Fonctions().defaultAppBar(
                                context: context,
                                homeContext: widget.menuHomeContext,
                                object: userConnectedInfos,
                                scaffoldKey: scaffoldKey,
                                showAccount: true,
                                titre: 'Espace Entreprise',
                                backgroundColor: ConstantColor.accentColor)))
                    : null),
            endDrawer: Fonctions().isSmallScreen(context)
                ? UserProfileMenu(
                    userConnected: userConnectedInfos,
                    context: context,
                    scaffoldKey: scaffoldKey,
                    pageToGo: DashboardEspaceEntreprisePage(),
                  )
                : null,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: MyResponsiveWidget(
                      largeScreen: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isLoading && userConnectedEntrepriseList.isNotEmpty && widget.menuIsLeft)
                            _EntrepriseOptionsBlocAsMenu(),
                          if (!isLoading && userConnectedEntrepriseList.isNotEmpty) Expanded(child: pageToShow),
                          if (!isLoading && userConnectedEntrepriseList.isNotEmpty && !widget.menuIsLeft)
                            _EntrepriseOptionsBlocAsMenu(),
                        ],
                      ),
                      smallScreen: Column(
                        children: [
                          if (!isLoading && userConnectedEntrepriseList.isNotEmpty) _EntrepriseInDropBloc(),
                          if (!isLoading && userConnectedEntrepriseList.isNotEmpty && getTabs().length > 0)
                            Expanded(
                              child: Column(
                                children: [
                                  if (getTabs().length > 1)
                                    Column(
                                      children: [
                                        TabBar(
                                          tabs: getTabs().map((e) => e.onglet).toList(),
                                          controller: tabController,
                                          isScrollable: true,
                                          indicatorColor: ConstantColor.accentColor,
                                          labelColor: ConstantColor.accentColor,
                                          indicatorSize: TabBarIndicatorSize.label,
                                          unselectedLabelColor: ConstantColor.textColor,
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
                        ],
                      ),
                    ),
                  ),
                  if (isLoading) Expanded(child: Center(child: MyLoadingWidget())),
                  if (!isLoading && selectedEntreprise.id == null && !isForPublic)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        child: Center(
                          child: MyErrorWidget(
                            errorMessage: "Vous n'avez aucune entreprise. Veuillez en créer une",
                            style: Styles().getTitreInfosTextStyle(),
                            actionText: "Créer une entreprise",
                            actionBackColor: theme.primaryColor,
                            action: () {
                              Fonctions().openPageToGo(
                                contextPage: context,
                                pageToGo: InscriptionEntreprisePage(
                                  reload: (value) {
                                    reloadPage(id_entreprise: value);
                                    setState(() {});
                                  },
                                  CategorieEntrepriseList: categorieEntrepriseList,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
  }

  bool mayShowOnglet({required OngletsEntreprise onglet}) {
    return widget.singleOngletToShow != null
        ? widget.singleOngletToShow == onglet
        : (selectedEntreprise.public_onglets != null &&
                (selectedEntreprise.public_onglets!.contains("${onglet.titre}|") && isForPublic)) ||
            (selectedEntreprise.owner_onglets != null &&
                (selectedEntreprise.owner_onglets!.contains("${onglet.titre}|") && isOwnerConnected));
  }

  Widget _EntrepriseInDropBloc() {
    return Container(
      color: Colors.white,
      child: widget.entrepriseToShowDetails != null
          ? Container(
              height: Fonctions().isSmallScreen(context) ? 16 : 0,
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      constraints: BoxConstraints(maxWidth: 300),
                      child: EntrepriseListWidget(
                        padding: EdgeInsets.symmetric(vertical: 0),
                        key: ValueKey<String?>("$selectedEntreprise"),
                        backColor: Colors.white,
                        //initialEntreprise: selectedEntreprise,
                        selectedEntrepriseId: selectedEntrepriseId,
                        skipLocal: true,
                        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                        showAsDropDown: true,
                        list: userConnectedEntrepriseList,
                        //idOwner: userConnectedInfos.id,
                        //idUsers: userConnectedInfos.id,
                        onStartLoadingItem: () {
                          setState(() {
                            //print("OnLoading Es");
                            isLoading = true;
                          });
                        },
                        onItemsLoaded: (entreprises) {
                          setState(() {
                            isLoading = false;
                            selectedEntreprise = entreprises.isNotEmpty ? entreprises.first : Entreprise();

                            //selectedEntrepriseId = selectedEntreprise.id;
                            rebuildTab();
                          });
                        },
                        //ce n'est pas utilisé pour le moment
                        onItemsLoadFailed: () {
                          setState(() {
                            selectedEntreprise = Entreprise();
                            print("dinguerie");
                            isLoading = false;
                          });
                        },
                        onItemPressed: (entreprise) {
                          setState(() {
                            selectedEntreprise = entreprise;
                            selectedEntrepriseId = selectedEntreprise.id;
                            countOnItemPressed++;
                            print("countOnItemPressed: $countOnItemPressed");
                            if (countOnItemPressed > 1 && !Fonctions().isSmallScreen(context)) {
                              Fonctions().openPageToGo(
                                contextPage: context,
                                pageToGo: DashboardEspaceEntreprisePage(
                                  selectedEntrepriseId: selectedEntrepriseId,
                                  singleOngletToShow: widget.singleOngletToShow,
                                ),
                                replacePage: true,
                              );
                            }
                            rebuildTab();
                          });
                        },
                      ),
                    ),
                  ),
                  /*Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyButtonWidget(
                        iconData: Icons.settings,
                        iconColor: Colors.white,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        action: () {
                          Fonctions()
                              .openPageToGo(
                                  contextPage: context,
                                  pageToGo: ConfigEntreprisePage(
                                    entreprise: selectedEntreprise,
                                  ))
                              .then((value) {
                            setState(() {
                              selectedEntrepriseId = value;
                            });
                          });
                        },
                      ),*/
                  if (!Fonctions().isSmallScreen(context))
                    MyButtonWidget(
                      iconData: Icons.add,
                      iconColor: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 0),
                      padding: EdgeInsets.zero,
                      action: () {
                        Fonctions().openPageToGo(
                          contextPage: context,
                          pageToGo: InscriptionEntreprisePage(
                            reload: (value) {
                              reloadPage(id_entreprise: value);
                              selectedEntreprise = Entreprise();
                              setState(() {});
                            },
                            CategorieEntrepriseList: categorieEntrepriseList,
                          ),
                        );
                      },
                    ),
                  /*if (isOwnerConnected)
                                    MouseRegion(
                                      cursor: MaterialStateMouseCursor.clickable,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            scaffoldKey.currentState!.openEndDrawer();
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: MyImageModel(
                                            size: 55,
                                            urlImage:
                                                "https://${ConstantUrl.urlServer}${ConstantUrl.base}${userConnectedInfos.img_pp_link ?? 'assets/images/user.png'}",
                                            isRounded: true,
                                            defaultUrlImage: "assets/images/user.png",
                                            isUserProfile: true,
                                          ),
                                        ),
                                      ),
                                    ),*/ /*
                    ],
                  ),*/
                ],
              ),
            ),
    );
  }

  Widget _EntrepriseOptionsBlocAsMenu() {
    return Column(
      children: [
        if (isLoading)
          Expanded(
            child: MyMenuWidget(
                headerHeight: 100,
                //isCollapsed: true,
                customHeader: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 80, width: 200, child: _EntrepriseInDropBloc()),
                  ],
                ),
                itemList: menuItemsList,
                backColor: ConstantColor.lightColor,
                onTap: (index) {
                  setState(() {
                    pageToShow = menuItemsList[index].page!;
                  });
                }),
          ),
        if (!isLoading)
          Expanded(
            child: MyMenuWidget(
                headerHeight: 153,
                //isCollapsed: true,
                customHeader: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyMediaWidget(
                      key: ValueKey<String>("Logo: ${selectedEntreprise.id}"),
                      width: 72,
                      height: 72,
                      backgroundColor: Colors.white,
                      urlImage: selectedEntreprise.img_logo_link!.isNotEmpty
                          ? selectedEntreprise.img_logo_link
                          : "https://${ConstantUrl.urlServer}${ConstantUrl.logoEntrepriseBase}${selectedEntreprise.id_sous_categorie}.jpg",
                      /* isEditable: entreprise!.img_logo_link!.isEmpty &&
                      widget.userConnected != null &&
                      widget.userConnected!.id == widget.entreprise.id,*/
                      fit: BoxFit.contain,
                      showButtonToSend: true,
                    ),
                    _EntrepriseInDropBloc(),
                  ],
                ),
                itemList: menuItemsList,
                backColor: ConstantColor.lightColor,
                onTap: (index) {
                  setState(() {
                    pageToShow = menuItemsList[index].page!;
                  });
                }),
          ),
      ],
    );
  }

  List<TabObject> getTabs() {
    setState(() {});
    return [
      if (mayShowOnglet(onglet: OngletsEntreprise.ONGLET_CONFIGURATION))
        TabObject(
          onglet: Tab(
            text: OngletsEntreprise.ONGLET_CONFIGURATION.titre,
          ),
          page: ConfigEntreprisePage(
            entreprise: selectedEntreprise,
          ),
        ),
      if (mayShowOnglet(onglet: OngletsEntreprise.ONGLET_PRESENTATION))
        TabObject(
          onglet: Tab(
            text: OngletsEntreprise.ONGLET_PRESENTATION.titre,
          ),
          page: EntrepriseDetailsPage(
            key: ValueKey<Entreprise>(selectedEntreprise),
            isEspaceEntreprise: isEditable,
            entreprise: selectedEntreprise,
            homeContext: widget.menuHomeContext,
            userConnected: userConnectedInfos,
            espaceEntrepriseContext: context,
          ),
        ),
      if (mayShowOnglet(onglet: OngletsEntreprise.ONGLET_AGENCES))
        TabObject(
          onglet: Tab(
            text: OngletsEntreprise.ONGLET_AGENCES.titre,
          ),
          page: EntrepriseListWidget(
            padding: EdgeInsets.symmetric(vertical: 0),
            key: ValueKey<String?>("Agence_$selectedEntreprise"),
            idEntrepriseParente: selectedEntreprise.id,
            idUsers: userConnectedInfos.id,
            skipLocal: true,
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          ),
        ),
      if (mayShowOnglet(onglet: OngletsEntreprise.ONGLET_FILIERES))
        TabObject(
          onglet: Tab(
            text: OngletsEntreprise.ONGLET_FILIERES.titre,
          ),
          page: SchoolFilieresListWidget(
            key: ValueKey<String>("Filiere_${selectedEntreprise.toString()}"),
            showItemAsCard: true,
            backColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ecole: selectedEntreprise,
            showAsGridView: true,
            canAddItem: isOwnerConnected,
            canEditItem: isOwnerConnected,
            canDeleteItem: isOwnerConnected,
          ),
        ),
      if (mayShowOnglet(onglet: OngletsEntreprise.ONGLET_MEDIAS))
        TabObject(
          onglet: Tab(
            text: OngletsEntreprise.ONGLET_MEDIAS.titre,
          ),
          page: MediasListWidget(
            id_user: selectedEntreprise.id_users ?? "",
            id_cible: selectedEntreprise.id ?? "",
            cible: Constantes().constCibleMediaEntreprise,

            canAddItem: isOwnerConnected,
            canDeleteItem: isOwnerConnected,
            onItemPressed: (value) {
              setState(() {
                if (value.lien_fichier != null) {
                  if (value.lien_fichier!.isNotEmpty) {
                    Fonctions().showMediaLargeDialog(
                        context: context,
                        imageLinkList: ["https://${ConstantUrl.urlServer}${ConstantUrl.base}${value.lien_fichier!}"]);
                  }
                }
              });
            },
            backColor: Colors.white,
            // list: mediasList,
            showAsGrid: true,
            isEspaceEntreprise: !isForPublic,
          ),
        ),
      if (mayShowOnglet(onglet: OngletsEntreprise.ONGLET_ACTUALITES))
        TabObject(
            onglet: Tab(
              text: OngletsEntreprise.ONGLET_ACTUALITES.titre,
            ),
            page: ActualiteListWidget(
              key: ValueKey<String>("Actualite_${selectedEntreprise.toString()}"),
              showAsGrid: true,
              isEspaceEntreprise: isEditable,
              canAddItem: isOwnerConnected,
              canEditItem: isOwnerConnected,
              canDeleteItem: isOwnerConnected,
              idSelectedEntreprise: selectedEntreprise.id ?? "",
              homeContext: widget.menuHomeContext,
            )),
      if (mayShowOnglet(onglet: OngletsEntreprise.ONGLET_BOUTIQUE))
        TabObject(
            onglet: Tab(
              text: OngletsEntreprise.ONGLET_BOUTIQUE.titre,
            ),
            page: isOwnerConnected
                ? BoutiquierDashboard(
                    idSelectedEntreprise: selectedEntreprise.id ?? "",
                    entreprise: selectedEntreprise,
                    connectedUser: userConnectedInfos,
                    key: ValueKey<String>(selectedEntreprise.toString()),
                  ) /*ProduitsBoutiquePage(
                    idSelectedEntreprise: selectedEntreprise.id ?? "",
                    homeContext: widget.menuHomeContext,
                    userConnected: userConnectedInfos,
                  )*/ /* */
                : ProduitListWidget(
                    idSelectedEntreprise: selectedEntreprise.id ?? "",
                    key: ValueKey<String>(selectedEntreprise.nom ?? ""),
                    showAsGrid: true,
                    isEspaceEntreprise: isEditable,
                    canAddItem: isOwnerConnected,
                    canEditItem: isOwnerConnected,
                    canDeleteItem: isOwnerConnected,
                    showAppBar: false,
                    homeContext: widget.menuHomeContext,
                  )),
      if (mayShowOnglet(onglet: OngletsEntreprise.ONGLET_SERVICES))
        TabObject(
          onglet: Tab(
            text: OngletsEntreprise.ONGLET_SERVICES.titre,
          ),
          page: ServicesListWidget(
            canAddItem: isOwnerConnected,
            canEditItem: isOwnerConnected,
            canDeleteItem: isOwnerConnected,
            entreprise: selectedEntreprise,
            idSelectedEntreprise: selectedEntreprise.id,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            showAsGridView: true,
          ),
        ),

      /*if (mayShowOnglet(onglet: Constantes().ONGLET_BOUTIQUE) && isOwnerConnected)
        TabObject(
          onglet: Tab(
            text: Constantes().ONGLET_BOUTIQUE,
          ),
          page: ProduitsBoutiquePage(
            idSelectedEntreprise: selectedEntreprise.id ?? "",
            homeContext: widget.menuHomeContext,
            userConnected: userConnectedInfos,
          ),
        ),*/

      /*if (isOwnerConnected)
        TabObject(
          onglet: Tab(
            text: "Vérification de commande",
          ),
          page: VerificationFacturePage(
            //context: widget.menuHomeContext,
            backColor: Colors.white,
            userConnected: userConnectedInfos,
          ),
        ),
      if (isOwnerConnected)
        TabObject(
          onglet: Tab(
            text: "Produits",
          ),
          page: ProduitsBoutiquePage(
            //context: widget.menuHomeContext,
            userConnected: userConnectedInfos,
            idSelectedEntreprise: selectedEntreprise.id ?? "",
          ),
        ),
      if (isOwnerConnected)
        TabObject(
          onglet: Tab(
            text: "Journal de vente",
          ),
          page: JournalBoutiqueListPage(
            //context: widget.menuHomeContext,
            userConnected: userConnectedInfos,
            idSelectedEntreprise: selectedEntreprise.id ?? "",
          ),
        ),
      if (isOwnerConnected)
        TabObject(
          onglet: Tab(
            text: "Gérants",
          ),
          page: GestionnaireEntrepriseListPage(
            //context: widget.menuHomeContext,
            userConnected: userConnectedInfos,
            idEntreprise: selectedEntreprise.id ?? "",
          ),
        ),*/
    ];
  }
}

class TabObject {
  Tab onglet;
  Widget page;

  TabObject({required this.onglet, required this.page});
}
