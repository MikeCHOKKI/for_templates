import 'package:core/Api.dart';
import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/Fonctions/firebase_services.dart';
import 'package:core/common_folder/widgets/MySnakBar.dart';
import 'package:core/objet/Entreprise.dart';
import 'package:core/objet/Users.dart';
import 'package:core/pages/LoginPage.dart';
import 'package:core/pages/objet_list/ServicesListWidget.dart';
import 'package:core/preferences.dart';
import 'package:eservice_prive/UsersDetailsPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EserviceHome extends StatefulWidget {
  final bool isConnexion;
  final AppBar? appBar;

  const EserviceHome({Key? key, this.isConnexion = false, this.appBar}) : super(key: key);

  @override
  State<EserviceHome> createState() => _EserviceHomeState();
}

class _EserviceHomeState extends State<EserviceHome> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  bool getusers = false, isConnexion = false, hasEntreprise = false;

  int currentIndex = 0;

  PageController pageController = PageController();

  Users? users;
  Entreprise? entreprise;

  void getUsersInfos() async {
    setState(() {
      getusers = true;
    });
    users = await Preferences()
        .getUsersListFromLocal(id: FirebaseServices.userConnectedFirebaseID ?? "azerty")
        .then((value) => value.isNotEmpty ? value.first : null);
    if (users != null) {
      final data = await Preferences().getEntrepriseListFromLocal(
        id_users: users!.id,
        min_index: 0,
      );
      if (data.isNotEmpty) {
        setState(() {
          entreprise = data.first;
        });
      }
      setState(() {
        hasEntreprise = data.isNotEmpty && data.length == 1;
      });
    } else {
      setState(() {
        hasEntreprise = false;
      });
    }
    if (users != null && isConnexion) {
      MySnakBar().showSnackBarStyle2(
        context,
        alerteetat: ALERTEETAT.REUSSI,
        message: "Bienvenu ${users!.nom} ${users!.prenom}",
      );
    }
    setState(() {
      getusers = false;
      isConnexion = false;
    });
  }

  void sendToken() async {
    final token = await FirebaseServices().getTokenUser();
    final usersInfos = await Preferences()
        .getUsersListFromLocal(id: FirebaseServices.userConnectedFirebaseID ?? "azerty")
        .then((value) => value.isNotEmpty ? value.first : null);
    if (!kIsWeb) {
      await FirebaseMessaging.instance.subscribeToTopic("Eservice");
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
    isConnexion = widget.isConnexion;
    getUsersInfos();
    super.initState();
    sendToken();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        extendBody: true,
        extendBodyBehindAppBar: true,
        /*appBar: Fonctions().defaultAppBar(
          context: context,
          elevation: 0,
          tailleAppBar: 64,
          backgroundColor: ConstantColor.transparentColor,
          actionWidget: Row(
            children: <Widget>[
              if (!getusers)
                MyButtonWidget(
                  text: users != null ? "Mon profil" : "Se connecter",
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  height: null,
                  width: null,
                  backColor: Colors.white,
                  textStyle: Styles().getDefaultTextStyle(
                      fontSize: 14.0, color: ConstantColor.textColor),
                  showShadow: false,
                  action: () {
                    if (scaffoldKey.currentState!.hasEndDrawer) {
                      scaffoldKey.currentState!.openEndDrawer();
                    }
                  },
                ),
              SizedBox(width: 8.0),
              if (users != null)
                MyButtonWidget(
                  text: "Déconnexion",
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  height: null,
                  width: null,
                  backColor: Colors.white,
                  textStyle: Styles().getDefaultTextStyle(
                      fontSize: 14.0, color: ConstantColor.textColor),
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
                ),
              if (getusers)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: ConstantColor.accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: MyLoadingWidget(
                    height: 30,
                    width: 30,
                    color: Colors.white,
                  ),
                ),
              SizedBox(width: 8.0),
            ],
          ),
        ),*/
        endDrawer: Container(
          width: users != null ? 400 : 600,
          child: users != null
              ? UsersDetailsPage(
                  users: users!,
                  reloadPage: () {
                    getUsersInfos();
                  },
                )
              : Fonctions().getDefaultMaterial(
                  theme: theme,
                  home: LoginPage(
                    onConnexionSuccess: (ctx, _) {
                      Fonctions().openPageToGo(
                        contextPage: context,
                        replacePage: true,
                        pageToGo: EserviceHome(
                          isConnexion: true,
                        ),
                      );
                    },
                  ),
                ),
        ),
        body: ServicesListWidget(
          showAsGridView: true,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          showSearchBar: true,
          showAppBar: true,
        ),
      ),
    );
  }
}
