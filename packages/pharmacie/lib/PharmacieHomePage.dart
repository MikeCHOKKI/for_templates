import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/enums.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyResponsiveWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:pharmacie/PharmacieListPage.dart';

class PharmacieHomePage extends StatefulWidget {
  const PharmacieHomePage({Key? key}) : super(key: key);

  @override
  State<PharmacieHomePage> createState() => _PharmacieHomePageState();
}

class _PharmacieHomePageState extends State<PharmacieHomePage> {
  double tailleImage = 200;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tailleImage = Fonctions().isLargeScreen(context) ? 400 : 200;

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/pharma_cover.jpg",
                  ),
                  fit: BoxFit.cover)),
          child: Container(
            color: ConstantColor.lightColor.withOpacity(0.85),
            child: MyResponsiveWidget(
              backgroundColor: Colors.transparent,
              smallScreen: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    constraints: BoxConstraints(maxWidth: 500),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Column(
                          children: [
                            MyImageModel(
                              margin: const EdgeInsets.all(8),
                              height: 46,
                              width: 46,
                              urlImage: "assets/images/logo_buzup_vert.png",
                            ),
                            MyTextWidget(
                              text: "Buz'Up Pharma",
                              theme: BASE_TEXT_THEME.TITLE,
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(padding: EdgeInsets.all(24), child: _blocColone1()),

                        _blocColone2(),
                        Spacer(),
                        //_appPresentationBloc(),
                      ],
                    ),
                  ),
                ],
              ),
              largeScreen: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: Row(
                      children: [
                        Expanded(child: Container(child: _blocColone1())),
                        Expanded(child: Container(padding: EdgeInsets.all(24), child: _blocColone2())),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _blocColone1() {
    return Column(
      mainAxisAlignment: Fonctions().isSmallScreen(context) ? MainAxisAlignment.end : MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: MyImageModel(
                width: tailleImage,
                height: tailleImage,
                urlImage: 'assets/images/pharma_home.png',
                fit: BoxFit.contain,
                size: tailleImage,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _blocColone2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 300),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: Fonctions().isSmallScreen(context) ? MainAxisAlignment.center : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: MyTextWidget(
                  text: "Pharmacies Proches",
                  theme: BASE_TEXT_THEME.DISPLAY,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: MyTextWidget(
                  text:
                      "La pharmacie la plus proche de vous est dans Buz'Up. Grâce à Buz'Up, accédez à l'annuaire des pharmacies du Bénin, découvrez leur horaire d'ouverture et obtenez l'ittinéraire le plus court pour vous y rendre.",
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButtonWidget(
                    text: "Toutes",
                    iconData: Icons.all_inclusive_outlined,
                    iconColor: Colors.white,
                    backColor: ConstantColor.blackMalt,
                    action: () {
                      Fonctions().openPageToGo(
                        contextPage: context,
                        pageToGo: PharmacieListPage(id_sous_categorie: SousCategorieEntreprisePincipale.PHARMACIE.id),
                      );
                    },
                  ),
                  MyButtonWidget(
                    text: "Proches",
                    iconData: Icons.location_on_outlined,
                    iconColor: Colors.white,
                    backColor: ConstantColor.colorVertPharma,
                    action: () {
                      print("Id Scat ${SousCategorieEntreprisePincipale.PHARMACIE.id}");
                      Fonctions().openPageToGo(
                        contextPage: context,
                        pageToGo: PharmacieListPage(
                          showByProximity: true,
                          id_sous_categorie: "${SousCategorieEntreprisePincipale.PHARMACIE.id}",
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
