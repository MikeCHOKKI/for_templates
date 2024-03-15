import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyDropDownWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyLoadingWidget.dart';
import 'package:core/common_folder/widgets/MyResponsiveWidget.dart';
import 'package:core/common_folder/widgets/MyTextInputWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/formulaires.dart';
import 'package:core/objet/Produit.dart';
import 'package:core/objet/Users.dart';
import 'package:core/pages/objet_details/ProduitDetailsPage.dart';
import 'package:core/pages/objet_list/ProduitListWidget.dart';
import 'package:core/pages/widget/VueProduit.dart';
import 'package:core/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:split_view/split_view.dart';

import 'InscriptionProduitPage.dart';

class ProduitsBoutiquePage extends StatefulWidget {
  final Color? backColor;
  final String? idSelectedEntreprise;
  final BuildContext? homeContext;
  final Users? userConnected;
  final EdgeInsetsGeometry? padding;
  final PreferredSizeWidget? appBar;
  final bool? showAppBar;

  ProduitsBoutiquePage(
      {Key? key,
      this.userConnected,
      this.homeContext,
      this.idSelectedEntreprise,
      this.backColor,
      this.padding,
      this.showAppBar = false,
      this.appBar})
      : super(key: key);

  @override
  State<ProduitsBoutiquePage> createState() => _ProduitsBoutiquePageState();
}

class _ProduitsBoutiquePageState extends State<ProduitsBoutiquePage> {
  TextEditingController searchController = TextEditingController();
  List<Produit> produitList = [];
  List<String> typeList = [
    "Tous les produits",
    "Produits ayant un stock bas",
    "Produits les plus vendus",
    "Tous les produits vendus",
    "Produits enregistrés automatiquement",
    "Produits bientôt avariés"
  ];
  String selectedType = "";
  bool isLoading = false, skipLocal = false, hideColonneDetailsproduit = false, isModificationProduit = false;
  Produit? produitSelected;
  String idproduitselected = "";
  String? themeRecherche;
  List<double> weightSplitter = [1, 0];

  void getAllProduits({String? id_entreprise = ""}) async {
    setState(() {
      isLoading = true;
    });
    Preferences(skipLocal: true)
        .getProduitListFromLocal(id_entreprise: id_entreprise)
        .then((value) => {
              setState(() {
                searchController.text = "";
                produitList.clear();
                produitList.addAll(value);
                //print("produitList: $produitList");
                if (idproduitselected.isNotEmpty) {
                  produitSelected = produitList.firstWhere((element) => element.id == idproduitselected);
                }
                isLoading = false;
                idproduitselected = "";
              })
            })
        .onError((error, stackTrace) => {
              setState(() {
                isLoading = false;
              })
            });
  }

  Future<List<double>> getSplitterWeights() async {
    final splitterWeights = await Preferences.getPrefValueByKey(key: Preferences.PREFS_KEY_SPLITTERWEIGHTS);
    setState(() {
      if (splitterWeights.isNotEmpty && hideColonneDetailsproduit == false && produitSelected != null) {
        weightSplitter = [double.parse(splitterWeights.split("|")[0]), double.parse(splitterWeights.split("|")[1])];
      } else {
        weightSplitter = hideColonneDetailsproduit == true || produitSelected == null ? [1, 0] : [0.65, 0.35];
      }
    });
    return weightSplitter;
  }

