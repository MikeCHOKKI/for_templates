import 'package:barcode_widget/barcode_widget.dart';
import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/constant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyMediaWidget.dart';
import 'package:core/common_folder/widgets/MyStepperWidget.dart';
import 'package:core/common_folder/widgets/MyTextInputWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/formulaires.dart';
import 'package:core/objet/Produit.dart';
import 'package:core/objet/ProduitBank.dart';
import 'package:core/pages/objet_list/MediasListWidget.dart';
import 'package:core/preferences.dart';
import 'package:flutter/material.dart';

class InscriptionProduitPage extends StatefulWidget {
  bool mayShowNext, mayShowPreview;
  String? idSelectedEntreprise;
  void Function(String? value) reload;

  InscriptionProduitPage(
      {Key? key, this.mayShowNext = false, this.mayShowPreview = true, this.idSelectedEntreprise, required this.reload})
      : super(key: key);

  @override
  State<InscriptionProduitPage> createState() => _InscriptionProduitPageState();
}

class _InscriptionProduitPageState extends State<InscriptionProduitPage> {
  late List<ItemStepperClass> stepperPage;
  GlobalKey<FormFieldState> codeKey = GlobalKey<FormFieldState>();
  TextEditingController codeController = TextEditingController();
  List<Produit> listProduit = [];
  List<ProduitBank> listProduitBank = [];
  Produit? produit;
  ProduitBank? produitBank;
  bool mayShowNext = false,
      mayShowPreview = false,
      hideStepper = false,
      hideBtnSansCode = false,
      hideBtnVerifier = true,
      hideBarCodeWidget = true,
      isLoadVerificationproduit = false,
      isLoadVerificationProduit = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String dataCodeBar = "", messageAlert = "", cover = "", extensionCover = "";
  FocusNode focusNode = FocusNode();
  ControlsDetails? stepperControl;
  ScrollController scrollController = ScrollController();

  void verificationproduit({String code = ""}) {
    if (codeKey.currentState!.validate() == false) {
      return;
    } else {
      setState(() {
        produit = null;
        messageAlert = "";
        mayShowNext = false;
        isLoadVerificationproduit = true;
      });
      Preferences(skipLocal: true)
          .getProduitListFromLocal(code: code, min_index: 0)
          .then((value) => {
                setState(() {
                  listProduit.clear();
                  listProduit.addAll(value);
                  if (listProduit.isNotEmpty) {
                    isLoadVerificationproduit = false;
                    hideBtnVerifier = true;
                    mayShowNext = true;
                    produit = listProduit.first;
                    messageAlert =
                        "Ce produitBank existe déjà dans votre boutique! En cliquant sur suivant vous pouvez le modifier.";
                  } else {
                    verificationProduit(code: code);
                  }
                  isLoadVerificationproduit = false;
                })
              })
          .onError((error, stackTrace) => {
                setState(() {
                  isLoadVerificationproduit = false;
                })
              });
    }
  }

  void verificationProduit({String code = ""}) {
    setState(() {
      isLoadVerificationProduit = true;
    });
    Preferences(skipLocal: true)
        .getProduitBankListFromLocal(code: code, min_index: "0")
        .then((value) => {
              setState(() {
                listProduitBank.clear();
                listProduitBank.addAll(value);
                if (listProduitBank.isNotEmpty) {
                  isLoadVerificationProduit = false;
                  produitBank = listProduitBank.first;
                  produit = Produit(
                    nom: produitBank!.nom,
                    code: produitBank!.code,
                    description: produitBank!.decription,
                    packaging: produitBank!.type_paquetage != null
                        ? produitBank!.type_paquetage!.isNotEmpty
                            ? produitBank!.type_paquetage
                            : null
                        : null,
                    rayon_boutique: produitBank!.rayon != null
                        ? produitBank!.rayon!.isNotEmpty
                            ? produitBank!.rayon
                            : null
                        : null,
                  );
                } else {
                  produit = Produit(code: code);
                }
                isLoadVerificationProduit = false;
                hideBtnVerifier = true;
                if (stepperControl != null) stepperControl!.onStepContinue!();
              })
            })
        .onError((error, stackTrace) => {
              setState(() {
                isLoadVerificationProduit = false;
              })
            });
  }

