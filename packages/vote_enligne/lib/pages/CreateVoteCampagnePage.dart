import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/Fonctions/firebase_services.dart';
import 'package:core/formulaires.dart';
import 'package:core/objet/VoteCampagne.dart';
import 'package:core/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:vote_enligne/pages/VotePageHome.dart';

class CreateVoteCampagnePage extends StatefulWidget {
  final VoteCampagne? voteCampagne;
  final Function reloadPage;

  const CreateVoteCampagnePage(
      {Key? key, this.voteCampagne, required this.reloadPage})
      : super(key: key);

  @override
  State<CreateVoteCampagnePage> createState() => _CreateVoteCampagnePageState();
}

class _CreateVoteCampagnePageState extends State<CreateVoteCampagnePage> {
  @override
  Widget build(BuildContext context) {
    return FirebaseServices.userConnectedFirebase != null
        ? SafeArea(
          child: Scaffold(
              body: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        color: Color(0xFF605E87),
                      )),
                  Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Formulaire(
                                      contextFormulaire: context,
                                      successCallBack: () {
                                        widget.reloadPage();
                                      })
                                  .saveVoteCampagneForm(
                                      objectVoteCampagne: widget.voteCampagne)
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
        )
        : SafeArea(
          child: LoginPage(onConnexionSuccess: (context, user) {
              Fonctions().openPageToGo(
                contextPage: context,
                pageToGo: VotePageHome(),
              );
            }),
        );
  }
}
