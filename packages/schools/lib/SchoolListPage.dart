import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/objet/SousCategorieEntreprise.dart';
import 'package:core/pages/objet_list/EntrepriseListWidget.dart';
import 'package:core/pages/widget/VueEntreprise.dart';
import 'package:flutter/material.dart';
import 'package:schools/SchoolFiliereListPage.dart';

class SchoolListPage extends StatefulWidget {
  SousCategorieEntreprise? selectedCategorie;

  SchoolListPage({Key? key, this.selectedCategorie}) : super(key: key);

  @override
  State<SchoolListPage> createState() => _SchoolListPageState();
}

class _SchoolListPageState extends State<SchoolListPage> {
  final defautCategorie = SousCategorieEntreprise(id_categorie_entreprise: "cat_education", id: "scat_uac");

  late SousCategorieEntreprise selectedSousCategorie;

  @override
  void initState() {
    // TODO: implement initState
    selectedSousCategorie = widget.selectedCategorie ?? defautCategorie;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ConstantColor.backgroundColor,
        body: Column(
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
              text: "Ecoles",
              theme: BASE_TEXT_THEME.TITLE,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: MyTextWidget(
                text: "Voici les écoles disponibles dans la catégorie\n «${selectedSousCategorie.nom}».",
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Container(
                child: EntrepriseListWidget(
                  themeRecherche: "",
                  sousCategorieEntreprise: selectedSousCategorie,
                  gridMainAxisExtent: 270,
                  gridMaxCrossAxisExtent: 400,
                  padding: Fonctions().isSmallScreen(context)
                      ? EdgeInsets.zero
                      : EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 9),
                  showSearchBar: true,
                  showItemAsCard: true,
                  showCountStack: false,
                  buildCustomItemView: (ecole) {
                    return VueEntreprise(
                      entreprise: ecole,
                      showAsCard: true,
                      customView: Container(
                        margin: EdgeInsets.symmetric(horizontal: Fonctions().isSmallScreen(context) ? 24 : 4),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: MyCardWidget(
                                    margin: EdgeInsets.only(top: 8),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            // height: 200,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                    "assets/images/global_home_back.jpg",
                                                  ),
                                                  fit: BoxFit.cover),
                                            ),
                                            child: Container(
                                              color: Colors.white.withOpacity(0.9),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.only(top: 12),
                                                    width: 80,
                                                    height: 80,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                MyTextWidget(
                                                  text: "${ecole!.nom}",
                                                  theme: BASE_TEXT_THEME.TITLE,
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                MyTextWidget(
                                                  text: "${ecole!.description}",
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 48,
                              right: 8,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: MyImageModel(
                                  size: 48,
                                  urlImage:
                                      "https://${ConstantUrl.urlServer}${ConstantUrl.base}${ecole!.img_logo_link ?? 'assets/images/logo_defaut.png'}",
                                  isRounded: false,
                                  defaultWidget: Icon(
                                    Icons.school,
                                    size: 36,
                                    color: ConstantColor.accentColor,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      onPressed: (ecole) {
                        print("La ecole $ecole");
                        Fonctions().openPageToGo(
                          contextPage: context,
                          pageToGo: SchoolFiliereListPage(
                            ecole: ecole,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
