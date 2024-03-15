import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/formulaires.dart';
import 'package:core/objet/ProduitBank.dart';
import 'package:flash_note/RateProduitBankPage.dart';
import 'package:flutter/material.dart';

class SaveProduitBankPage extends StatefulWidget {
  ProduitBank? produitBank;
  SaveProduitBankPage({Key? key, this.produitBank}) : super(key: key);

  @override
  State<SaveProduitBankPage> createState() => _SaveProduitPageState();
}

class _SaveProduitPageState extends State<SaveProduitBankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            color: ConstantColor.lightColor,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                ),
                MyTextWidget(
                  text: "Ajouter",
                  theme: BASE_TEXT_THEME.DISPLAY,
                  textColor: Colors.black,
                ),
                MyTextWidget(
                  text: "Le produitBank que tu a scanné n'est pas encore disponible. Ajoute-le.",
                  textColor: Colors.black,
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Formulaire(
                  contextFormulaire: context,
                  mayPopNavigatorOnSuccess: false,
                  successCallBack: () {
                    print("Success callback");
                    /*  Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => RateProduitBankPage(produitBank: widget.produitBank!)));
                 */
                    Fonctions().openPageToGo(
                        contextPage: context,
                        pageToGo: RateProduitBankPage(produitBank: ProduitBank(code: "${widget.produitBank!.code}")),
                        replacePage: true);
                  }).saveProduitBankForm(objectProduitBank: widget.produitBank),
            ),
          ),
        ],
      ),
    ));
  }
}
