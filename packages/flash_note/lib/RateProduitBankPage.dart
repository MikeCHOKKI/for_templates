import 'package:barcode_widget/barcode_widget.dart';
import 'package:core/Api.dart';
import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/Fonctions/firebase_services.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyLoadingWidget.dart';
import 'package:core/common_folder/widgets/MyNoDataWidget.dart';
import 'package:core/common_folder/widgets/MyTextInputWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/objet/ProduitBank.dart';
import 'package:core/objet/Ratings.dart';
import 'package:core/objet/Users.dart';
import 'package:core/pages/LoginPage.dart';
import 'package:core/pages/objet_list/RatingsListWidget.dart';
import 'package:core/pages/widget/VueProduitBank.dart';
import 'package:core/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'SaveProduitBankPage.dart';

class RateProduitBankPage extends StatefulWidget {
  ProduitBank produitBank;
  RateProduitBankPage({required this.produitBank});

  @override
  State<RateProduitBankPage> createState() => _RateProduitPageState();
}

class _RateProduitPageState extends State<RateProduitBankPage> {
  bool isLoadingProduitBank = false;
  ProduitBank? scannedProduitBank = null;
  double note = 0;
  bool mayShowRattingArea = true, mayGetComment = false, isSendingComment = false, isCommentSent = false;
  TextEditingController commentaireController = TextEditingController();

  getProduitBank({required String code}) async {
    setState(() {
      isLoadingProduitBank = true;
    });
    List<ProduitBank> produitList = await Preferences(skipLocal: true).getProduitBankListFromLocal(code: code);

    if (produitList.isNotEmpty) {
      scannedProduitBank = produitList.first;
      isLoadingProduitBank = false;
      setState(() {});
    } else {
      Fonctions().openPageToGo(
          contextPage: context, pageToGo: SaveProduitBankPage(produitBank: ProduitBank(code: code)), replacePage: true);
      isLoadingProduitBank = false;
      setState(() {});
    }
  }

  sendComment() async {
    Users? connectedUser = await FirebaseServices().userConnectedInfos;
    if (commentaireController.text.isNotEmpty || note > 0) {
      setState(() {
        isSendingComment = true;
        mayShowRattingArea = false;
      });
      final objectToSend = Ratings(
        code_produit: "${scannedProduitBank!.code}",
        id_rater: "${connectedUser!.id!}",
        note: "$note",
        commentaire: commentaireController.text.trim(),
      );
      Map<String, String> paramsSup = {
        "action": "SAVE",
      };
      await Api.saveObjetApi(
        arguments: objectToSend,
        additionalArgument: paramsSup,
        url: ConstantUrl.RatingsUrl,
      ).then((value) {
        if (value["saved"] == true) {
          setState(() {
            isSendingComment = false;
            isCommentSent = true;
            mayShowRattingArea = false;
            Future.delayed(
                const Duration(seconds: 5),
                () => setState(() {
                      isCommentSent = false;
                    }));
            //Fonctions().openPageToGo(contextPage: context, pageToGo: FlashNoteHome());
          });
        } else {
          setState(() {
            isSendingComment = false;
          });
        }
      });
    } else {
      setState(() {
        isSendingComment = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoadingProduitBank = true;
      getProduitBank(code: widget.produitBank.code!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoadingProduitBank)
            Expanded(
              child: Center(
                child: MyLoadingWidget(
                  message: "Recherche du produit",
                ),
              ),
            ),
          if (!isLoadingProduitBank && scannedProduitBank == null)
            Expanded(
                child: MyNoDataWidget(
              message: "Aucun produit",
              actionText: "Reéssayer",
              action: () {
                getProduitBank(code: widget.produitBank.code!);
              },
            )),
          if (!isLoadingProduitBank && scannedProduitBank != null)
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 36,
                  ),
                  VueProduitBank(
                      produitBank: scannedProduitBank,
                      onPressed: () {},
                      customView: Container(
                        width: 250,
                        child: MyCardWidget(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 36),
                            child: Column(
                              children: [
                                BarcodeWidget(
                                  data: "${scannedProduitBank!.code}",
                                  barcode: Barcode.code128(),
                                  padding: EdgeInsets.only(top: 8),
                                ),
                                MyTextWidget(
                                  text: "${scannedProduitBank!.nom}",
                                  theme: BASE_TEXT_THEME.TITLE,
                                ),
                              ],
                            )),
                      )),
                  Expanded(
                    child: Container(
                      color: ConstantColor.lightColor,
                      child: ListView(
                        children: [
                          if (mayShowRattingArea)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: Column(
                                children: <Widget>[
                                  MyTextWidget(
                                    text: "Quel est ton avis sur ce produit?",
                                    theme: BASE_TEXT_THEME.TITLE_SMALL,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  RatingBar.builder(
                                    initialRating: 0,
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      switch (index) {
                                        case 0:
                                          return Icon(
                                            Icons.sentiment_very_dissatisfied,
                                            color: Colors.red,
                                          );
                                        case 1:
                                          return Icon(
                                            Icons.sentiment_dissatisfied,
                                            color: Colors.redAccent,
                                          );
                                        case 2:
                                          return Icon(
                                            Icons.sentiment_neutral,
                                            color: Colors.amber,
                                          );
                                        case 3:
                                          return Icon(
                                            Icons.sentiment_satisfied,
                                            color: Colors.lightGreen,
                                          );
                                        default:
                                          return Icon(
                                            Icons.sentiment_very_satisfied,
                                            color: Colors.green,
                                          );
                                      }
                                    },
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        note = rating;
                                        mayGetComment = true;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  if (mayGetComment)
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(12.0),
                                          child: MyTextInputWidget(
                                            textController: commentaireController,
                                            hint: "Commentaire",
                                            hintColor: Colors.black,
                                            backColor: Colors.white,
                                            isMultiline: true,
                                            minLines: 5,
                                            maxLines: 5,
                                            maxLength: 200,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            MyButtonWidget(
                                              text: "Envoyer",
                                              load: isSendingComment,
                                              action: () async {
                                                Users? connectedUser = await FirebaseServices().userConnectedInfos;
                                                if (connectedUser == null) {
                                                  Fonctions().openPageToGo(
                                                      contextPage: context,
                                                      pageToGo: LoginPage(onConnexionSuccess: (context, _) async {
                                                        Navigator.pop(context);
                                                        await sendComment();
                                                      }));
                                                  /* Fonctions().showWidgetAsDialog(
                                                    context: context,
                                                    widget: LoginPage(onConnexionSuccess: (context, _) async {
                                                      await sendComment();
                                                    }),
                                                    title: "Connectez-vous");
*/
                                                  return;
                                                } else {
                                                  await sendComment();
                                                }
                                              },
                                            ),
                                            SizedBox(width: 24.0),
                                          ],
                                        ),
                                      ],
                                    ),
                                  Divider(
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            ),
                          if (isSendingComment)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: Column(
                                children: <Widget>[
                                  MyLoadingWidget(
                                    message: "Envoie de votre commentaire en cours.\nVeuillez patienter...",
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Divider(
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            ),
                          if (isCommentSent)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 120,
                                  ),
                                  MyTextWidget(
                                    text: "Merci. Votre commentaire a été pris en compte.",
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Divider(
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            ),
                          Column(
                            children: [
                              MyTextWidget(
                                text: "${mayShowRattingArea ? "Ce que disent les autres" : "Avis sur le produit"}",
                                theme: BASE_TEXT_THEME.TITLE_SMALL,
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Container(
                                  height: 500,
                                  child: RatingsListWidget(
                                    code_produit: scannedProduitBank!.code,
                                    onItemPressed: () {},
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
