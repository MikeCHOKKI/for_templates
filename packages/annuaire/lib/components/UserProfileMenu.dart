import 'package:annuaire/AnnuaireHome.dart';
import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/Fonctions/firebase_services.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyInfosContactWidget.dart';
import 'package:core/common_folder/widgets/MyLoadingWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/formulaires.dart';
import 'package:core/objet/Medias.dart';
import 'package:core/objet/Users.dart';
import 'package:core/preferences.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

class UserProfileMenu extends StatefulWidget {
  final Users? userConnected;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final BuildContext? context;
  final int? currentIndex;
  final List<Medias>? mediasList;
  final Widget? pageToGo;
  final void Function()? actionDeconnexion;

  UserProfileMenu(
      {Key? key,
      this.actionDeconnexion,
      this.pageToGo,
      this.userConnected,
      this.context,
      this.currentIndex,
      this.mediasList,
      this.scaffoldKey})
      : super(key: key);

  @override
  State<UserProfileMenu> createState() => _UserProfileMenuState();
}

class _UserProfileMenuState extends State<UserProfileMenu> {
  bool isDeconnecting = false, isLoading = false;
  Users userConnected = Users();

  void getUserConnected() {
    userConnected = widget.userConnected!;
    if (isLoading) {
      Preferences(skipLocal: true)
          .getUsersListFromLocal(id: userConnected.id)
          .then((value) => {
                setState(() {
                  userConnected = value.single;
                  isLoading = false;
                })
              })
          .onError((error, stackTrace) => {
                setState(() {
                  isLoading = false;
                })
              });
    }
  }

  void reloadPage() {
    // print("Reload");
    setState(() {
      isLoading = true;
      getUserConnected();
    });
  }

  @override
  void initState() {
    getUserConnected();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: isLoading == true
          ? Center(
              child: MyLoadingWidget(),
            )
          : Container(
              color: Colors.white,
              child: ListView(
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                addSemanticIndexes: true,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  Column(
                    children: [
                      UserAccountsDrawerHeader(
                        currentAccountPictureSize: const Size.square(82),
                        currentAccountPicture: MyImageModel(
                          urlImage: userConnected.img_pp_link != null
                              ? userConnected.img_pp_link!.isNotEmpty
                                  ? "https://${ConstantUrl.urlServer}${ConstantUrl.base}${userConnected.img_pp_link}"
                                  : "assets/images/user.png"
                              : "assets/images/user.png",
                          isUserProfile: true,
                          showDefaultImage: true,
                        ),
                        decoration: const BoxDecoration(color: ConstantColor.primaryColor),
                        accountName: MyTextWidget(
                          text: userConnected.genre != null
                              ? userConnected.genre!.isNotEmpty
                                  ? userConnected.genre != "Masculin"
                                      ? "Mme. ${userConnected.prenom!.split(" ").first} ${userConnected.nom}"
                                      : "M. ${userConnected.prenom!.split(" ").first} ${userConnected.nom}"
                                  : "Mr/Mme ${userConnected.prenom!.split(" ").first} ${userConnected.nom}"
                              : "",
                        ),
                        accountEmail: MyTextWidget(
                          text: "${userConnected.mail}",
                        ),
                        arrowColor: ConstantColor.accentColor,
                        otherAccountsPictures: <Widget>[
                          MyButtonWidget(
                            iconData: Mdi.accountEdit,
                            margin: EdgeInsets.zero,
                            backColor: Colors.white,
                            iconColor: ConstantColor.accentColor,
                            action: () {
                              Fonctions().showWidgetAsDialog(
                                context: context,
                                title: "Modification",
                                widget: Formulaire(
                                  contextFormulaire: widget.context!,
                                  successCallBack: reloadPage,
                                  /*() {
                                    Fonctions().openPageToGo(
                                      contextPage: context,
                                      pageToGo: EspaceEntreprisePage(context: widget.context!,userConnected: widget.userConnected,),
                                    );
                                  },*/
                                ).saveUsersForm(objectUsers: userConnected),
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: MyButtonWidget(
                              text: "Déconnexion",
                              load: isDeconnecting,
                              showShadow: false,
                              rounded: true,
                              radiusButton: 12,
                              textColor: Colors.black,
                              backColor: ConstantColor.grisColor.withOpacity(0.6),
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              action: widget.actionDeconnexion ??
                                  () async {
                                    setState(() {
                                      isDeconnecting = true;
                                    });
                                    await Preferences.clearData();
                                    await FirebaseServices().deconnexion().then(
                                      (value) async {
                                        print("Deconn  $value");
                                        if (value != false) {
                                          print("Deconn reussie");
                                          setState(() {
                                            isDeconnecting = false;
                                          });
                                          Fonctions().openPageToGo(
                                              contextPage: widget.context!,
                                              pageToGo: widget.pageToGo ?? AnnuaireHome(),
                                              replacePage: true);
                                          //Navigator.pop(context);
                                        } else {
                                          setState(() {
                                            isDeconnecting = false;
                                          });
                                        }
                                      },
                                    );
                                  },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  /*Visibility(
                    visible: userConnected.date_naissance!.isNotEmpty,
                    child: MyInfosContactWidget(
                      title: "Date de naissance",
                      iconInfos: Mdi.cake,
                      content: "${userConnected.date_naissance}",
                    ),
                  ),*/
                  MyInfosContactWidget(title: "Adresse", content: userConnected.adresse, iconInfos: Mdi.city),
                  MyInfosContactWidget(title: "Pays", content: userConnected.pays, iconInfos: Mdi.city),
                  MyInfosContactWidget(title: "Téléphone", content: userConnected.telephone, iconInfos: Mdi.phone),
                  MyInfosContactWidget(title: "Whatsapp", content: userConnected.whatsapp, iconInfos: Mdi.whatsapp),
                  if (userConnected.code != null)
                    Visibility(
                      visible: userConnected.code!.isNotEmpty,
                      child: MyInfosContactWidget(
                          title: "Code utilisateur", content: userConnected.pays, iconInfos: Mdi.qrcode),
                    ),
                  MyInfosContactWidget(title: "Facebook", content: userConnected.facebook, iconInfos: Mdi.facebook),
                  MyInfosContactWidget(title: "Instagram", content: userConnected.instagram, iconInfos: Mdi.instagram),
                  MyInfosContactWidget(title: "Linkedin", content: userConnected.linkedin, iconInfos: Mdi.linkedin),
                  MyInfosContactWidget(title: "Télégram", content: userConnected.telegram, iconInfos: Mdi.telegram),
                ],
              ),
            ),
    );
  }
}
