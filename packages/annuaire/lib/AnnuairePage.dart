import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyLoadingWidget.dart';
import 'package:core/common_folder/widgets/MyNoDataWidget.dart';
import 'package:core/common_folder/widgets/MyResponsiveWidget.dart';
import 'package:core/common_folder/widgets/MySnakBar.dart';
import 'package:core/common_folder/widgets/MyTextInputWidget.dart';
import 'package:core/formulaires.dart';
import 'package:core/objet/AdvancedSearchInfos.dart';
import 'package:core/objet/Users.dart';
import 'package:core/pages/objet_list/CategorieEntrepriseListWidget.dart';
import 'package:core/pages/objet_list/EntrepriseListWidget.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

class AnnuairePage extends StatefulWidget {
  final BuildContext? homeContext;
  final Users? userConnected;
  bool? showByProximity, isAdvancedSearch;
  final int indexPageToShow;
  final String theme;
  final String? id_categorie, id_sous_categorie;
  final FocusNode? focusOnSearch;
  final AppBar? appBar;

  AnnuairePage({
    Key? key,
    this.appBar,
    this.userConnected,
    this.homeContext,
    this.indexPageToShow = 0,
    this.theme = "",
    this.showByProximity = false,
    this.isAdvancedSearch = false,
    this.id_categorie,
    this.id_sous_categorie,
    this.focusOnSearch,
  }) : super(key: key);

  @override
  State<AnnuairePage> createState() => _AnnuairePageState();
}

class _AnnuairePageState extends State<AnnuairePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  String themeRecherche = "";
  bool isPermitted = false;
  int indexPageToShow = 0;
  AdvancedSearchInfos? objectSearchAdvanced;

/*
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    final position = await Geolocator.getCurrentPosition();
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return await Geolocator.getCurrentPosition();
    }

    return position;
  }*/
