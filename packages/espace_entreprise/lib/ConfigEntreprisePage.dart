import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/constant.dart';
import 'package:core/common_folder/constantes/enums.dart';
import 'package:core/common_folder/widgets/MyBlocCardWidget.dart';
import 'package:core/common_folder/widgets/MyCheckboxWidget.dart';
import 'package:core/objet/Entreprise.dart';
import 'package:flutter/material.dart';

class ConfigEntreprisePage extends StatefulWidget {
  Entreprise entreprise;
  ConfigEntreprisePage({Key? key, required this.entreprise}) : super(key: key);

  @override
  State<ConfigEntreprisePage> createState() => _ConfigEntreprisePageState();
}

class _ConfigEntreprisePageState extends State<ConfigEntreprisePage> {
  String ongletsProprietaireEntreprise = "";
  String ongletsPublicEntreprise = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ongletsProprietaireEntreprise = widget.entreprise.owner_onglets!;
    ongletsPublicEntreprise = widget.entreprise.public_onglets!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Fonctions().defaultAppBar(context: context, titre: "Configuration ${widget.entreprise.nom}"),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                constraints: BoxConstraints(maxWidth: Constantes().limitScreenWidth),
                child: Column(
                  children: [
                    MyBlocCardWidget(
                      title: "Onglets",
                      child: ListView(
                        padding: EdgeInsets.symmetric(),
                        primary: false,
                        shrinkWrap: true,
                        children: OngletsEntreprise.values.map((e) {
                          bool checked = ongletsProprietaireEntreprise.contains(e.name);
                          //print("Value $checked");
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: MyCheckboxWidget(
                              isChecked: checked,
                              // valueCheck: "true",
                              title: e.name.replaceAll("ONGLET_", ""),
                              switchChecked: (value) {
                                setState(() {
                                  if (!checked) {
                                    ongletsProprietaireEntreprise = "$ongletsProprietaireEntreprise|${e.name}|";
                                    print("not contains $ongletsProprietaireEntreprise");
                                  } else {
                                    ongletsProprietaireEntreprise =
                                        ongletsProprietaireEntreprise.replaceAll("|${e.name}|", "");
                                    print(" contains $ongletsProprietaireEntreprise");
                                  }
                                  checked = !checked;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                )),
          ],
        ));
  }
}