  @override
  void initState() {
    mayShowPreview = widget.mayShowPreview;
    mayShowNext = widget.mayShowNext;
    super.initState();
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (!hideStepper)
            Expanded(
              child: Container(
                color: Colors.white,
                child: MyStepperWidget(
                  customWidget: (control, list) {
                    stepperControl = control;
                    return Row(
                      children: <Widget>[
                        Spacer(),
                        if (!hideBtnVerifier)
                          Expanded(
                            child: MyButtonWidget(
                              text: "Vérifier",
                              rounded: true,
                              loaderColor: Colors.white,
                              margin: EdgeInsets.all(12),
                              load: isLoadVerificationproduit,
                              action: () async {
                                verificationproduit(code: codeController.text.trim());
                              },
                            ),
                          ),
                        if (mayShowNext || (control.currentStep == list.length - 1))
                          Expanded(
                            child: MyButtonWidget(
                              rounded: true,
                              text: control.currentStep == list.length - 1 ? "Terminer" : "Suivant",
                              backColor: Theme.of(context).primaryColor,
                              action: () {
                                if (control.currentStep == list.length - 1) {
                                  Navigator.pop(context);
                                  widget.reload("");
                                } else {
                                  if (stepperControl != null) stepperControl!.onStepContinue!();
                                  setState(() {
                                    messageAlert = "";
                                    mayShowNext = false;
                                  });
                                }
                              },
                            ),
                          )
                      ],
                    );
                  },
                  widgetStepper: [
                    ItemStepperClass(
                      index: 0,
                      name: "Vérification",
                      page: Container(
                        constraints: BoxConstraints(maxWidth: 500),
                        child: Column(
                          children: [
                            MyTextWidget(
                                text:
                                    "Vous pouvez vérifer un produitBank par son code bar ou continuer sans le faire."),
                            MyTextInputWidget(
                              backColor: Colors.transparent,
                              border: Border.all(color: Colors.black, width: 0.3),
                              padding: EdgeInsets.symmetric(vertical: 0),
                              validationKey: codeKey,
                              textController: codeController,
                              focusNode: focusNode,
                              isRequired: true,
                              hintLabel: "code du produitBank",
                              onChanged: (value) {
                                hideBtnSansCode = value.isNotEmpty ? true : false;
                                hideBtnVerifier = hideBtnSansCode ? false : true;
                                if (value.length > 0) {
                                  dataCodeBar = value;
                                  hideBarCodeWidget = false;
                                } else {
                                  hideBarCodeWidget = true;
                                }
                                setState(() {});
                              },
                              rightWidget: MyButtonWidget(
                                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                                iconData: Icons.camera_alt_sharp,
                                iconColor: Colors.black,
                                backColor: ConstantColor.lightColor,
                                action: () async {
                                  Fonctions().showWidgetAsDialog(
                                      context: context,
                                      widget: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                MyTextWidget(text: "QrCode", theme: BASE_TEXT_THEME.LABEL_MEDIUM),
                                                Container(
                                                  child: MyTextWidget(
                                                    text: "Scanner",
                                                    theme: BASE_TEXT_THEME.LABEL_MEDIUM,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(vertical: 16),
                                              child: MyTextWidget(
                                                text: "Scannez un qr code du produitBank que vous voulez ajouter",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Fonctions().showQrView(
                                                qrKey: qrKey,
                                                getQrcode: (value, controller) {
                                                  setState(() {
                                                    codeController.text = value;
                                                    Navigator.pop(context);
                                                    controller.stopCamera();
                                                  });
                                                })
                                          ],
                                        ),
                                      ),
                                      title: "");
                                },
                              ),
                            ),
                            if (!hideBarCodeWidget)
                              Container(
                                height: 125,
                                padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: BarcodeWidget(
                                        barcode: Barcode.code128(),
                                        data: dataCodeBar,
                                        errorBuilder: (context, error) {
                                          if (error.contains("BarcodeException")) {
                                            error = "Assurez-vous d'avoir votre clavier en majuscule et réessayer.";
                                          }
                                          return Center(
                                            child: MyTextWidget(text: error, textColor: ConstantColor.redErrorColor),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Row(
                              children: <Widget>[
                                Spacer(),
                                if (!hideBtnSansCode)
                                  MyButtonWidget(
                                    text: "Continuer sans le code",
                                    rounded: true,
                                    isOutline: true,
                                    loaderColor: Colors.white,
                                    margin: EdgeInsets.all(12),
                                    action: () async {
                                      setState(() {
                                        //mayShowNext = true;
                                        if (stepperControl != null) stepperControl!.onStepContinue!();
                                      });
                                    },
                                  ),
                              ],
                            ),
                            if (messageAlert.isNotEmpty && mayShowNext)
                              Row(
                                children: [
                                  Expanded(
                                    child: MyCardWidget(
                                      elevation: 0,
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      cardColor: Colors.black.withOpacity(0.1),
                                      child: Center(
                                        child: MyTextWidget(text: messageAlert, textColor: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    ItemStepperClass(
                      index: 1,
                      name: "Détails",
                      page: Container(
                        constraints: BoxConstraints(maxWidth: 500),
                        child: Formulaire(
                            contextFormulaire: context,
                            mayPopNavigatorOnSuccess: false,
                            successCallBack: (valueproduit) {
                              produit = valueproduit;
                              if (stepperControl != null) {
                                stepperControl!.onStepContinue!();
                              }
                              //widget.reload("");
                            }).saveProduitForm(
                            idSelectedEntreprise: widget.idSelectedEntreprise,
                            paramToShowObject: Produit(
                              nom: "",
                              description: "",
                              prix: "",
                              qte: "",
                              seuil_bas: "",
                              code_taxe: "",
                              prix_achat_unitaire: "",
                              date_acquisition: "",
                              date_expiration: "",
                              date_enregistrement: "",
                              packaging: "",
                              rayon_boutique: "",
                              buy_link: "",
                            ),
                            objectProduit: produit),
                      ),
                    ),
                    ItemStepperClass(
                      index: 2,
                      name: "Médias",
                      page: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: MyMediaWidget(
                                    key: ValueKey<String>("${produit != null ? produit!.img_cover_link : ''}"),
                                    urlImage: produit != null
                                        ? produit!.img_cover_link != null
                                            ? produit!.img_cover_link
                                            : ""
                                        : "",
                                    height: 250,
                                    backgroundColor: ConstantColor.grisColor,
                                    fit: BoxFit.cover,
                                    imageQuality: 20,
                                    backgroundRadius: 12.0,
                                    radius: 12,
                                    showButtonToSend: true,
                                    getBase64: (base64) {
                                      setState(() {
                                        cover = base64;
                                      });
                                    },
                                    getExtension: (valueExtension) {
                                      setState(() {
                                        extensionCover = valueExtension;
                                      });
                                    },
                                    objectToSend: produit,
                                    additionalArgument: {"action": "SAVE", "cover": cover},
                                    urlToSend: ConstantUrl.ProduitUrl,
                                    /*onSuccessImageSend: () {
                                        setState(() {

                                        });
                                      },*/
                                    isFile: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            height: 200,
                            child: Scrollbar(
                              controller: scrollController,
                              thickness: 10,
                              child: MediasListWidget(
                                key: ValueKey<String>("$produit"),
                                isEspaceEntreprise: true,
                                id_user: produit != null ? produit!.id_users : "",
                                id_cible: produit != null ? produit!.id : "",
                                cible: Constantes().constCibleMediaProduit,
                                scrollController: scrollController,
                                backColor: Colors.white,
                                onItemPressed: (value) {
                                  setState(() {
                                    if (value.lien_fichier != null) {
                                      if (value.lien_fichier!.isNotEmpty) {
                                        Fonctions().showMediaLargeDialog(context: context, imageLinkList: [
                                          "https://${ConstantUrl.urlServer}${ConstantUrl.base}${value.lien_fichier!}"
                                        ]);
                                      }
                                    }
                                  });
                                },
                                showAsGrid: true,
                                mayScrollHorizontaly: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  showNextButton: mayShowNext,
                  showPreviousButton: mayShowPreview,
                  onChangedShowButton: (ControlsDetails control, bool value) {
                    setState(() {
                      if (value == true) {
                        control.onStepContinue!();
                        mayShowNext = false;
                      } else {
                        Navigator.pop(context);
                        // widget.reload(produit!.id);
                      }
                    });
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
