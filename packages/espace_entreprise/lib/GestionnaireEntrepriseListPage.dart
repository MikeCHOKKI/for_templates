import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/objet/Users.dart';
import 'package:core/pages/objet_list/GestionnaireEntrepriseListWidget.dart';
import 'package:flutter/material.dart';

class GestionnaireEntrepriseListPage extends StatefulWidget {
  final Color? backColor;
  final String? idEntreprise;
  final BuildContext? homeContext;
  final Users? userConnected;

  GestionnaireEntrepriseListPage({Key? key, this.backColor, this.idEntreprise, this.userConnected, this.homeContext})
      : super(key: key);

  @override
  State<GestionnaireEntrepriseListPage> createState() => _GestionnaireEntrepriseListPageState();
}

class _GestionnaireEntrepriseListPageState extends State<GestionnaireEntrepriseListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Fonctions().defaultAppBar(
          context: context,
          titre: "Gestionnaires",
          iconColor: ConstantColor.accentColor,
          titreColor: ConstantColor.accentColor,
          isNotRoot: true,
          elevation: 0.0,
          backgroundColor: Fonctions().isSmallScreen(context) ? Colors.white : ConstantColor.transparentColor),
      body: Container(
        padding: EdgeInsets.all(12),
        child: GestionnaireEntrepriseListWidget(
          canAddItem: true,
          //idEntreprise: widget.idEntreprise,
          showAsGrid: Fonctions().isSmallScreen(context),
          showItemAsCard: Fonctions().isSmallScreen(context),
          backColor: Fonctions().isLargeScreen(context) ? Colors.white : null,
        ),
      ),
    );
  }
}
