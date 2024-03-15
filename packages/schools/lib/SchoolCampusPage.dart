import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/objet/CategorieEntreprise.dart';
import 'package:core/objet/SousCategorieEntreprise.dart';
import 'package:core/pages/objet_list/SousCategorieEntrepriseListWidget.dart';
import 'package:core/pages/widget/VueSousCategorieEntreprise.dart';
import 'package:flutter/material.dart';
import 'package:schools/SchoolListPage.dart';

class SchoolCampusPage extends StatefulWidget {
  const SchoolCampusPage({Key? key}) : super(key: key);

  @override
  State<SchoolCampusPage> createState() => _SchoolCampusPageState();
}

class _SchoolCampusPageState extends State<SchoolCampusPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/abstract_cover.jpg",
                  ),
                  fit: BoxFit.cover)),
          child: Container(
            color: Colors.white.withOpacity(Fonctions().isSmallScreen(context) ? 0.1 : 0.8),
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                MyButtonWidget(
                  iconData: Icons.keyboard_arrow_left,
                  rounded: true,
                  backColor: ConstantColor.accentColor,
                  iconColor: Colors.white,
                  action: () {
                    Navigator.pop(context);
                  },
                ),
                MyTextWidget(
                  text: "Campus",
                  theme: BASE_TEXT_THEME.TITLE,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: MyTextWidget(
                    text: "Choisis un campus et découvre les\nEcoles disponibles.",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        constraints: BoxConstraints(maxWidth: 800),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: SousCategorieEntrepriseListWidget(
                            backColor: Colors.transparent,
                            selectedCategorie: CategorieEntreprise(id: "cat_education", nom: "Education"),
                            showAsGrid: true,
                            buildCustomItemView: (sousCategorie) {
                              return VueSousCategorieEntreprise(
                                souscategorieentreprise: sousCategorie,
                                customView: vueCategorie(sousCategorieEntreprise: sousCategorie),
                                onPressed: (sousCategorie) {
                                  Fonctions().openPageToGo(
                                    contextPage: context,
                                    pageToGo: SchoolListPage(
                                      selectedCategorie: sousCategorie,
                                    ),
                                  );
                                },
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget vueCategorie(
      {required SousCategorieEntreprise sousCategorieEntreprise,
      Color? backColor = Colors.black,
      Color? textColor = Colors.black}) {
    return Container(
      margin: EdgeInsets.all(4),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        shape: BoxShape.rectangle,
        image: DecorationImage(
            image: NetworkImage(
                "https://${ConstantUrl.urlServer}${ConstantUrl.base}${sousCategorieEntreprise!.img_logo_link ?? 'assets/images/logo_defaut.png'}")),
      ),
      child: MyCardWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: MyTextWidget(
                text: "${sousCategorieEntreprise.nom!.trim()}",
                textColor: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
