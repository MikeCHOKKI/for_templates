import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:flash_note/ScanProduitBankPage.dart';
import 'package:flutter/material.dart';

class FlashNoteHome extends StatefulWidget {
  const FlashNoteHome({Key? key}) : super(key: key);

  @override
  State<FlashNoteHome> createState() => _FlashNoteHomeState();
}

class _FlashNoteHomeState extends State<FlashNoteHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColor.lightColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                foregroundDecoration: BoxDecoration(
                  color: Colors.grey,
                  backgroundBlendMode: BlendMode.saturation,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: MyImageModel(
                        width: 10000,
                        height: 10000,
                        urlImage: "assets/images/flash_note_home.jpg",
                      ),
                    ),
                  ],
                ),
              ),
            ),

            MyTextWidget(
              text: "FlashNote",
              theme: BASE_TEXT_THEME.DISPLAY,
              textColor: Colors.black,
            ),
            MyTextWidget(
              text:
                  "Partage ton avis avis sur les produits utilisés au quotidien et devient membre d'une communauté de recommandation de produit.",
              textColor: Colors.black,
              textAlign: TextAlign.center,
            ),
            MyButtonWidget(
              text: "Scanner un produit",
              //rounded: false,
              //backColor: Theme.of(context).primaryColor,
              action: () {
                Fonctions().openPageToGo(contextPage: context, pageToGo: ScanProduitBankPage());
              },
            ),
            Spacer()
            // Expanded(child: RatingsListWidget())
          ],
        ),
      ),
    );
  }
}
