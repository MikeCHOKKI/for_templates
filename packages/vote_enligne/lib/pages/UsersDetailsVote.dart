import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/Fonctions/firebase_services.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyMinimalDisplayInfos.dart';
import 'package:core/common_folder/widgets/MyMotionDelayAnimator.dart';
import 'package:core/common_folder/widgets/MySnakBar.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/formulaires.dart';
import 'package:core/objet/Users.dart';
import 'package:core/pages/objet_list/VoteCampagneListWidget.dart';
import 'package:core/pages/objet_list/VoteHistoriqueListWidget.dart';
import 'package:core/preferences.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

class UsersDetailsVotePage extends StatefulWidget {
  final Users users;
  final void Function() reloadPage;

  const UsersDetailsVotePage({Key? key, required this.users, required this.reloadPage}) : super(key: key);

  @override
  State<UsersDetailsVotePage> createState() => _UsersDetailsVotePageState();
}

class _UsersDetailsVotePageState extends State<UsersDetailsVotePage> {
  static const INDEX_CAMPAGNES = 0, INDEX_VOTES = 1;

  int currentIndex = INDEX_VOTES;

  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: currentIndex);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Row(
          children: <Widget>[
            Container(
              width: 320,
              color: Theme.of(context).primaryColor,
              child: ListView(
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                addSemanticIndexes: true,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 250,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 200,
                          constraints: BoxConstraints(maxHeight: 200),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
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
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 40.0),
                                        margin: EdgeInsets.only(top: 12.0),
                                        child: MyTextWidget(
                                          text: "${widget.users.nom} ${widget.users.prenom} ",
                                          theme: BASE_TEXT_THEME.TITLE,
                                          textColor: Colors.white,
                                        ),
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
                                iconColor: Colors.white,
                                backColor: Colors.transparent,
                                showShadow: false,
                                action: () {
                                  Fonctions().showWidgetAsDialog(
                                    context: context,
                                    title: "Modification",
                                    widget: Formulaire(
                                      contextFormulaire: context,
                                      successCallBack: () {
                                        widget.reloadPage();
                                      },
                                    ).saveUsersForm(objectUsers: widget.users),
                                  );
                                },
                              ),
                              MyButtonWidget(
                                iconData: Icons.logout_rounded,
                                iconColor: Colors.white,
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
            Expanded(
              child: Row(
                children: <Widget>[
                  RotatedBox(
                    quarterTurns: -5,
                    child: Fonctions().defaultAppBar(
                      tailleAppBar: 64,
                      context: context,
                      customView: Material(
                        elevation: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              VoteMenuItemWidget(itemIndex: INDEX_VOTES, icon: Icons.how_to_vote, title: "Votes"),
                              VoteMenuItemWidget(itemIndex: INDEX_CAMPAGNES, icon: Icons.campaign, title: "Campagnes"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      children: <Widget>[
                        VoteCampagneListWidget(
                          showItemAsCard: true,
                          canAddItem: true,
                          showAsGridView: true,
                          id_user: widget.users.id,
                          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        ),
                        VoteHistoriqueListWidget(
                          showItemAsCard: true,
                          showAsGridView: true,
                          id_users: widget.users.id,
                          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
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
}
