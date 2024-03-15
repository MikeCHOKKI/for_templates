import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/Fonctions/firebase_services.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyMinimalDisplayInfos.dart';
import 'package:core/common_folder/widgets/MyMotionDelayAnimator.dart';
import 'package:core/common_folder/widgets/MySnakBar.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/formulaires.dart';
import 'package:core/objet/Users.dart';
import 'package:core/preferences.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

class UsersDetailsPage extends StatefulWidget {
  final Users users;
  final void Function() reloadPage;
  const UsersDetailsPage({Key? key, required this.users, required this.reloadPage}) : super(key: key);

  @override
  State<UsersDetailsPage> createState() => _UsersDetailsPageState();
}

class _UsersDetailsPageState extends State<UsersDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: ListView(
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
            addSemanticIndexes: true,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 200,
                      constraints: BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        color: ConstantColor.accentColor,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(
                            360,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 40.0),
                            child: MyImageModel(
                              width: 120,
                              height: 120,
                              urlImage:
                                  "https://${ConstantUrl.urlServer}${ConstantUrl.base}${widget.users.img_pp_link}",
                              fit: BoxFit.cover,
                              isUserProfile: true,
                              showDefaultImage: true,
                            ),
                          ),
                          MyMotionDelayAnimator(
                            delay: 1500,
                            movementAnimation: MovementEtat.downToup,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 40.0),
                                  margin: EdgeInsets.only(top: 12.0),
                                  child: MyTextWidget(
                                    text: "${widget.users.nom} ${widget.users.prenom} ",
                                    theme: BASE_TEXT_THEME.TITLE,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Row(
                        children: <Widget>[
                          MyButtonWidget(
                            iconData: Icons.edit_rounded,
                            iconColor: ConstantColor.accentColor,
                            backColor: Colors.transparent,
                            showShadow: false,
                            action: () {
                              Fonctions().showWidgetAsDialog(
                                context: context,
                                title: "Modification",
                                widget: Formulaire(
                                  contextFormulaire: context,
                                  successCallBack: () {
                                    Navigator.pop(context);
                                    widget.reloadPage();
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    MySnakBar().showSnackBarStyle2(
                                      context,
                                      alerteetat: ALERTEETAT.REUSSI,
                                      message: "Modification réussi",
                                    );
                                  },
                                ).saveUsersForm(objectUsers: widget.users),
                              );
                            },
                          ),
                          MyButtonWidget(
                            iconData: Icons.logout_rounded,
                            iconColor: ConstantColor.accentColor,
                            backColor: Colors.transparent,
                            showShadow: false,
                            action: () async {
                              await FirebaseServices().deconnexion().then((value) async {
                                await Preferences.clearData().then((value) async {
                                  widget.reloadPage();
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    MyMinimalDisplayInfos(
                      iconInfos: Icons.cake_outlined,
                      title: 'Date de naissance',
                      content: "${widget.users.date_naissance}",
                    ),
                    MyMinimalDisplayInfos(
                      iconInfos: Icons.location_on_outlined,
                      title: 'Adresse',
                      content: "${widget.users.adresse}, ${widget.users.ville}, ${widget.users.pays}",
                    ),
                    MyMinimalDisplayInfos(
                      iconInfos: Icons.mail_outline_outlined,
                      title: 'Email',
                      content: "${widget.users.mail}",
                    ),
                    MyMinimalDisplayInfos(
                      iconInfos: Icons.phone_outlined,
                      title: 'Téléphone',
                      content: "${widget.users.telephone}",
                    ),
                    MyMinimalDisplayInfos(
                      iconInfos: Mdi.whatsapp,
                      title: 'Whatsapp',
                      content: "${widget.users.whatsapp}",
                    ),
                    MyMinimalDisplayInfos(
                      iconInfos: Icons.facebook_outlined,
                      title: 'Facebook',
                      content: "${widget.users.facebook}",
                    ),
                    MyMinimalDisplayInfos(
                      iconInfos: Icons.telegram_outlined,
                      title: 'Telegram',
                      content: "${widget.users.telegram}",
                    ),
                    MyMinimalDisplayInfos(
                      iconInfos: Mdi.instagram,
                      title: 'Instagram',
                      content: "${widget.users.instagram}",
                    ),
                    MyMinimalDisplayInfos(
                      iconInfos: Mdi.linkedin,
                      title: 'Linkedin',
                      content: "${widget.users.linkedin}",
                    ),
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
