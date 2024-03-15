import 'package:core/Api.dart';
import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/Fonctions/firebase_services.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyLoadingWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/objet/Entreprise.dart';
import 'package:core/objet/Users.dart';
import 'package:core/pages/LoginPage.dart';
import 'package:core/pages/objet_list/VoteCampagneListWidget.dart';
import 'package:core/preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vote_enligne/pages/CreateVoteCampagnePage.dart';
import 'package:vote_enligne/pages/UsersDetailsVote.dart';

class VotePageHome extends StatefulWidget {
  final ThemeData? theme;

  const VotePageHome({Key? key, this.theme}) : super(key: key);

  @override
  State<VotePageHome> createState() => _VotePageHomeState();
}

class _VotePageHomeState extends State<VotePageHome> {
  static const INDEX_ACCUEIL = 0, INDEX_CAMPAGNES = 1, INDEX_PROFIL = 2;
  bool getusers = false;

  int currentIndex = INDEX_PROFIL;

  ImageProvider<Object>? imageCampagne;

  late PageController pageController;

  Users? users;
  Entreprise? entreprise;

  reloadPage() {
    getUsersInfos();
  }

  void getUsersInfos() async {
    setState(() {
      getusers = true;
    });
    users = await Preferences()
        .getUsersListFromLocal(id: FirebaseServices.userConnectedFirebaseID ?? "azerty")
        .then((value) => value.isNotEmpty ? value.first : null);
    print("users: $users");
    setState(() {
      getusers = false;
    });
  }

  void sendToken() async {
    final token = await FirebaseServices().getTokenUser();
    final usersInfos = await Preferences()
        .getUsersListFromLocal(id: FirebaseServices.userConnectedFirebaseID ?? "azerty")
        .then((value) => value.isNotEmpty ? value.first : null);
    if (!kIsWeb) {
      await FirebaseMessaging.instance.subscribeToTopic("Vote");
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
    getUsersInfos();
    pageController = PageController(initialPage: currentIndex);
    super.initState();
    sendToken();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? Theme.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: Fonctions().defaultAppBar(
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: MyTextWidget(
                      text: "Vote en ligne".toUpperCase(),
                      theme: BASE_TEXT_THEME.TITLE,
                    ),
                  ),
                  Spacer(),
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      VoteMenuItemWidget(itemIndex: INDEX_ACCUEIL, icon: Icons.home_outlined, title: "Acceuil"),
                      VoteMenuItemWidget(itemIndex: INDEX_CAMPAGNES, icon: Icons.campaign, title: "Campagnes"),
                      VoteMenuItemWidget(itemIndex: INDEX_PROFIL, icon: Icons.person, title: "Profil"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
            color: theme.primaryColor,
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              children: <Widget>[
                VoteAccueilPage(),
                VoteCampagneListWidget(
                  showItemAsCard: true,
                  canAddItem: true,
                  showAsGridView: true,
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                ),
                users != null
                    ? UsersDetailsVotePage(
                        key: ValueKey<bool>(getusers),
                        users: users!,
                        reloadPage: () {
                          getUsersInfos();
                        },
                      )
                    : !getusers
                        ? LoginPage(onConnexionSuccess: (context, _) {
                            setState(() {});
                            getUsersInfos();
                          })
                        : Container(
                            child: Center(
                              child: MyLoadingWidget(
                                message: "Chargement de vos informations veuillez patienter...",
                              ),
                            ),
                          ),
              ],
            )),
      ),
    );
  }

  Widget VoteMenuItemWidget({required int itemIndex, IconData? icon, String? title = ""}) {
    return MyButtonWidget(
      showShadow: false,
      backColor: currentIndex == itemIndex
          ? Theme.of(context).primaryColor.withOpacity(0.5)
          : ConstantColor.grisColor.withOpacity(0.6),
      iconData: icon,
      iconColor: currentIndex == itemIndex ? Theme.of(context).primaryColor : Colors.black,
      text: Fonctions().isSmallScreen(context) ? "" : title,
      textColor: currentIndex == itemIndex ? Theme.of(context).primaryColor : Colors.black,
      margin: EdgeInsets.all(4),
      radiusButton: 12,
      action: () {
        setState(() {
          currentIndex = itemIndex;
        });
        pageController.jumpToPage(currentIndex);
      },
    );
  }

  Widget VoteAccueilPage() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyImageModel(
                    urlImage: "assets/images/vote_home_mascott.png",
                    fit: BoxFit.contain,
                    size: 800,
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(maxWidth: 900),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyTextWidget(
                              text: "Organisez des votes en ligne",
                              theme: BASE_TEXT_THEME.DISPLAY,
                              textColor: Colors.white,
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            MyTextWidget(
                              text:
                                  "Une façon simple et efficace de créer des campagnes de votes en lignes. L'outil vous permet de céer des campagnes pour lesquels les votes sont gratuits ou payant, de suivre en temps rééls les votes et de comptabiliser automatiquement les résultats.",
                              textColor: Colors.white,
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: MyButtonWidget(
                                  text: "Créer une campagne",
                                  backColor: ConstantColor.accentColor,
                                  action: () async {
                                    Fonctions().openPageToGo(
                                      contextPage: context,
                                      pageToGo: CreateVoteCampagnePage(
                                        reloadPage: () {
                                          Navigator.pop(context);
                                          pageController.jumpToPage(1);
                                        },
                                      ),
                                    );
                                  },
                                )),
                                Expanded(
                                    child: MyButtonWidget(
                                  text: "Voter",
                                  textColor: Colors.white,
                                  backColor: Theme.of(context).colorScheme.secondary,
                                  action: () {
                                    setState(() {
                                      currentIndex = 1;
                                    });
                                    pageController.jumpToPage(currentIndex);
                                  },
                                )),
                              ],
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
