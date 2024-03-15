import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyResponsiveWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:immo/ImmoListPage.dart';

class ImmoHomePage extends StatefulWidget {
  const ImmoHomePage({Key? key}) : super(key: key);

  @override
  State<ImmoHomePage> createState() => _ImmoHomePageState();
}

class _ImmoHomePageState extends State<ImmoHomePage> {
  ThemeData theme = ThemeData();
  double tailleImage = 200;

  @override
  void initState() {
    super.initState();
  }

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
                            urlImage: "assets/images/ic_buzup.png",
                          ),
                          MyTextWidget(
                            text: "Buz'Up Hotel",
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
    ));
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
                urlImage: 'assets/images/immo_home.png',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: MyTextWidget(
                  text: "Locations Proches",
                  theme: BASE_TEXT_THEME.DISPLAY,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: MyTextWidget(
                  text: "Achetez et louez des maisons partout au Bénin",
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButtonWidget(
                    text: "Tous",
                    iconData: Icons.all_inclusive_outlined,
                    iconColor: Colors.white,
                    backColor: ConstantColor.blackMalt,
                    action: () {
                      Fonctions().openPageToGo(
                        contextPage: context,
                        pageToGo: ImmoListPage(
                          id_sous_categorie: "scat_immo",
                        ),
                      );
                    },
                  ),
                  MyButtonWidget(
                    text: "Proches",
                    iconData: Icons.location_on_outlined,
                    iconColor: Colors.white,
                    backColor: Theme.of(context).primaryColor,
                    action: () {
                      Fonctions().openPageToGo(
                        contextPage: context,
                        pageToGo: ImmoListPage(
                          showByProximity: true,
                          id_sous_categorie: "scat_immo",
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
