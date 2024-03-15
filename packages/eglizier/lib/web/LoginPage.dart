// ignore_for_file: non_constant_identifier_names

import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/assets_link.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyLoginWidget.dart';
import 'package:core/formulaires.dart';
import 'package:core/objet/Users.dart';
import 'package:core/preferences.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function(BuildContext context)? onConnexionSuccess;
  final void Function()? onConnexionIgnored;
  final bool? onlyForm;
  final bool? canIgnore;
  final String image_header_link;
  final double image_header_size, paddingContainerGlobal;
  const LoginPage({
    Key? key,
    this.onConnexionSuccess,
    this.onConnexionIgnored,
    this.onlyForm,
    this.canIgnore,
    this.image_header_link = "assets/images/globe_reseau.png",
    this.image_header_size = 200,
    this.paddingContainerGlobal = 12.0,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(widget.paddingContainerGlobal),
            constraints: BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (widget.onlyForm == false)
                  Expanded(
                    flex: 4,
                    child: MyImageModel(
                      urlImage: widget.image_header_link,
                      size: widget.image_header_size,
                    ),
                  ),
                MyLoginWidget(
                  boutonShadow: false,
                  canShowEmailPassword: false,
                  onConnexionError: (value) {
                    print("$value");
                    Fonctions().showErrorAsWidget(
                      assetPath: AssetsLink.imagesError,
                      contextError: context,
                      message: "$value",
                    );
                  },
                  onUsersExist: (value) {
                    widget.onConnexionSuccess!(context);
                  },
                  onUsersNonExist: (userFirebase) {
                    Fonctions().openPageToGo(
                      contextPage: context,
                      pageToGo: FormulairesPage(
                        child: (ctt) {
                          return Container(
                            alignment: Alignment.center,
                            child: Formulaire(
                              contextFormulaire: ctt,
                              successCallBack: () async {
                                final user = await Preferences(skipLocal: true)
                                    .getUsersListFromLocal(id: "${userFirebase!.uid}");
                                if (user.isNotEmpty) {
                                  widget.onConnexionSuccess!(context);
                                }

                                setState(() {});
                              },
                            ).saveUsersForm(
                              paramToShowObject: Users(
                                nom: "",
                                prenom: "",
                                telephone: "",
                                mail: "",
                              ),
                              objectUsers: Users(
                                id: "${userFirebase!.uid}",
                                nom:
                                    "${userFirebase.displayName != null ? userFirebase.displayName!.isNotEmpty ? userFirebase.displayName!.split(" ").first : "" : ""}",
                                prenom:
                                    "${userFirebase.displayName != null ? userFirebase.displayName!.isNotEmpty ? userFirebase.displayName!.split(" ").sublist(1).join() : "" : ""}",
                                mail: userFirebase.email ?? '',
                                telephone: userFirebase.phoneNumber ?? '',
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormulairesPage extends StatefulWidget {
  final Color? backgroundColor;
  final Widget Function(BuildContext context) child;

  const FormulairesPage({Key? key, required this.child, this.backgroundColor}) : super(key: key);

  @override
  State<FormulairesPage> createState() => _FormulairesPageState();
}

class _FormulairesPageState extends State<FormulairesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 520),
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: SingleChildScrollView(
              child: widget.child(context),
            ),
          ),
        ),
      ),
    );
  }
}
