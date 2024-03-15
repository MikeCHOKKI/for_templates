import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/objet/Entreprise.dart';
import 'package:core/objet/Users.dart';
import 'package:core/preferences.dart';
import 'package:espace_entreprise/EspaceEntreprise.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'components/UserProfileMenu.dart';

class RubriquesAccueilPage extends StatefulWidget {
  final BuildContext? homeContext;
  final Users? userConnected;
  final bool showAppBar;
  final EdgeInsetsGeometry? padding;

  RubriquesAccueilPage({Key? key, this.homeContext, this.userConnected, this.showAppBar = true, this.padding})
      : super(key: key);

  @override
  State<RubriquesAccueilPage> createState() => _RubriquesAccueilPageState();
}

class _RubriquesAccueilPageState extends State<RubriquesAccueilPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  bool isLoading = false, isLoadingProximiter = false;
  String themeRecherche = "";
  List<Entreprise> listAllEntreprise = [];
  List<Entreprise> list = [];
  List<Object> listObject = [];
  PageController pageViewController = PageController(
    initialPage: 0,
    viewportFraction: 0.9,
  );

  int pageIndex = 0;

  void getListAllEntreprise() async {
    setState(() {
      isLoading = true;
    });
    Preferences(skipLocal: false).getEntrepriseListFromLocal().then((value) => {
          setState(() {
            listAllEntreprise.clear();
            listObject.clear();
            searchController.text = "";
            listAllEntreprise.addAll(value);
            isLoading = false;
          })
        });
  }

  Position? position;

  Future<Position> determinePosition() async {
    LocationPermission permission;

    // Test if location services are enabled.
    /* serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }*/

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getListAllEntreprise();

    searchController.addListener(() {
      setState(() {
        themeRecherche = searchController.text;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    listObject = listAllEntreprise
        .where((element) =>
            (Fonctions().removeAccents(element.nom!).toLowerCase().contains(themeRecherche.toLowerCase().trim()) ||
                Fonctions().removeAccents(element.ville!).toLowerCase().contains(themeRecherche.toLowerCase().trim())))
        .toList();
    return SafeArea(
      child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: widget.showAppBar == true
              ? Fonctions().defaultAppBar(
                  context: context,
                  scaffoldKey: scaffoldKey,
                  showAccount: true,
                  showLeading: true,
                  homeContext: widget.homeContext,
                  titre: 'Accueil',
                  backgroundColor: ConstantColor.accentColor,
                  object: widget.userConnected,
                  isAdmin: true,
                  currentIndexPage: 0,
                )
              : null,
          endDrawer: widget.userConnected != null
              ? UserProfileMenu(
                  scaffoldKey: scaffoldKey, context: widget.homeContext!, userConnected: widget.userConnected)
              : null,
          body: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    buzupServiceCard(
                        icon: Icons.contacts,
                        title: "Annuaire",
                        description:
                            "Plus de 10.000 Entreprises Béninoises au même endroit. Bienvenue dans l'annuaire Buz'Up",
                        action: () {
                          setState(() {
                            pageIndex = 2;
                          });
                        }),
                    buzupServiceCard(
                        icon: Icons.business,
                        title: "Espace Entreprise",
                        description:
                            "Inscrivez votre entreprise à l'annuaire Buz'up, et accédez à une multitude d'outils mis à votre disposition pour sa gestion quotidienne",
                        action: () {
                          Fonctions().openPageToGo(
                            contextPage: context,
                            pageToGo: EspaceEntreprisePage(
                              appBar: AppBar(
                                backgroundColor: ConstantColor.accentColor,
                                leading: IconButton(
                                  icon: Icon(Icons.chevron_left),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              )
              /* RubriqueAccueilListWidget(
                homeContext: context,
                padding: widget.padding,
              ),*/
            ],
          )),
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
      String? btText,
      Function? action}) {
    return GestureDetector(
      onTap: () {
        if (action != null) action();
      },
      child: MyCardWidget(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      MyTextWidget(
                        text: title,
                        theme: BASE_TEXT_THEME.TITLE,
                      ),
                    if (description != null)
                      MyTextWidget(
                        text: description,
                      ),
                    if (action != null && (btText != null && btText.isNotEmpty))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                Expanded(
                                  child: MyButtonWidget(
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                      text: btText.isNotEmpty ? btText : "Continuer",
                                      backColor: ConstantColor.accentColor,
                                      action: () {
                                        action();
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
