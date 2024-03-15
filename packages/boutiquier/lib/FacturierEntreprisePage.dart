import 'dart:async';

import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/enums.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyBlocCardWidget.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyMinimalDisplayInfos.dart';
import 'package:core/common_folder/widgets/MyNoDataWidget.dart';
import 'package:core/common_folder/widgets/MyResponsiveWidget.dart';
import 'package:core/common_folder/widgets/MyTextInputWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/formulaires.dart';
import 'package:core/objet/Achat.dart';
import 'package:core/objet/Client.dart';
import 'package:core/objet/Commande.dart';
import 'package:core/objet/Entreprise.dart';
import 'package:core/objet/PackagingBoutique.dart';
import 'package:core/objet/Produit.dart';
import 'package:core/objet/ProduitBank.dart';
import 'package:core/objet/RayonBoutique.dart';
import 'package:core/objet/Services.dart';
import 'package:core/objet/TaxeBoutique.dart';
import 'package:core/objet/Users.dart';
import 'package:core/pages/objet_list/AchatListWidget.dart';
import 'package:core/pages/objet_list/ProduitListWidget.dart';
import 'package:core/pages/objet_list/ServicesListWidget.dart';
import 'package:core/preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:split_view/split_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'GenerateFactureFile.dart';

class FacturierEntreprisePage extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final bool? showAppBar;
  final Color? backColor;
  Entreprise entreprise;
  final BuildContext? homeContext;
  final Users? userConnected;

  FacturierEntreprisePage({
    Key? key,
    this.backColor,
    this.homeContext,
    this.userConnected,
    required this.entreprise,
    this.appBar,
    this.showAppBar,
  }) : super(key: key);

  @override
  State<FacturierEntreprisePage> createState() => _FacturierEntreprisePageState();
}

