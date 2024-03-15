// ignore_for_file: non_constant_identifier_names

import 'package:core/Api.dart';
import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/Fonctions/firebase_services.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyLoginWidget.dart';
import 'package:core/common_folder/widgets/MySnakBar.dart';
import 'package:core/common_folder/widgets/MyTextInputWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/formulaires.dart';
import 'package:core/objet/Users.dart';
import 'package:core/objet/VoteCampagne.dart';
import 'package:core/objet/VoteCandidat.dart';
import 'package:core/objet/VoteHistorique.dart';
import 'package:core/pages/objet_details/VoteCampagneDetailsPage.dart';
import 'package:core/pages/objet_list/VoteCandidatListWidget.dart';
import 'package:core/pages/widget/VueVoteCandidat.dart';
import 'package:flutter/material.dart';

class CampagneAndCandidatPage extends StatefulWidget {
  final VoteCampagne votecampagne;
  final Function reloadParentList;
  final String? id_candidat;

  const CampagneAndCandidatPage({
    super.key,
    required this.votecampagne,
    required this.reloadParentList,
    this.id_candidat,
  });

  @override
  State<CampagneAndCandidatPage> createState() =>
      _CampagneAndCandidatPageState();
}

class _CampagneAndCandidatPageState extends State<CampagneAndCandidatPage> {
  bool pendingVote = false, reload = false;
  late PageController _loginPageController, _pageController;

