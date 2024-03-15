import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyTextInputWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/objet/Entreprise.dart';
import 'package:core/objet/Users.dart';
import 'package:flutter/material.dart';

class VerificationFacturePage extends StatefulWidget {
  final Color? backColor;
  final Entreprise? entreprise;
  final BuildContext? homeContext;
  final Users? userConnected;

  VerificationFacturePage({Key? key, this.homeContext, this.userConnected, this.backColor, this.entreprise})
      : super(key: key);

  @override
  State<VerificationFacturePage> createState() => _VerificationFacturePageState();
}

class _VerificationFacturePageState extends State<VerificationFacturePage> {
  TextEditingController numeroFactureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backColor,
      body: Container(
        padding: EdgeInsets.all(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: RichText(
                  text: TextSpan(text: "VERIFIER ", style: Styles().getDefaultTextStyle(fontSize: 17), children: [
                    TextSpan(
                      text: "FACTURE",
                      style: Styles().getDefaultTextStyle(
                          fontSize: 17, color: ConstantColor.accentColor, fontWeight: FontWeight.w500),
                    )
                  ]),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: MyTextWidget(
                  text: "Scanner le code de la commande",
                  theme: BASE_TEXT_THEME.BODY_SMALL,
                ),
              ),
              SizedBox(
                height: 60,
                width: !Fonctions().isSmallScreen(context)
                    ? Fonctions().isMediumScreen(context)
                        ? MediaQuery.of(context).size.width * 0.38
                        : MediaQuery.of(context).size.width * 0.28
                    : double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: MyTextInputWidget(
                        textController: numeroFactureController,
                        isNumeric: true,
                        hint: "Numéro de la commande",
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        radius: 90,
                        border: Border.all(
                            width: 1.0, color: ConstantColor.grisColor, strokeAlign: BorderSide.strokeAlignOutside),
                      ),
                    ),
                    Expanded(
                      child: MyButtonWidget(
                        text: "Vérifier",
                        rounded: true,
                        showShadow: false,
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        //load: isSend,
                        action: () async {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