class _FacturierEntreprisePageState extends State<FacturierEntreprisePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController qr_Controller = TextEditingController();
  late TabController tabController;
  String? idUserClient;
  List<Achat> achatList = [];

  //List<ProduitBank> listProduit = [];
  List<Produit> produitsBoutiqueList = [];

  List<TaxeBoutique> listTaxeBoutique = [];
  List<RayonBoutique> listRayonBoutique = [];
  List<PackagingBoutique> listPackagingBoutique = [];

  FocusNode focusNode = FocusNode();
  String themeRecherche = "";

  bool isLoadingVerification = false,
      isEnabled = false,
      hideBenefice = true,
      showNomTextInputWidget = false,
      isLoadGetClientWithPhone = false,
      isLoadGetClientWithId = false,
      mayShowSaveFactureSuccesPage = false,
      mayShowProduitSelector = false,
      isSwitchedTypeFacture = false;

  ScrollController scrollController = ScrollController();

  Commande commande = Commande();
  List<double> weightSplitter = [0.65, 0.35];

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void requestStoragePermission() async {
    if (!(await Permission.manageExternalStorage.isGranted)) {
      await Permission.manageExternalStorage.request();
    }
  }

  void getUser({String telephone = "", String id_user = "", BuildContext? contextBuild}) {
    Preferences(skipLocal: true)
        .getUsersListFromLocal(telephone: telephone, id: id_user)
        .then((value) => {
              setState(() {
                if (value.isNotEmpty) {
                  nomController.text = value.single.nom ?? "";
                  idUserClient = value.single.id;
                }
                showNomTextInputWidget = true;
                isLoadGetClientWithPhone = false;
                isLoadGetClientWithId = false;
                if (contextBuild != null) {
                  Navigator.pop(contextBuild);
                }
              })
            })
        .onError((error, stackTrace) => {
              setState(() {
                isLoadGetClientWithPhone = false;
                isLoadGetClientWithId = false;
              })
            });
  }

  void getProduitsBoutique({String? id_entreprise = "", String code = "", String id = ""}) async {
    setState(() {
      searchController.text = "";
    });
    /*listRayonBoutique = await Preferences(skipLocal: true)
        .getRayonBoutiqueListFromLocal(id_entreprise: id_entreprise);
    listPackagingBoutique = await Preferences(skipLocal: true)
        .getPackagingBoutiqueListFromLocal(id_entreprise: id_entreprise);*/
    Preferences(skipLocal: true)
        .getProduitListFromLocal(id_entreprise: id_entreprise, code: code, id: id)
        .then((value) => {
              setState(() {
                focusNode.requestFocus();
                produitsBoutiqueList.clear();
                produitsBoutiqueList.addAll(value);
                if ((code.isNotEmpty || id.isNotEmpty) && produitsBoutiqueList.isNotEmpty) {
                  addProduitToAchatList(produit: produitsBoutiqueList.first);
                  isLoadingVerification = false;
                }
                if (produitsBoutiqueList.isEmpty && code.isNotEmpty) {
                  checkProduitInBank(code: code);
                }
              })
            })
        .onError((error, stackTrace) => {
              setState(() {
                isLoadingVerification = false;
              })
            });
  }

  void checkProduitInBank({String code = ""}) {
    Preferences(skipLocal: true)
        .getProduitBankListFromLocal(code: code, min_index: "0")
        .then((value) => {
              setState(() {
                // if (value.isNotEmpty) {
                final produitBank = value.isNotEmpty ? value.first : ProduitBank(code: code);
                final produit = Produit(
                  nom: produitBank.nom,
                  code: produitBank.code,
                  description: produitBank.decription,
                  packaging: produitBank.type_paquetage,
                  rayon_boutique: produitBank.rayon,
                );
                Fonctions().showWidgetAsDialog(
                    context: context,
                    widget: Formulaire(
                        contextFormulaire: context,
                        successCallBack: (valueId) {
                          getProduitsBoutique(id: valueId);
                          //setState(() {});
                        }).saveProduitForm(
                      idSelectedEntreprise: widget.entreprise.id,
                      isInFacturier: true,
                      objectProduit: produit,
                      paramToShowObject: Produit(
                        nom: "",
                        prix: "",
                        qte: "",
                        code_taxe: "",
                        prix_achat_unitaire: "",
                        packaging: "",
                        rayon_boutique: "",
                      ),
                    ),
                    title: "Ajout produit");

                isLoadingVerification = false;
              })
            })
        .onError((error, stackTrace) => {
              setState(() {
                isLoadingVerification = false;
              })
            });
  }

  double getTauxTaxe({String? code_taxe = ""}) {
    TaxeBoutique? taxe = listTaxeBoutique.length > 0
        ? listTaxeBoutique.firstWhere((element) => element.code_taxe == code_taxe, orElse: () => TaxeBoutique())
        : TaxeBoutique();
    return double.tryParse(taxe!.taux ?? "0") ?? 0;
  }

  void openproduitListWidgetInAlertDialog() {
    setState(() {});
    //int i = 0;
    Fonctions().showWidgetAsDialog(
      context: context,
      title: "Sélectionnez les produits achetés",
      key: ValueKey<String>(achatList.toString()),
      widget: Container(
        width: 500,
        height: 500,
        constraints: BoxConstraints(maxWidth: 500),
        child: _blocTabBar(),
      ),
    );
  }

  Future addProduitToAchatList({Produit? produit, Services? service}) async {
    int indexProduitInAchatList = 0;
    if (produit != null) {
      indexProduitInAchatList =
          achatList.indexWhere((element) => element.produit != null ? element.produit!.id == produit.id : false);
    } else {
      indexProduitInAchatList =
          achatList.indexWhere((element) => element.service != null ? element.service!.id == service!.id : false);
    }

    Achat? achat;
    if (indexProduitInAchatList != -1) {
      if (produit != null) {
        achat = achatList.singleWhere((element) => element.produit != null ? element.produit!.id == produit.id : false);
      } else {
        achat =
            achatList.singleWhere((element) => element.service != null ? element.service!.id == service!.id : false);
      }
      int qteProduit = int.tryParse(achat.qte_total ?? "0") ?? 0;
      achat = achat.copyWith(qte_total: "${qteProduit + 1}");
    } else {
      if (produit != null) {
        achat = Achat(produit: produit, qte_total: "1");
      } else {
        achat = Achat(service: service, qte_total: "1");
      }
    }

    double prixUnitaireProduit = 0;
    if (produit != null) {
      achat.id_produit = achat.produit!.id;
      prixUnitaireProduit = double.tryParse("${achat.produit!.prix}") ?? 0;
    } else {
      achat.id_service = achat.service!.id;
      prixUnitaireProduit = double.tryParse("${achat.service!.cout}") ?? 0;
    }
    achat.prix_total = (prixUnitaireProduit * (double.tryParse("${achat.qte_total}") ?? 0)).toString();
    if (indexProduitInAchatList != -1) {
      achatList.removeAt(indexProduitInAchatList);
      achatList.insert(indexProduitInAchatList, achat);
    } else {
      achatList.add(achat);
    }

    setState(() {});

    calculer();
  }

  void modifyAchat({required Achat achat}) async {
    final modifiedProduit = await Fonctions().showWidgetAsDialog(
      context: context,
      title: "Modification",
      widget: Formulaire(contextFormulaire: context)
          .saveAchatForm(edit: "qte", listTaxe: listTaxeBoutique, objectAchat: achat),
    );
    int indexProduit = achatList.indexOf(achat);
    achatList.remove(achat);
    achatList.insert(indexProduit, modifiedProduit);
    calculer();
  }

  void deleteAchat({required Achat achat}) {
    achatList.remove(achat);
    calculer();
  }

  void calculer() {
    double totalHt = 0;
    double totalTaxe = 0;
    achatList.forEach((achat) {
      double prixProduit = 0;
      if (achat.produit != null) {
        prixProduit = double.tryParse(achat.produit!.prix ?? "0") ?? 0;
      } else {
        prixProduit = double.tryParse(achat.service!.cout ?? "0") ?? 0;
      }
      double qteProduit = double.tryParse(achat!.qte_total ?? "0") ?? 0;
      double totalTaxeProduit = 0;
      if (achat.produit != null) {
        totalTaxeProduit = getTauxTaxe(code_taxe: achat.produit!.code_taxe) * qteProduit;
      } else {
        totalTaxeProduit = getTauxTaxe(code_taxe: achat.service!.code_taxe ?? "TVA") * qteProduit;
      }
      double totalPrixProduit = prixProduit * qteProduit;
      totalTaxe += totalTaxeProduit;
      totalHt += totalPrixProduit;
    });
    double totalTTC = totalHt + totalTaxe;
    double montantRecu = double.tryParse(commande.montant_recu ?? "0") ?? 0;
    double remise = double.tryParse(commande.remise ?? "0") ?? 0;
    double monnaie = montantRecu - totalTTC + remise;
    final jsonAchatList = achatList
        .map((e) {
          final achat = e.copyWith(produit: null, service: null);
          return achat.toJson();
        })
        .toList()
        .toString();

    setState(() {
      commande.total_ht = "$totalHt";
      commande.taxe = "$totalTaxe";
      commande.total_ttc = "$totalTTC";
      commande.montant_rendue = "$monnaie";
      commande.achat_list_json = "$jsonAchatList";
      commande.achatList = [];
      commande.achatList!.addAll(achatList);
      commande.id_entreprise = widget.entreprise.id;
      commande.entreprise = widget.entreprise;
      commande.vendeur = widget.userConnected;
      commande.id_vendeur = widget.userConnected!.id;
      commande.client = Client(
        nom: nomController.text,
        telephone: telephoneController.text,
        id_users: idUserClient,
      );
      commande.id_client = commande.client!.id;
      if (commande.client!.nom!.isEmpty) {
        commande.client!.nom = "Anonyme";
      }

      commande.vendeur_json = "${commande.vendeur!.toJson()}";
      commande.client_json = "${commande.client!.toJson()}";
      commande.code = "FACT_${DateTime.now().millisecondsSinceEpoch}_B${widget.entreprise.id}";

      //commande.code = "FACT_${UniqueKey().toString().replaceAll("[", "").replaceAll("[", "")}_B${widget.entreprise.id}";
    });
  }

  void getTaxe() async {
    listTaxeBoutique =
        await Preferences(skipLocal: true).getTaxeBoutiqueListFromLocal(id_entreprise: widget.entreprise.id);
  }

  void refreshFactureInfo({required Commande commande}) {
    this.commande = commande;
    requestStoragePermission();
    calculer();
  }

  void nouvelleFacture() {
    setState(() {
      mayShowSaveFactureSuccesPage = false;
      nomController.clear();
      telephoneController.clear();
      isLoadGetClientWithPhone = false;
      showNomTextInputWidget = false;
      commande = Commande(
        total_ht: "0",
        total_ttc: "0",
        taxe: "0",
        montant_recu: "0",
        montant_rendue: "0",
        benefice: "0",
        remise: "0",
      );

      achatList.clear();
      calculer();
    });
  }

  initPage() async {
    widget.entreprise =
        (await Preferences(skipLocal: false).getEntrepriseListFromLocal(id: widget.entreprise.id)).first;
    getTaxe();
    getProduitsBoutique(id_entreprise: widget.entreprise.id);
    requestStoragePermission();
  }

  getChoixFacture() async {
    final valueChoixTypeFacture = await Preferences.getPrefValueByKey(key: Preferences.PREFS_KEY_ChoixFacture);
    isSwitchedTypeFacture = valueChoixTypeFacture == "true" ? true : false;
    setState(() {});
  }

  Future<List<double>> getSplitterWeights() async {
    final splitterWeights = await Preferences.getPrefValueByKey(key: Preferences.PREFS_KEY_SPLITTERWEIGHTS);
    setState(() {
      if (splitterWeights.isNotEmpty) {
        weightSplitter = [double.parse(splitterWeights.split("|")[0]), double.parse(splitterWeights.split("|")[1])];
      } else {
        weightSplitter = [0.65, 0.35];
      }
    });
    return weightSplitter;
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getSplitterWeights();
    getChoixFacture();
    initPage();
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    WidgetsBinding.instance.addObserver(this);
    searchController.addListener(() {
      setState(() {
        themeRecherche = searchController.text;
      });
    });
    super.initState();
    focusNode.requestFocus();
    nouvelleFacture();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.detached) {}
  }

  PdfViewerController pdfViewerController = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: widget.showAppBar == true
          ? widget.appBar != null
              ? widget.appBar
              : Fonctions().defaultAppBar(
                  context: context,
                  titre: "Nouvelle commande",
                  iconColor: Theme.of(context).primaryColor,
                  titreColor: Theme.of(context).primaryColor,
                  isNotRoot: true,
                  elevation: 0.0,
                  backgroundColor: Fonctions().isSmallScreen(context) ? Colors.white : ConstantColor.transparentColor)
          : null,
      backgroundColor: widget.backColor,
      body: mayShowSaveFactureSuccesPage
          ? Column(
              children: [
                Expanded(
                  child: MyNoDataWidget(
                    message: "Facture bien enregistrée",
                    actionText: "Télécharger",
                    action: () async {
                      requestStoragePermission();
                      Uint8List bytes = await GenerateFactureFile()
                          .createPdf(commande: commande, format: FormatImpressionFacture.RECU);
                      // await Printing.layoutPdf(onLayout: (format) async => bytes);
                    },
                    actionText2: "Nouvelle Facture",
                    action2: () {
                      nouvelleFacture();
                    },
                    customIllustrationWidget: Icon(
                      Icons.check_circle,
                      color: ConstantColor.greenSuccessColor,
                      size: 150,
                      // size: 200,
                    ),
                  ),
                )
              ],
            )
          : MyResponsiveWidget(
              largeScreen: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: SplitView(
                  viewMode: SplitViewMode.Horizontal,
                  gripSize: 3,
                  gripColor: ConstantColor.grisColor,
                  controller: SplitViewController(
                    limits: [null, WeightLimit(max: 0.5)],
                    weights: weightSplitter,
                  ),
                  indicator: SplitIndicator(viewMode: SplitViewMode.Horizontal),
                  activeIndicator: SplitIndicator(
                    viewMode: SplitViewMode.Horizontal,
                    isActive: true,
                  ),
                  onWeightChanged: (weights) async {
                    await Preferences.saveData(
                        key: Preferences.PREFS_KEY_SPLITTERWEIGHTS, response: "${weights[0]}|${weights[1]}");
                  },
                  children: [
                    Column(
                      children: [Expanded(child: _infosAchatBloc()), _totalBloc()],
                    ),
                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          if (mayShowProduitSelector) Container(height: 500, child: _blocProduitSelector()),
                          _typeFactureBloc(),
                          _infoClientBloc(),
                          _infoMonaieBloc(),
                        ],
                      ),
                    ),
                  ],
                ),
                /*Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Expanded(child: _infosAchatBloc()),
                      _totalBloc()
                    ],
                  ),
                ),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          if (mayShowProduitSelector)
                            Container(
                                height: 500, child: _blocProduitSelector()),
                          _typeFactureBloc(),
                          _infoClientBloc(),
                          _infoMonaieBloc(),
                        ],
                      ),
                    ),
                  )],)*/
              ),
              smallScreen: _smallScreen()),
    );
  }

  Widget _smallScreen() {
    double cardHeight = achatList.length * 84;
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          _infoClientBloc(),
          Container(
              height: cardHeight < 300 ? 300 : cardHeight,
              child: _infosAchatBloc(buildCustomItem: (achat) {
                return InkWell(
                  onTap: () {
                    modifyAchat(achat: achat);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MyTextWidget(
                                          text: achat.produit != null
                                              ? "${achat.produit!.nom}"
                                              : achat.service != null
                                                  ? "${achat.service!.nom}"
                                                  : ""),
                                      MyTextWidget(
                                        text: "Qté :${achat.qte_total}",
                                        theme: BASE_TEXT_THEME.BODY_SMALL,
                                      ),
                                      MyTextWidget(
                                        text: "Prix :${achat.prix_total} F CFA",
                                        theme: BASE_TEXT_THEME.BODY_SMALL,
                                      ),
                                    ],
                                  ),
                                ),
                                if (achat.produit != null)
                                  MyImageModel(
                                    width: 56,
                                    urlImage: achat.produit != null
                                        ? "https://${ConstantUrl.urlServer}${ConstantUrl.base}${achat.produit!.img_cover_link}"
                                        : "assets/images/",
                                    fit: BoxFit.cover,
                                  )
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              deleteAchat(achat: achat);
                            });
                          },
                        )
                      ],
                    ),
                  ),
                );
              })),
          _totalBloc(),
          _infoMonaieBloc()
        ],
      ),
    );
  }

  Widget _btnCameraScanner({Key? key, Color? iconColor, Color? backColor}) {
    return MyButtonWidget(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      iconData: Icons.camera_alt_sharp,
      iconColor: iconColor ?? Colors.black,
      backColor: backColor ?? ConstantColor.lightColor,
      action: () async {
        Fonctions().showWidgetAsDialog(
            context: context,
            widget: StatefulBuilder(builder: (contextBuilder, setState) {
              return Container(
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
                        text: "Scannez un qr code du produit que vous voulez ajouter",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Fonctions().showQrView(
                        qrKey: qrKey,
                        getQrcode: (value, controller) {
                          setState(() {
                            themeRecherche = value;
                            Navigator.pop(contextBuilder);
                            getProduitsBoutique(id_entreprise: widget.entreprise.id, code: themeRecherche);
                            controller.stopCamera();
                          });
                        })
                  ],
                ),
              );
            }),
            title: "");
      },
    );
  }

  Widget _searchBloc({Key? key}) {
    return Container(
      padding: Fonctions().isSmallScreen(context) ? EdgeInsets.only(bottom: 12) : null,
      child: Row(
        children: [
          Expanded(
            child: Fonctions().isSmallScreen(context)
                ? SizedBox.shrink()
                : MyTextInputWidget(
                    textController: searchController,
                    hint: "Code du produit",
                    margin: EdgeInsets.all(4),
                    radius: 8,
                    focusNode: focusNode,
                    border: Border.all(
                        width: 1.0, color: ConstantColor.grisColor, strokeAlign: BorderSide.strokeAlignInside),
                    onLostFocus: (value) {
                      if (themeRecherche.isNotEmpty && !isLoadingVerification) {
                        // Timer(Duration(seconds: 1), () {
                        isLoadingVerification = true;
                        getProduitsBoutique(id_entreprise: widget.entreprise.id, code: themeRecherche);
                        //});
                      }
                    },
                    //rightWidget: _btnCameraScanner(),
                  ),
          ),
          if (isLoadingVerification)
            Container(
              height: 40,
              width: 40,
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                Icons.circle_outlined,
                color: ConstantColor.accentColor,
              ),
            ),
          if (Fonctions().isSmallScreen(context))
            _btnCameraScanner(iconColor: Colors.white, backColor: Theme.of(context).primaryColor),
          MyButtonWidget(
            iconData: Icons.add,
            iconColor: Colors.white,
            backColor: ConstantColor.accentColor,
            margin: const EdgeInsets.only(right: 16),
            action: () {
              if (Fonctions().isSmallScreen(context)) {
                openproduitListWidgetInAlertDialog();
              } else {
                setState(() {
                  mayShowProduitSelector = true;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _typeFactureBloc() {
    return MyCardWidget(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          MyTextWidget(text: "Facture normalisée"),
          Spacer(),
          Switch(
            value: isSwitchedTypeFacture,
            activeColor: ConstantColor.accentColor,
            onChanged: (bool switchValue) async {
              setState(() {
                isSwitchedTypeFacture = !isSwitchedTypeFacture;
              });
              await Preferences.saveData(
                  key: '${Preferences.PREFS_KEY_ChoixFacture}', response: "$isSwitchedTypeFacture");
            },
          ),
        ],
      ),
    );
  }

  Widget _infoClientBloc() {
    return MyCardWidget(
      margin: EdgeInsets.all(4),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyTextWidget(
                  text: "Client",
                  textAlign: TextAlign.center,
                ),
                MyButtonWidget(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  iconData: Icons.qr_code_sharp,
                  iconColor: Theme.of(context).iconTheme.color,
                  backColor: ConstantColor.lightColor,
                  showShadow: true,
                  action: () {
                    BuildContext? contextBuildScan;
                    Fonctions().showWidgetAsDialog(
                        context: context,
                        title: "Scan code",
                        widget: StatefulBuilder(builder: (context, setState) {
                          contextBuildScan = contextBuildScan;
                          return Container(
                            width: 500,
                            constraints: BoxConstraints(maxWidth: 500),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MyTextInputWidget(
                                  margin: EdgeInsets.all(4),
                                  textController: qr_Controller,
                                  hintLabel: "Qr code",
                                  rightWidget: MyButtonWidget(
                                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                                    iconData: Icons.camera_alt_sharp,
                                    iconColor: Colors.black,
                                    backColor: ConstantColor.lightColor,
                                    action: () async {
                                      Fonctions().showWidgetAsDialog(
                                          context: contextBuildScan!,
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
                                                    text:
                                                        "Recherche rapide! Scannez un qr code d'un client pour le retrouver plus facillement.",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Fonctions().showQrView(
                                                    qrKey: qrKey,
                                                    getQrcode: (value, controller) {
                                                      qr_Controller.text = value;
                                                      Navigator.pop(contextBuildScan!);
                                                      controller.stopCamera();
                                                      setState(() {});
                                                    })
                                              ],
                                            ),
                                          ),
                                          title: "");
                                    },
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: MyButtonWidget(
                                        text: "Valider",
                                        rounded: true,
                                        load: isLoadGetClientWithId,
                                        loaderColor: Colors.white,
                                        margin: EdgeInsets.all(12),
                                        action: () async {
                                          setState(() {
                                            isLoadGetClientWithId = true;
                                          });
                                          getUser(id_user: qr_Controller.text, contextBuild: context);
                                        },
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        }));
                  },
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              children: [
                MyTextInputWidget(
                  margin: EdgeInsets.all(4),
                  textController: telephoneController,
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  isTelephone: true,
                  hintLabel: "telephone",
                  rightWidget: MyButtonWidget(
                    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    iconData: Icons.search,
                    iconColor: Colors.white,
                    load: isLoadGetClientWithPhone,
                    backColor: ConstantColor.accentColor,
                    action: () async {
                      if (telephoneController.text.isEmpty) {
                        return;
                      }
                      setState(() {
                        isLoadGetClientWithPhone = true;
                      });
                      getUser(telephone: telephoneController.text);
                      setState(() {});
                    },
                  ),
                ),
                if (showNomTextInputWidget)
                  Row(
                    children: [
                      Expanded(
                        child: MyTextInputWidget(
                          margin: EdgeInsets.all(4),
                          textController: nomController,
                          //minLength: 2,
                          hintLabel: "nom",
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infosAchatBloc({bool showInCard = true, Function(Achat)? buildCustomItem}) {
    Widget content = Column(
      children: [
        Expanded(
          child: AchatListWidget(
            key: ValueKey<String>(achatList.toString()),
            canDeleteItem: true,
            canEditItem: true,
            canRefresh: false,
            backColor: Colors.white,

            physics: NeverScrollableScrollPhysics(),
            //showAsGrid: Fonctions().isSmallScreen(context),
            //scrollController: Fonctions().isSmallScreen(context) ? scrollController : null,
            deleteAchat: (value) {
              deleteAchat(achat: value);
            },
            modifyAchat: (value) {
              modifyAchat(achat: value);
            },
            buildCustomItemView: buildCustomItem != null
                ? (achat) {
                    return buildCustomItem(achat);
                  }
                : null,
            customNoDataWidget: InkWell(
              onTap: () {
                if (Fonctions().isSmallScreen(context)) {
                  openproduitListWidgetInAlertDialog();
                } else {
                  setState(() {
                    mayShowProduitSelector = true;
                  });
                }
              },
              child: MyNoDataWidget(
                message: "Ajoutez les produits achetés.",
              ),
            ),
            showItemAsCard: false,
            list: achatList,
          ),
        ),
        _searchBloc()
      ],
    );
    return showInCard
        ? MyCardWidget(
            margin: EdgeInsets.all(4),
            child: content,
          )
        : content;
  }

  Widget _totalBloc() {
    return MyCardWidget(
      margin: EdgeInsets.all(4),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        height: 96,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400, mainAxisExtent: 20, crossAxisSpacing: 40),
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              children: [
                MyMinimalDisplayInfos(
                  title: "TOTAL HT",
                  content: "${commande.total_ht} F CFA",
                  orientation: Axis.horizontal,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                ),
                MyMinimalDisplayInfos(
                  title: "Taxe",
                  content: "${commande.taxe} F CFA",
                  orientation: Axis.horizontal,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                ),
                MyMinimalDisplayInfos(
                  title: "TOTAL TTC",
                  content: "${commande.total_ttc} F CFA",
                  orientation: Axis.horizontal,
                  titleTheme: BASE_TEXT_THEME.LABEL_MEDIUM,
                  valueTheme: BASE_TEXT_THEME.LABEL_MEDIUM,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoMonaieBloc() {
    return MyCardWidget(
      margin: EdgeInsets.all(4),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        child: Formulaire(
            contextFormulaire: context,
            mayPopNavigatorOnSuccess: false,
            successCallBack: (valueCodeMecef) {
              setState(() {
                if (valueCodeMecef.isNotEmpty) {
                  commande.code_mecef = valueCodeMecef;
                }
                mayShowSaveFactureSuccesPage = true;
              });
            }).saveCommandeForm(
            showButtonCalculer: true,
            refreshFactureInfo: refreshFactureInfo,
            isFactureNormalisee: isSwitchedTypeFacture,
            /*printFacture: () {
              GenerateFactureFile().createPdf(commande: commande, format: FormatImpressionFacture.FACTURE);
            },*/
            objectCommande: commande),
      ),
    );
  }

  Widget _blocProduitSelector() {
    return MyBlocCardWidget(
      title: "Ajoutez les achats",
      titleRightWidget: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          setState(() {
            mayShowProduitSelector = false;
          });
        },
      ),
      child: Expanded(child: _blocTabBar()),
    );
  }

  Widget _blocTabBar({Key? key}) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          child: TabBar(
            tabs: const [
              Tab(text: "Produits"),
              Tab(text: "Services"),
            ],
            controller: tabController,
            isScrollable: true,
            indicatorColor: ConstantColor.accentColor,
            labelColor: ConstantColor.accentColor,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: ConstantColor.textColor,
          ),
        ),
        Divider(),
        Expanded(
          child: Container(
            color: ConstantColor.backgroundColor,
            child: TabBarView(
              controller: tabController,
              children: [
                _blocProduitList(),
                _blocServiceList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _blocProduitList() {
    return ProduitListWidget(
      idSelectedEntreprise: widget.entreprise.id,
      skipLocal: true,
      showSearchBar: true,
      canAddItem: true,
      customNoDataWidget: MyNoDataWidget(
        message: "Aucun produit",
      ),
      buildCustomItemView: (value) {
        Achat achat = (achatList.firstWhere(
            (element) => element.produit != null ? element.produit!.id == value.id : false,
            orElse: () => Achat(qte_total: "0")));
        return StatefulBuilder(builder: (context, setState) {
          return InkWell(
            onTap: () {
              addProduitToAchatList(produit: value);
              int qte = int.tryParse(achat.qte_total!) ?? 0;
              qte++;
              achat = achat.copyWith(qte_total: "$qte");

              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyTextWidget(text: "${value!.nom}"),
                            MyTextWidget(
                              text: "Prix: ${value.prix} F CFA",
                              theme: BASE_TEXT_THEME.BODY_SMALL,
                            ),
                            MyTextWidget(
                              text:
                                  "Quantité : ${/*achatList.isNotEmpty ? */ (achatList.firstWhere((element) => element.produit != null ? element.produit!.id == value.id : false, orElse: () => Achat(qte_total: "0"))).qte_total /*: "0"*/}",
                              textColor: ConstantColor.accentColor,
                            )
                          ],
                        ),
                      ),
                      MyImageModel(
                        width: 56,
                        urlImage: "https://${ConstantUrl.urlServer}${ConstantUrl.base}${value!.img_cover_link}",
                        fit: BoxFit.cover,
                      )
                    ],
                  ),
                  Divider()
                ],
              ),
            ),
          );
        });
      },
      backColor: Colors.white,
    );
  }

  Widget _blocServiceList() {
    return ServicesListWidget(
      idSelectedEntreprise: widget.entreprise.id,
      skipLocal: true,
      showSearchBar: true,
      canAddItem: true,
      customNoDataWidget: MyNoDataWidget(
        message: "Aucun produit",
      ),
      buildCustomItemView: (value) {
        Achat achat = (achatList.firstWhere(
            (element) => element.service != null ? element.service!.id == value.id : false,
            orElse: () => Achat(qte_total: "0")));
        //: Achat(qte_total: "0");
        //print(" $achat");
        return StatefulBuilder(builder: (context, setState) {
          return InkWell(
            onTap: () {
              addProduitToAchatList(service: value);
              int qte = int.tryParse(achat.qte_total!) ?? 0;
              qte++;
              achat = achat.copyWith(qte_total: "$qte");

              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyTextWidget(text: "${value.nom}"),
                            MyTextWidget(
                              text: "Prix : ${value.cout} F CFA",
                              theme: BASE_TEXT_THEME.BODY_SMALL,
                            ),
                            MyTextWidget(
                              text:
                                  "Quantité : ${/*achatList.isNotEmpty ? */ (achatList.firstWhere((element) => element.service != null ? element.service!.id == value.id : false, orElse: () => Achat(qte_total: "0"))).qte_total /*: "0"*/}",
                              textColor: ConstantColor.accentColor,
                            )
                          ],
                        ),
                      ),
                      MyImageModel(
                        width: 56,
                        urlImage: "https://${ConstantUrl.urlServer}${ConstantUrl.base}${value!.img_cover_link}",
                        fit: BoxFit.cover,
                      )
                    ],
                  ),
                  Divider()
                ],
              ),
            ),
          );
        });
      },
      backColor: Colors.white,
    );
  }
}

class MyScrollWidget extends StatelessWidget {
  final Widget? child;
  final ScrollController controller;

  const MyScrollWidget({Key? key, required this.child, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        controller: controller,
        physics: BouncingScrollPhysics(),
        dragStartBehavior: DragStartBehavior.start,
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          controller: ScrollController(),
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          dragStartBehavior: DragStartBehavior.start,
          child: child,
        ),
      );
}