/*
  void enableProximity() async {
    Position position = await determinePosition();
    if (position != null) {
      widget.showByProximity = true;
      indexPageToShow = 1;
    }
    setState(() {});
  }*/

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    indexPageToShow = widget.indexPageToShow;

    searchController.text = widget.theme!;

    searchController.addListener(() {
      //if (kIsWeb) {
      setState(() {
        if (searchController.text.isNotEmpty) {
          widget.isAdvancedSearch = true;
          // elementRecherche = "Recherche local||" + searchController.text;
          indexPageToShow = 1;
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: MyResponsiveWidget(
        largeScreen: WillPopScope(
          onWillPop: () async {
            if (indexPageToShow != 0) {
              setState(() {
                indexPageToShow = 0;
              });
              return false;
            } else {
              return true;
            }
          },
          child: Row(
            children: <Widget>[
              Expanded(
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  key: scaffoldKey,
                  appBar: _appBar(),
                  body: Fonctions().getDefaultMaterial(
                    theme: theme,
                    home: Scaffold(
                      body: Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: contentBody(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        smallScreen: Scaffold(
          key: scaffoldKey,
          body: Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Material(
                    elevation: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.keyboard_arrow_left_outlined)),
                                Expanded(child: searchBar()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: contentBody())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget contentBody() {
    return Column(
      children: [
        if (indexPageToShow == 0)
          Expanded(
            child: CategorieEntrepriseListWidget(
              backColor: Fonctions().isSmallScreen(context) ? Colors.white : null,
              padding: !Fonctions().isSmallScreen(context) ? EdgeInsets.symmetric(horizontal: 16, vertical: 12) : null,
              showAsGrid: !Fonctions().isSmallScreen(context),
              homeContext: widget.homeContext,
            ),
          ),
        if (indexPageToShow == 1)
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: EntrepriseListWidget(
                      key: ValueKey<String?>(
                          "${searchController.text}${widget.showByProximity}${widget.isAdvancedSearch}"),
                      objectSearchAdvanced: objectSearchAdvanced,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      themeRecherche: searchController.text,
                      homeContext: widget.homeContext,
                      showAppBar: false,
                      isAdvancedSearch: widget.isAdvancedSearch,
                      showByProximity: widget.showByProximity,
                      id_sous_categorie: widget.id_sous_categorie,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: MyTextInputWidget(
        textController: searchController,
        hint: "Rechercher...",
        padding: EdgeInsets.zero,
        backColor: Colors.white,
        margin: EdgeInsets.all(4),
        radius: 90,
        rightWidget: Container(
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              /*  MyButtonWidget(
                iconData: Icons.gps_fixed_sharp,
                iconColor: ConstantColor.accentColor,
                padding: EdgeInsets.zero,
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                backColor: Colors.white,
                showShadow: false,
                action: () async {
                  enableProximity();
                },
              ),
              MyButtonWidget(
                iconData: Mdi.searchWeb,
                padding: EdgeInsets.zero,
                backColor: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                iconColor: ConstantColor.accentColor,
                showShadow: false,
                action: () {
                  Fonctions().showWidgetAsDialog(
                    context: context,
                    title: "Recherche avancée",
                    widget: Formulaire(
                        contextFormulaire: context,
                        successCallBack: (valueAdvanced) {
                          setState(() {
                            objectSearchAdvanced = valueAdvanced;
                            elementRecherche = "Recherche avancée||" + "${DateTime.now()}";
                            indexPageToShow = 1;
                          });
                        }).searchAdvanced(contextPage: context, themeRecherche: searchController.text),
                  );
                },
              ),*/
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.showByProximity = true;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Icon(Icons.gps_fixed_outlined),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Fonctions().showWidgetAsDialog(
                    context: context,
                    title: "Recherche avancée",
                    widget: Formulaire(
                        contextFormulaire: context,
                        successCallBack: (valueAdvanced) {
                          setState(() {
                            objectSearchAdvanced = valueAdvanced;
                            widget.isAdvancedSearch = true;
                            //widget.elementRecherche = "Recherche avancée||" + "${DateTime.now()}";
                            indexPageToShow = 1;
                          });
                        }).searchAdvanced(contextPage: context, themeRecherche: searchController.text),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Icon(
                    Mdi.searchWeb,
                  ),
                ),
              )
            ],
          ),
        ),
        leftWidget: const Icon(
          Icons.search,
          size: 16,
          color: ConstantColor.secondColor,
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return widget.appBar ??
        Fonctions().defaultAppBar(
          tailleAppBar: 64,
          context: context,
          customView: Material(
            elevation: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      MyButtonWidget(
                        showShadow: false,
                        backColor: indexPageToShow == 0
                            ? ConstantColor.accentColor.withOpacity(0.2)
                            : ConstantColor.grisColor.withOpacity(0.6),
                        // : ConstantColor.accentColor.withOpacity(0.2),
                        iconData: Icons.toc_sharp,
                        iconColor: indexPageToShow == 0 ? ConstantColor.accentColor : Colors.black,
                        text: "Catégories",
                        textColor: indexPageToShow == 0 ? ConstantColor.accentColor : Colors.black,

                        margin: EdgeInsets.all(4),
                        radiusButton: 12,
                        action: () {
                          setState(() {
                            //elementRecherche = "Catégories";
                            indexPageToShow = 0;
                          });
                          Fonctions().openPageToGo(
                            contextPage: context,
                            pageToGo: AnnuairePage(
                              userConnected: widget.userConnected,
                              indexPageToShow: indexPageToShow,
                            ),
                          );
                        },
                      ),
                      MyButtonWidget(
                        showShadow: false,
                        backColor: indexPageToShow == 1
                            ? ConstantColor.accentColor.withOpacity(0.2)
                            : ConstantColor.grisColor.withOpacity(0.6),
                        iconData: Mdi.officeBuilding,
                        iconColor: indexPageToShow == 1 ? ConstantColor.accentColor : Colors.black,
                        text: "Entreprises",
                        radiusButton: 12,
                        margin: EdgeInsets.all(4),
                        textColor: indexPageToShow == 1 ? ConstantColor.accentColor : Colors.black,
                        action: () {
                          setState(() {
                            indexPageToShow = 1;
                          });
                          Fonctions().openPageToGo(
                            contextPage: context,
                            pageToGo: AnnuairePage(
                              userConnected: widget.userConnected,
                              indexPageToShow: indexPageToShow,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        searchBar(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