  void callVote({
    String? id_campagne,
    String? id_candidat,
    String? id_users,
    String? nom_users,
    String? telephone_users,
    String? mail_users,
  }) async {
    setState(() {
      pendingVote = true;
    });

    final voteHistorique = VoteHistorique(
      id_campagne: id_campagne,
      id_candidat: id_candidat,
      id_votant: id_users,
      mail_votant: mail_users,
      nom_votant: nom_users,
      telephone_votant: telephone_users,
    );

    Map<String, String> paramsSup = {
      "action": "SAVE",
    };
    await Api.saveObjetApi(
            arguments: voteHistorique,
            additionalArgument: paramsSup,
            url: ConstantUrl.VoteHistoriqueUrl)
        .then((value) {
      if (value["saved"] == true) {
        setState(() {
          pendingVote = false;
          reload = !reload;
        });
      } else {
        setState(() {
          pendingVote = false;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginPageController = PageController();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _loginPageController.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Fonctions().isSmallScreen(context)
            ? PageView(
                controller: _pageController,
                children: [
                  Stack(
                    children: [
                      VoteCampagneDetailsPage(
                        votecampagne: widget.votecampagne,
                        reloadParentList: widget.reloadParentList,
                        mayGetOnline: true,
                      ),
                      Positioned(
                        top: 26,
                        right: 0,
                        child: MyButtonWidget(
                          text: "Candidats",
                          action: () {
                            _pageController.nextPage(
                                duration: Duration(milliseconds: 1500),
                                curve: Curves.easeIn);
                          },
                        ),
                      )
                    ],
                  ),
                  VoteCandidatListWidget(
                    key: ValueKey<bool>(reload),
                    showItemAsCard: true,
                    backColor: ConstantColor.grisColor,
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    canRefresh: true,
                    id_candidat: widget.id_candidat,
                    showAsGridView: true,
                    canAddItem: FirebaseServices.userConnectedFirebaseID ==
                        widget.votecampagne.id_users,
                    id_campagne: widget.votecampagne.id,
                    buildCompletePage: (ctx, list) {
                      return buildCustomViewCandidat(ctx, list);
                    },
                  ),
                ],
              )
            : Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: VoteCampagneDetailsPage(
                      votecampagne: widget.votecampagne,
                      reloadParentList: widget.reloadParentList,
                      mayGetOnline: true,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: VoteCandidatListWidget(
                      key: ValueKey<bool>(reload),
                      showItemAsCard: true,
                      backColor: ConstantColor.grisColor,
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      canRefresh: true,
                      id_candidat: widget.id_candidat,
                      showAsGridView: true,
                      canAddItem: FirebaseServices.userConnectedFirebaseID ==
                          widget.votecampagne.id_users,
                      id_campagne: widget.votecampagne.id,
                      buildCompletePage: (ctx, list) {
                        return buildCustomViewCandidat(ctx, list);
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Expanded buildCustomViewCandidat(
      BuildContext context, List<VoteCandidat> list) {
    return Expanded(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(24.0),
          width: 920,
          constraints: BoxConstraints(maxWidth: 920),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                top: 0,
                child: Material(
                  elevation: .3,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: ConstantColor.grisColor.withOpacity(.5),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(36.0),
                        bottomRight: Radius.circular(36.0),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(40.0),
                    child: Center(
                      child: MyTextWidget(
                        text: "Candidats",
                        theme: BASE_TEXT_THEME.TITLE,
                        textColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: list.length,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        mainAxisExtent: 500,
                      ),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return VueVoteCandidat(
                          votecandidat: list[index],
                          voteCampagne: widget.votecampagne,
                          customView: MyCardWidget(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(20.0),
                                    width: 520,
                                    child: Hero(
                                      tag: "${list[index].id}",
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: const [
                                            BoxShadow(
                                                offset: Offset(0, 4),
                                                blurRadius: 4,
                                                color: Colors.black26)
                                          ],
                                        ),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: <Widget>[
                                            MyImageModel(
                                              urlImage:
                                                  "https://${ConstantUrl.urlServer}${ConstantUrl.base}${list[index].img_photo_link}",
                                              fit: BoxFit.cover,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black12
                                                    .withOpacity(.3),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: MyTextWidget(
                                    text: "${list[index].nom}",
                                    theme: BASE_TEXT_THEME.TITLE,
                                    textColor: Colors.black45,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MyTextWidget(
                                    text: "${list[index].nbr_votes} votes",
                                    textColor: Colors.black87,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MyButtonWidget(
                                    text: "Voter",
                                    load: pendingVote,
                                    action: () {
                                      if (widget.votecampagne
                                              .require_votant_login ==
                                          "1") {
                                        Fonctions().showWidgetAsDialog(
                                          context: context,
                                          widget: StatefulBuilder(
                                              builder: (ctx, setState) {
                                            return Container(
                                              width: 480,
                                              height: 480,
                                              constraints:
                                                  BoxConstraints(maxWidth: 520),
                                              child: PageView(
                                                controller:
                                                    _loginPageController,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                onPageChanged: (index) {
                                                  setState(() {});
                                                },
                                                allowImplicitScrolling: false,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                children: <Widget>[
                                                  Center(
                                                    child: MyLoginWidget(
                                                      onUsersExist: (users) {
                                                        Navigator.pop(ctx);
                                                        setState(() {});
                                                        var user = Users();
                                                        Fonctions()
                                                            .showWidgetAsDialog(
                                                          context: context,
                                                          widget: StatefulBuilder(
                                                              builder: (cotx,
                                                                  setState) {
                                                            return Container(
                                                              width: 500,
                                                              child: Column(
                                                                children: <Widget>[
                                                                  MyTextInputWidget(
                                                                    title:
                                                                        "Votre nom",
                                                                    textController:
                                                                        TextEditingController(
                                                                            text:
                                                                                users!.nom),
                                                                    onChanged:
                                                                        (value) {
                                                                      user.nom =
                                                                          value;
                                                                    },
                                                                  ),
                                                                  MyTextInputWidget(
                                                                    title:
                                                                        "Votre mail",
                                                                    textController:
                                                                        TextEditingController(
                                                                            text:
                                                                                users.mail),
                                                                    onChanged:
                                                                        (value) {
                                                                      user.mail =
                                                                          value;
                                                                    },
                                                                  ),
                                                                  MyTextInputWidget(
                                                                    title:
                                                                        "Votre téléphone",
                                                                    textController:
                                                                        TextEditingController(
                                                                            text:
                                                                                users.telephone),
                                                                    onChanged:
                                                                        (value) {
                                                                      user.telephone =
                                                                          value;
                                                                    },
                                                                  ),
                                                                  Row(
                                                                    children: <Widget>[
                                                                      Expanded(
                                                                        child:
                                                                            MyButtonWidget(
                                                                          text:
                                                                              "Valider",
                                                                          action:
                                                                              () {
                                                                            Navigator.pop(cotx);
                                                                            callVote(
                                                                              id_campagne: widget.votecampagne.id,
                                                                              id_candidat: list[index].id,
                                                                              nom_users: user.nom ?? users.nom,
                                                                              mail_users: user.mail ?? users.mail,
                                                                              telephone_users: user.telephone ?? users.telephone,
                                                                            );
                                                                          },
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          }),
                                                          title: "",
                                                        );
                                                      },
                                                      onUsersNonExist: (users) {
                                                        _loginPageController
                                                            .animateToPage(
                                                          1,
                                                          duration: Duration(
                                                              milliseconds:
                                                                  1500),
                                                          curve: Curves.easeIn,
                                                        );
                                                      },
                                                      onConnexionError:
                                                          (error) {
                                                        MySnakBar()
                                                            .showSnackBarStyle2(
                                                          context,
                                                          alerteetat: ALERTEETAT
                                                              .AVERTISSEMENT,
                                                          message: "$error",
                                                        );
                                                        Future.delayed(
                                                            Duration(
                                                                milliseconds:
                                                                    1500), () {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .clearSnackBars();
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Formulaire(
                                                        contextFormulaire: ctx,
                                                        successCallBack: () {
                                                          setState(() {
                                                            Navigator.pop(ctx);
                                                            var users = Users();
                                                            Fonctions()
                                                                .showWidgetAsDialog(
                                                              context: context,
                                                              widget: StatefulBuilder(
                                                                  builder: (cotx,
                                                                      setState) {
                                                                return Container(
                                                                  width: 500,
                                                                  child: Column(
                                                                    children: <Widget>[
                                                                      MyTextInputWidget(
                                                                        title:
                                                                            "Votre nom",
                                                                        onChanged:
                                                                            (value) {
                                                                          users.nom =
                                                                              value;
                                                                        },
                                                                      ),
                                                                      MyTextInputWidget(
                                                                        title:
                                                                            "Votre mail",
                                                                        onChanged:
                                                                            (value) {
                                                                          users.mail =
                                                                              value;
                                                                        },
                                                                      ),
                                                                      MyTextInputWidget(
                                                                        title:
                                                                            "Votre téléphone",
                                                                        onChanged:
                                                                            (value) {
                                                                          users.telephone =
                                                                              value;
                                                                        },
                                                                      ),
                                                                      Row(
                                                                        children: <Widget>[
                                                                          Expanded(
                                                                            child:
                                                                                MyButtonWidget(
                                                                              text: "Valider",
                                                                              action: () {
                                                                                Navigator.pop(cotx);
                                                                                callVote(
                                                                                  id_campagne: widget.votecampagne.id,
                                                                                  id_candidat: list[index].id,
                                                                                  nom_users: users.nom,
                                                                                  mail_users: users.mail,
                                                                                  telephone_users: users.telephone,
                                                                                );
                                                                              },
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              }),
                                                              title: "",
                                                            );
                                                          });
                                                        }).saveUsersForm(
                                                      paramToShowObject: Users(
                                                        nom: "",
                                                        prenom: "",
                                                        telephone: "",
                                                        mail: "",
                                                      ),
                                                      objectUsers: FirebaseServices
                                                                  .userConnectedFirebase !=
                                                              null
                                                          ? Users(
                                                              id: "${FirebaseServices.userConnectedFirebase!.uid}",
                                                              nom:
                                                                  "${FirebaseServices.userConnectedFirebase!.displayName != null ? FirebaseServices.userConnectedFirebase!.displayName!.isNotEmpty ? FirebaseServices.userConnectedFirebase!.displayName!.split(" ").first : "" : ""}",
                                                              prenom:
                                                                  "${FirebaseServices.userConnectedFirebase!.displayName != null ? FirebaseServices.userConnectedFirebase!.displayName!.isNotEmpty ? FirebaseServices.userConnectedFirebase!.displayName!.split(" ").sublist(1).join() : "" : ""}",
                                                              mail: FirebaseServices
                                                                      .userConnectedFirebase!
                                                                      .email ??
                                                                  '',
                                                              telephone: FirebaseServices
                                                                      .userConnectedFirebase!
                                                                      .phoneNumber ??
                                                                  '',
                                                            )
                                                          : null,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          }),
                                          title: "",
                                        );
                                      } else if (widget.votecampagne
                                                  .require_votant_nom ==
                                              "1" ||
                                          widget.votecampagne
                                                  .require_votant_mail ==
                                              "1" ||
                                          widget.votecampagne
                                                  .require_votant_telephone ==
                                              "1") {
                                        var users = Users();
                                        Fonctions().showWidgetAsDialog(
                                          context: context,
                                          widget: StatefulBuilder(
                                              builder: (ctx, setState) {
                                            return Container(
                                              width: 500,
                                              child: Column(
                                                children: <Widget>[
                                                  MyTextInputWidget(
                                                    title: "Votre nom",
                                                    onChanged: (value) {
                                                      users.nom = value;
                                                    },
                                                  ),
                                                  MyTextInputWidget(
                                                    title: "Votre mail",
                                                    onChanged: (value) {
                                                      users.mail = value;
                                                    },
                                                  ),
                                                  MyTextInputWidget(
                                                    title: "Votre téléphone",
                                                    onChanged: (value) {
                                                      users.telephone = value;
                                                    },
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: MyButtonWidget(
                                                          text: "Valider",
                                                          action: () {
                                                            Navigator.pop(ctx);
                                                            callVote(
                                                              id_campagne: widget
                                                                  .votecampagne
                                                                  .id,
                                                              id_candidat:
                                                                  list[index]
                                                                      .id,
                                                              nom_users:
                                                                  users.nom,
                                                              mail_users:
                                                                  users.mail,
                                                              telephone_users:
                                                                  users
                                                                      .telephone,
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          }),
                                          title: "",
                                        );
                                      }

                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