  void reloadPage() {
    // print("Reload");
    setState(() {
      isLoading = true;
      idproduitselected = produitSelected!.id!;
      getAllProduits(id_entreprise: widget.idSelectedEntreprise);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getSplitterWeights();
    selectedType = typeList.first;
    getAllProduits(id_entreprise: widget.idSelectedEntreprise);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: widget.showAppBar == true
          ? widget.appBar != null
              ? widget.appBar
              : Fonctions().defaultAppBar(
                  context: context,
                  titre: "Produits",
                  iconColor: Theme.of(context).primaryColor,
                  titreColor: Theme.of(context).primaryColor,
                  isNotRoot: true,
                  elevation: 0.0,
                  backgroundColor: Fonctions().isSmallScreen(context) ? Colors.white : ConstantColor.transparentColor)
          : null,
      floatingActionButton: Fonctions().isSmallScreen(context)
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Fonctions().showWidgetAsDialog(
                    context: context,
                    widget: Container(
                      height: MediaQuery.of(context).size.height * 0.88,
                      width: 500,
                      constraints: BoxConstraints(maxWidth: 500),
                      child: Column(
                        children: [
                          Expanded(
                            child: InscriptionProduitPage(
                              reload: (value) {
                                themeRecherche = value.toString();
                                skipLocal = true;
                                hideColonneDetailsproduit = true;
                                produitSelected = null;
                                setState(() {});
                              },
                              idSelectedEntreprise: widget.idSelectedEntreprise,
                            ),
                          ),
                        ],
                      ),
                    ),
                    title: "Ajout produit");
              },
            )
          : null,
      backgroundColor: widget.backColor,
      body: Container(
        padding: widget.padding,
        child: MyResponsiveWidget(
          smallScreen: Column(
            children: [
              //_typeProduitBloc(),

              Container(padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8), child: _searchBarBloc()),
              /*if (isLoading) Center(child: MyLoadingWidget()),
              if (!isLoading)
              if (!isLoading && produitList.isNotEmpty)*/
              /* SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          alignment: Alignment.centerRight,
                          child: MyTextWidget(
                            text: "Exporter",
                            theme: BASE_TEXT_THEME.TITLE,
                          ),
                        ),
                      ),
                      MyButtonWidget(
                        iconColor: Colors.white,
                        backColor: ConstantColor.greenSuccessColor,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        padding: const EdgeInsets.all(4),

                        iconData: Mdi.fileExcel,

                        action: () {
                          print("Exporter");
                          //mainE();
                        }, //()async {
                        */ /*setState(() {
                                  var excel = Excel.createExcel();
                                  Sheet sheetObject = excel[
                                      excel.getDefaultSheet() ?? 'Produits'];
                                  sheetObject.setColWidth(0, 30);
                                  sheetObject.setColWidth(1, 35);
                                  sheetObject.setColWidth(6, 30);
                                  sheetObject.setColWidth(3, 8);
                                  sheetObject.setColAutoFit(3);
                                  List<String> header = [
                                    "Code",
                                    "Nom",
                                    "Prix",
                                    "Qte",
                                    "Taxe",
                                    "Prix_achat",
                                    "Date_expiration"
                                  ];
                                  print(header);
                                  int colHeaderIndex = 0;
                                  header.forEach((element) {
                                    sheetObject
                                        .cell(CellIndex.indexByColumnRow(
                                            columnIndex: colHeaderIndex,
                                            rowIndex: 0))
                                        .value = header[colHeaderIndex];
                                    colHeaderIndex++;
                                  });
                                  int index = 1;
                                  print(
                                      "produitList: ${produitList.length}");
                                  produitList.forEach((element) {
                                    print("Element Excel $element");
                                    sheetObject.cell(CellIndex.indexByColumnRow(
                                        columnIndex: 0, rowIndex: index))
                                      .value = element.code;
                                    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: index)).value =
                                        element.nom;
                                    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: index)).value =
                                        element.prix;
                                    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: index)).value =
                                        element.qte;
                                    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: index)).value =
                                        element.code_taxe;
                                    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: index)).value =
                                        element.prix_achat_unitaire;
                                    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: index)).value =
                                        element.date_expiration;
                                    index++;
                                  });
                                  var fileBytes = excel.save(fileName: "My_Excel_File_Name.xlsx");
                                });*/ /*
                        //},
                      )
                    ],
                  ),
                ),*/
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: _produitListBloc(
                      // showAsGrid: true,
                      backColor: Colors.white,
                      buildCustomItemView: (produit) {
                        return VueProduit(
                          produit: produit,
                          //reloadPage: reloadPage,
                          customView: Column(
                            children: [
                              Row(
                                children: [
                                  MyImageModel(
                                    size: 72,
                                    margin: EdgeInsets.zero,
                                    urlImage:
                                        "https://${ConstantUrl.urlServer}${ConstantUrl.base}${produit.img_cover_link}",
                                    //showDefaultImage: true,
                                    fit: BoxFit.cover,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: MyTextWidget(
                                              text: "${produit.nom}",
                                              theme: BASE_TEXT_THEME.TITLE_SMALL,
                                            ),
                                          ),
                                          MyTextWidget(
                                            text: "Qté en stock: ${produit.qte}",
                                            theme: BASE_TEXT_THEME.BODY_SMALL,
                                          ),
                                          MyTextWidget(
                                            text: "Prix de vente: ${produit.prix} F CFA",
                                            theme: BASE_TEXT_THEME.BODY_SMALL,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Divider()
                            ],
                          ),
                        );
                      }

                      //canAddItem: true,
                      /*onItemPressed: (value) {
                      Fonctions().showWidgetAsDialog(
                          context: context,
                          widget: Container(
                            height: MediaQuery.of(context).size.height * 0.88,
                            width: 500,
                            constraints: BoxConstraints(maxWidth: 500),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ProduitDetailsPage(
                                    produit: value,
                                    canEditItem: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          title: "Détails de ${value.nom}");
                    },*/
                      ),
                ),
              ),
            ],
          ),
          /*mediumScreen: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _typeProduitBloc(),
                    ),
                    Expanded(
                      child: _searchBarBloc(),
                    ),
                    MyButtonWidget(
                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      iconData: Icons.add,
                      backColor: ConstantColor.greenSuccessColor,
                      iconColor: Colors.white,
                      action: () {
                        Fonctions().showWidgetAsDialog(
                            context: context,
                            widget: Container(
                              height: MediaQuery.of(context).size.height * 0.88,
                              width: 500,
                              constraints: BoxConstraints(maxWidth: 500),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: InscriptionProduitPage(
                                      reload: (value) {
                                        themeRecherche = value.toString();
                                        skipLocal = true;
                                        hideColonneDetailsproduit = true;
                                        produitSelected = null;
                                        setState(() {});
                                      },
                                      idSelectedEntreprise: widget.idSelectedEntreprise,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            title: "Ajout produit");
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  //height: MediaQuery.of(context).size.height*0.5,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: _produitListBloc(
                    backColor: Colors.white,
                    onItemPressed: (value) {
                      Fonctions().showWidgetAsDialog(
                          context: context,
                          widget: Container(
                            height: MediaQuery.of(context).size.height * 0.88,
                            width: 500,
                            constraints: BoxConstraints(maxWidth: 500),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ProduitDetailsPage(
                                    produit: value,
                                    canEditItem: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          title: "Détails de ${value.nom}");
                    },
                  ),
                ),
              ),
            ],
          ),*/
          largeScreen: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _typeProduitBloc(),
                          ),
                          Expanded(
                            child: _searchBarBloc(),
                          ),
                          MyButtonWidget(
                            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            iconData: Icons.add,
                            backColor: ConstantColor.greenSuccessColor,
                            iconColor: Colors.white,
                            action: () {
                              Fonctions().showWidgetAsDialog(
                                  context: context,
                                  widget: Container(
                                    height: MediaQuery.of(context).size.height * 0.88,
                                    width: 500,
                                    constraints: BoxConstraints(maxWidth: 500),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: InscriptionProduitPage(
                                            reload: (value) {
                                              themeRecherche = value.toString();
                                              skipLocal = true;
                                              hideColonneDetailsproduit = true;
                                              produitSelected = null;
                                              setState(() {});
                                            },
                                            idSelectedEntreprise: widget.idSelectedEntreprise,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  title: "Ajout produit");
                            },
                          ),
                          MyButtonWidget(
                            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            iconData: hideColonneDetailsproduit == false
                                ? Icons.arrow_forward_ios_sharp
                                : Icons.arrow_back_ios_sharp,
                            backColor: ConstantColor.lightColor,
                            showShadow: true,
                            iconColor: Theme.of(context).iconTheme.color,
                            action: () async {
                              setState(() {
                                hideColonneDetailsproduit = hideColonneDetailsproduit == false ? true : false;
                              });
                              await getSplitterWeights();
                            },
                          )
                        ],
                      ),
                      Expanded(
                        child: Container(
                          //height: MediaQuery.of(context).size.height*0.5,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: _produitListBloc(
                              backColor: Colors.white,
                              onEditPressed: (value) async {
                                setState(() {
                                  isModificationProduit = true;
                                  produitSelected = value;
                                });
                                await getSplitterWeights();
                              },
                              onItemPressed: (value) async {
                                setState(() {
                                  produitSelected = value;
                                  hideColonneDetailsproduit = false;
                                  isModificationProduit = false;
                                });
                                await getSplitterWeights();
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!hideColonneDetailsproduit)
                  if (produitSelected != null)
                    SizedBox(
                      //width: MediaQuery.of(context).size.width*0.3,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isLoading) Center(child: MyLoadingWidget()),
                            if (!isLoading && produitSelected != null && isModificationProduit)
                              MyCardWidget(
                                //color: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                child: Formulaire(
                                    contextFormulaire: context,
                                    mayPopNavigatorOnSuccess: false,
                                    successCallBack: (value) {
                                      themeRecherche = "";
                                      skipLocal = true;
                                      hideColonneDetailsproduit = true;
                                      isModificationProduit = false;
                                      produitSelected = null;
                                      setState(() {});
                                    }).saveProduitForm(
                                  objectProduit: produitSelected,
                                  idSelectedEntreprise: widget.idSelectedEntreprise,
                                ),
                              ),
                            if (!isLoading && produitSelected != null && !isModificationProduit)
                              Container(
                                height: MediaQuery.of(context).size.height * 0.88,
                                width: 500,
                                constraints: BoxConstraints(maxWidth: 500),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ProduitDetailsPage(
                                        key: ValueKey<String>("$produitSelected"),
                                        produit: produitSelected!,
                                        canEditItem: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
        /* Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _typeProduitBloc(),
                            ),
                            Expanded(
                              child: _searchBarBloc(),
                            ),
                            MyButtonWidget(
                              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              iconData: Icons.add,
                              backColor: ConstantColor.greenSuccessColor,
                              iconColor: Colors.white,
                              action: () {
                                Fonctions().showWidgetAsDialog(
                                    context: context,
                                    widget: Container(
                                      height: MediaQuery.of(context).size.height * 0.88,
                                      width: 500,
                                      constraints: BoxConstraints(maxWidth: 500),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: InscriptionProduitPage(
                                              reload: (value) {
                                                themeRecherche = value.toString();
                                                skipLocal = true;
                                                hideColonneDetailsproduit = true;
                                                produitSelected = null;
                                                setState(() {});
                                              },
                                              idSelectedEntreprise: widget.idSelectedEntreprise,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    title: "Ajout produit");
                              },
                            ),
                            MyButtonWidget(
                              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              iconData: hideColonneDetailsproduit == false
                                  ? Icons.arrow_forward_ios_sharp
                                  : Icons.arrow_back_ios_sharp,
                              backColor: ConstantColor.lightColor,
                              showShadow: true,
                              iconColor: Theme.of(context).iconTheme.color,
                              action: () {
                                setState(() {
                                  hideColonneDetailsproduit = hideColonneDetailsproduit == false ? true : false;
                                });
                              },
                            )
                          ],
                        ),
                        Expanded(
                          child: Container(
                            //height: MediaQuery.of(context).size.height*0.5,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: _produitListBloc(
                                backColor: Colors.white,
                                onEditPressed: (value){
                                  setState(() {
                                    isModificationProduit = true;
                                    produitSelected = value;
                                  });
                                },
                                onItemPressed: (value) {
                                  setState(() {
                                    produitSelected = value;
                                    hideColonneDetailsproduit = false;
                                    isModificationProduit = false;
                                  });
                                }),
                          ),
                        ),
                      ],
                    )),
                if (!isLoading && produitList.isNotEmpty)
                  SizedBox(
                    width: 16,
                  ),
                if (!hideColonneDetailsproduit)
                  if (produitSelected != null)
                    Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isLoading) Center(child: MyLoadingWidget()),
                              if (!isLoading && produitSelected != null && isModificationProduit)
                                MyCardWidget(
                                  //color: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 4),
                                  child: Formulaire(
                                      contextFormulaire: context,
                                      mayPopNavigatorOnSuccess: false,
                                      successCallBack: (value) {
                                        themeRecherche = "";
                                        skipLocal = true;
                                        hideColonneDetailsproduit = true;
                                        isModificationProduit = false;
                                        produitSelected = null;
                                        setState(() {
                                        });
                                      }).saveProduitForm(
                                    objectProduit: produitSelected,
                                    idSelectedEntreprise: widget.idSelectedEntreprise,
                                  ),
                                ),
                            if (!isLoading && produitSelected != null && !isModificationProduit)
                              Container(
                                height: MediaQuery.of(context).size.height * 0.88,
                                width: 500,
                                constraints: BoxConstraints(maxWidth: 500),
                                child: Column(
                                  children: [
                                      Expanded(
                                        child: ProduitDetailsPage(
                                          key: ValueKey<String>("$produitSelected"),
                                          produit: produitSelected!,
                                          canEditItem: false,
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),*/
      ),
      //),
      /*Container(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            if(!Fonctions().isSmallScreen(context))
            Expanded(
                flex: !Fonctions().isSmallScreen(context) ? 5 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Expanded(
                          child: _typeProduitBloc(),
                        ),
                        if (!Fonctions().isSmallScreen(context))
                          Expanded(
                            child: _searchBarBloc(),
                          ),
                      ],
                    ),
                    if (Fonctions().isSmallScreen(context)) _searchBarBloc(),
                    Expanded(
                      child: Container(
                        //height: MediaQuery.of(context).size.height*0.5,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: ProduitListWidget(
                          key: ValueKey<String?>("$themeRecherche"),
                          padding: Fonctions().isLargeScreen(context)
                              ? EdgeInsets.all(12)
                              : EdgeInsets.zero,
                          skipLocal: skipLocal,
                          showItemAsCard: false,
                          idSelectedEntreprise: widget.idSelectedEntreprise,
                          //context: widget.homeContext,
                          backColor: Fonctions().isLargeScreen(context)
                              ? Colors.white
                              : null,
                          theme: themeRecherche,
                          onItemPressed: (value) {
                            setState(() {
                              produitSelected = value;
                            });
                          },
                          // list: produitList,
                        ),
                      ),
                    ),
                    if (!isLoading && produitList.isNotEmpty)
                      SizedBox(
                        height: 60,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                alignment: Alignment.centerRight,
                                child: MyTextWidget(
                                  text: "Exporter",
                                  theme: BASE_TEXT_THEME.TITLE,
                                ),
                              ),
                            ),
                            MyButtonWidget(
                              iconColor: Colors.white,
                              backColor: ConstantColor.greenSuccessColor,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              padding: const EdgeInsets.all(4),

                              iconData: Mdi.fileExcel,

                              action: () {
                                print("Exporter");
                                //mainE();
                              }, //()async {
                              */ /*setState(() {
                                var excel = Excel.createExcel();
                                Sheet sheetObject = excel[
                                    excel.getDefaultSheet() ?? 'Produits'];
                                sheetObject.setColWidth(0, 30);
                                sheetObject.setColWidth(1, 35);
                                sheetObject.setColWidth(6, 30);
                                sheetObject.setColWidth(3, 8);
                                sheetObject.setColAutoFit(3);
                                List<String> header = [
                                  "Code",
                                  "Nom",
                                  "Prix",
                                  "Qte",
                                  "Taxe",
                                  "Prix_achat",
                                  "Date_expiration"
                                ];
                                print(header);
                                int colHeaderIndex = 0;
                                header.forEach((element) {
                                  sheetObject
                                      .cell(CellIndex.indexByColumnRow(
                                          columnIndex: colHeaderIndex,
                                          rowIndex: 0))
                                      .value = header[colHeaderIndex];
                                  colHeaderIndex++;
                                });
                                int index = 1;
                                print(
                                    "produitList: ${produitList.length}");
                                produitList.forEach((element) {
                                  print("Element Excel $element");
                                  sheetObject.cell(CellIndex.indexByColumnRow(
                                      columnIndex: 0, rowIndex: index))
                                    .value = element.code;
                                  sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: index)).value =
                                      element.nom;
                                  sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: index)).value =
                                      element.prix;
                                  sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: index)).value =
                                      element.qte;
                                  sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: index)).value =
                                      element.code_taxe;
                                  sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: index)).value =
                                      element.prix_achat_unitaire;
                                  sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: index)).value =
                                      element.date_expiration;
                                  index++;
                                });
                                var fileBytes = excel.save(fileName: "My_Excel_File_Name.xlsx");
                              });
                              //},
                            )
                          ],
                        ),
                      )
                  ],
                )),
            if(!Fonctions().isSmallScreen(context))
            SizedBox(
              width: 16,
            ),
            Expanded(
              flex: Fonctions().isLargeScreen(context)
                  ? 2
                  : Fonctions().isMediumScreen(context)
                      ? 3
                      : 1,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isLoading) Center(child: MyLoadingWidget()),
                    if (!isLoading)
                      MyCardWidget(
                        //color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                        child: Formulaire(
                            contextFormulaire: context,
                            successCallBack: () {
                              setState(() {
                                reloadPage();
                              });
                            }).saveProduitForm(
                          edit: "isVendeur",
                          objectProduit: produitSelected,
                          idSelectedEntreprise: widget.idSelectedEntreprise,
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),*/ /*
*/
    );
  }

  Widget _produitListBloc(
      {Key? key,
      Color? backColor,
      Function? onItemPressed,
      Function? onEditPressed,
      Function(Produit)? buildCustomItemView,
      bool showAsGrid = false,
      bool canEditItem = true,
      bool canDeleteItem = true,
      bool canAddItem = false}) {
    return ProduitListWidget(
      key: ValueKey<String?>(themeRecherche),
      // padding: EdgeInsets.all(12),
      //margin: EdgeInsets.symmetric(horizontal: 16),
      skipLocal: true,
      canEditItem: canEditItem,
      canDeleteItem: canDeleteItem,
      canAddItem: canAddItem,
      showItemAsCard: false,
      backColor: backColor,
      showAsGrid: showAsGrid,
      idSelectedEntreprise: widget.idSelectedEntreprise,
      buildCustomItemView: buildCustomItemView != null
          ? (produit) {
              return buildCustomItemView(produit);
            }
          : null,
      //context: widget.homeContext,
      theme: themeRecherche,
      onEditPressed: onEditPressed,
      onItemPressed: onItemPressed,
      // list: produitList,
    );
  }

  Widget _typeProduitBloc({Key? key}) {
    return SizedBox(
      height: 44,
      child: MyDropDownWidget(
        initialObject: selectedType,
        listObjet: typeList,
        //padding: EdgeInsets.symmetric(horizontal: 8),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        onChangedDropDownValue: (value) {
          setState(() {
            selectedType = value;
            skipLocal = true;
            themeRecherche = selectedType;
          });
        },
      ),
    );
  }

  Widget _searchBarBloc({Key? key}) {
    return Row(
      children: [
        Expanded(
          child: MyTextInputWidget(
            textController: searchController,
            hint: "Rechercher...",
            margin: EdgeInsets.symmetric(horizontal: 8),
            radius: 90,
            backColor: Colors.white,
            onChanged: (value) {
              skipLocal = false;
              themeRecherche = value;
              hideColonneDetailsproduit = value.isEmpty ? false : true;
              produitSelected = null;
              //print("searchValue: $themeRecherche");
              setState(() {});
            },
            leftWidget: const Icon(
              Icons.search,
              size: 20,
              color: ConstantColor.accentColor,
            ),
          ),
        ),
      ],
    );
  }
}
