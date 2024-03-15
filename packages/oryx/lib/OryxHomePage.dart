import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:oryx/OryxListPage.dart';

class OryxHomePage extends StatefulWidget {
  const OryxHomePage({Key? key}) : super(key: key);

  @override
  State<OryxHomePage> createState() => _OryxHomePageState();
}

class _OryxHomePageState extends State<OryxHomePage> {
  ThemeData theme = ThemeData();
  double tailleImage = 200;
  @override
  void initState() {
    // TODO: implement initState
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
            color: ConstantColor.lightColor.withOpacity(0.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(), Container(padding: EdgeInsets.all(24), child: _blocColone1()),

                      _blocColone2(),
                      Spacer(),
                      //_appPresentationBloc(),
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

  Widget _blocColone1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            Expanded(
              child: MyImageModel(
                width: tailleImage,
                height: tailleImage,
                urlImage: 'assets/images/logo_oryx_energies.png',
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
                margin: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: MyTextWidget(
                  text:
                      "Achetez le Gaz Oryx au prix le plus juste auprès du distributeur agréé le plus proche ou dans nos stations services.",
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButtonWidget(
                    text: "Points de vente",
                    iconData: Icons.location_on_outlined,
                    iconColor: Colors.white,
                    backColor: ConstantColor.blackMalt,
                    action: () {
                      Fonctions().openPageToGo(
                        contextPage: context,
                        pageToGo: OryxListPage(
                          showByProximity: true,
                          id_sous_categorie: "scat_points_de_vente_oryx",
                          title: "Point de vente Oryx",
                        ),
                      );
                    },
                  ),
                  MyButtonWidget(
                    text: "Stations",
                    iconData: Icons.location_on_outlined,
                    iconColor: Colors.white,
                    backColor: ConstantColor.accentColor,
                    action: () {
                      Fonctions().openPageToGo(
                        contextPage: context,
                        pageToGo: OryxListPage(
                          id_sous_categorie: "scat_points_de_vente_oryx",
                          title: "Stations",
                          theme: "Station",
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
