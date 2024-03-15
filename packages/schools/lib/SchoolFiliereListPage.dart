import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyResponsiveWidget.dart';
import 'package:core/common_folder/widgets/MyTextInputWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/objet/CategorieEntreprise.dart';
import 'package:core/objet/Entreprise.dart';
import 'package:core/objet/SchoolFilieres.dart';
import 'package:core/objet/SousCategorieEntreprise.dart';
import 'package:core/pages/objet_details/EntrepriseDetailsPage.dart';
import 'package:core/pages/objet_list/EntrepriseListWidget.dart';
import 'package:core/pages/objet_list/SchoolFilieresListWidget.dart';
import 'package:core/pages/objet_list/SousCategorieEntrepriseListWidget.dart';
import 'package:flutter/material.dart';

class SchoolFiliereListPage extends StatefulWidget {
  Entreprise? ecole;

  SchoolFiliereListPage({Key? key, this.ecole}) : super(key: key);

  @override
  State<SchoolFiliereListPage> createState() => _SchoolFiliereListPageState();
}

class Filiere {
  final String nom;

  final String description;

  final IconData icone;

  Filiere(this.nom, this.description, this.icone);
}

class _SchoolFiliereListPageState extends State<SchoolFiliereListPage> {
  TextEditingController searchController = TextEditingController();
  Entreprise? selectedEcole;
  CategorieEntreprise categorieEducation = CategorieEntreprise(id: "cat_education");
  bool filterExpanded = false;
  late SousCategorieEntreprise selectedCategorieEcole = SousCategorieEntreprise(nom: "Tous les types");
  List<SchoolFilieres> filieresListSoucre = [];
  List<SchoolFilieres> filteredFilieresList = [];
  String tabToShow = "";

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    selectedEcole = widget.ecole;
    tabToShow = widget.ecole != null ? "ECOLE" : "FILIERES";
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    filteredFilieresList = filieresListSoucre.where((element) {
      //print("LECO ${element.ecole!.id_sous_categorie!}");
      return (Fonctions()
              .removeAccents(element.nom!)
              .toLowerCase()
              .contains(searchController.text.toLowerCase().trim())) &&
          (selectedCategorieEcole.id != null
              ? element.ecole != null
                  ? element.ecole!.id_sous_categorie == selectedCategorieEcole.id
                  : false
              : true) &&
          ((selectedEcole != null && selectedEcole!.id != null) ? element.ecole!.id == selectedEcole!.id : true);
    }).toList();

    return SafeArea(
      child: Scaffold(
          body: MyResponsiveWidget(
        largeScreen: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/abstract_cover.jpg",
                  ),
                  fit: BoxFit.cover)),
          child: Container(
            color: Colors.white.withOpacity(Fonctions().isSmallScreen(context) ? 0.1 : 0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 900,
                  constraints: BoxConstraints(maxWidth: 900),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            if (widget.ecole == null)
                              Container(
                                color: Colors.white,
                                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    MyButtonWidget(
                                      iconData: Icons.keyboard_arrow_left,
                                      rounded: true,
                                      backColor: ConstantColor.accentColor,
                                      iconColor: Colors.white,
                                      action: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                            child: MyTextWidget(
                                              text:
                                                  "${widget.ecole != null ? widget.ecole!.nom : "Toutes les filières"}",
                                              textAlign: TextAlign.center,
                                              theme: BASE_TEXT_THEME.TITLE,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    /* if (widget.ecole != null)
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 24),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              MyButtonWidget(
                                                text: "L'école",
                                                radiusButton: 10,
                                                showShadow: false,
                                                backColor: tabToShow == "ECOLE"
                                                    ? ConstantColor.accentColor.withOpacity(0.1)
                                                    : Colors.black.withOpacity(0.1),
                                                textColor:
                                                    tabToShow == "ECOLE" ? ConstantColor.accentColor : Colors.black,
                                                action: () {
                                                  setState(() {
                                                    tabToShow = "ECOLE";
                                                  });
                                                },
                                              ),
                                              MyButtonWidget(
                                                text: "Nos Filières",
                                                showShadow: false,
                                                radiusButton: 10,
                                                backColor: tabToShow == "FILIERES"
                                                    ? ConstantColor.accentColor.withOpacity(0.1)
                                                    : Colors.black.withOpacity(0.1),
                                                textColor: tabToShow == "FILIERES"
                                                    ? ConstantColor.accentColor
                                                    : Colors.black,
                                                action: () {
                                                  setState(() {
                                                    tabToShow = "FILIERES";
                                                  });
                                                },
                                              )
                                            ],
                                          ),
                                        ),*/
                                  ],
                                ),
                              ),
                            if (widget.ecole != null)
                              Expanded(
                                  child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      margin: EdgeInsets.symmetric(horizontal: 16),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 16,
                                          ),
                                          MyButtonWidget(
                                            iconData: Icons.keyboard_arrow_left,
                                            rounded: true,
                                            backColor: ConstantColor.accentColor,
                                            iconColor: Colors.white,
                                            action: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                                  child: MyTextWidget(
                                                    text:
                                                        "${widget.ecole != null ? widget.ecole!.nom : "Toutes les filières"}",
                                                    textAlign: TextAlign.center,
                                                    theme: BASE_TEXT_THEME.TITLE,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: _blocFiliereList(tabToShow: "ECOLE", hideEntrepriseDetailHeader: true)),
                                  ],
                                ),
                              )),
                            if (widget.ecole == null)
                              Expanded(
                                  child: Column(
                                children: [
                                  Expanded(child: _blocFiliereList(tabToShow: "FILIERES")),
                                ],
                              )),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: widget.ecole == null
                            ? ListView(
                                children: [
                                  _blocFilterList(),
                                ],
                              )
                            : Column(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          color: ConstantColor.accentColor, borderRadius: BorderRadius.circular(15)),
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                      margin: EdgeInsets.only(top: 16),
                                      child: MyTextWidget(
                                        text: "Nos filières",
                                        textColor: Colors.white,
                                      )),
                                  Expanded(child: _blocFiliereList(tabToShow: "FILIERES")),
                                ],
                              ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        smallScreen: Column(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  MyButtonWidget(
                    iconData: Icons.keyboard_arrow_left,
                    rounded: true,
                    backColor: ConstantColor.accentColor,
                    iconColor: Colors.white,
                    action: () {
                      Navigator.pop(context);
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          child: MyTextWidget(
                            text: "${widget.ecole != null ? widget.ecole!.nom : "Toutes les filières"}",
                            textAlign: TextAlign.center,
                            theme: BASE_TEXT_THEME.TITLE,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.ecole == null)
                    MyTextInputWidget(
                      textController: searchController,
                      leftIcon: Icons.search,
                      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      radius: 90,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  if (widget.ecole != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyButtonWidget(
                            text: "L'école",
                            radiusButton: 10,
                            showShadow: false,
                            backColor: tabToShow == "ECOLE"
                                ? ConstantColor.accentColor.withOpacity(0.1)
                                : Colors.black.withOpacity(0.1),
                            textColor: tabToShow == "ECOLE" ? ConstantColor.accentColor : Colors.black,
                            action: () {
                              setState(() {
                                tabToShow = "ECOLE";
                              });
                            },
                          ),
                          MyButtonWidget(
                            text: "Nos Filières",
                            showShadow: false,
                            radiusButton: 10,
                            backColor: tabToShow == "FILIERES"
                                ? ConstantColor.accentColor.withOpacity(0.1)
                                : Colors.black.withOpacity(0.1),
                            textColor: tabToShow == "FILIERES" ? ConstantColor.accentColor : Colors.black,
                            action: () {
                              setState(() {
                                tabToShow = "FILIERES";
                              });
                            },
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
            //if (widget.ecole == null) EntrepriseDetailsPage(entreprise: widget.ecole!),
            Expanded(child: _blocFiliereList(tabToShow: tabToShow, hideEntrepriseDetailHeader: true)),
          ],
        ),
      )),
    );
  }

  Widget _blocFiliereList({required String tabToShow, bool hideEntrepriseDetailHeader = true}) {
    return Column(
      children: [
        if (tabToShow == "ECOLE")
          Expanded(
              child: EntrepriseDetailsPage(
            backgroundColor: Colors.transparent,
            entreprise: selectedEcole!,
            hideHeader: hideEntrepriseDetailHeader,
          )),
        if (tabToShow == "FILIERES" || tabToShow == '')
          Expanded(
            child: SchoolFilieresListWidget(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                backColor: Colors.transparent,
                key: ValueKey<String>(
                    "${filteredFilieresList.toString()}${selectedCategorieEcole.id.toString()}${selectedEcole != null ? selectedEcole!.id.toString() : ""}"),
                canAddItem: false,
                //showSearchBar: true,
                ecole: selectedEcole,
                showItemAsCard: true,
                list: filieresListSoucre.isNotEmpty ? filteredFilieresList : null,
                onListLoaded: (filiereList) {
                  setState(() {
                    filieresListSoucre.addAll(filiereList);
                  });
                }),
          ),
      ],
    );
  }

  Widget _blocFilterList() {
    return MyCardWidget(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 8),
              height: 49,
              child: SousCategorieEntrepriseListWidget(
                selectedCategorie: categorieEducation,
                firstSousCategorieEntrepriseeInList: SousCategorieEntreprise(nom: "Tous les types"),
                showAsDropDown: true,
                onItemPressed: (selectedSousCategorie) {
                  //selectedCategorieEcole.id_categorie_entreprise = categorieEducation.id!;
                  selectedCategorieEcole = selectedSousCategorie;
                  selectedEcole = null;
                  setState(() {});
                },
              ),
            ),
            if (selectedCategorieEcole.id != null)
              Container(
                margin: EdgeInsets.only(left: 8),
                height: 48,
                child: EntrepriseListWidget(
                  key: ValueKey<String>(selectedCategorieEcole.toString()),
                  showAsDropDown: true,
                  firstEntrepriseeInList: Entreprise(nom: "Toutes les écoles"),
                  sousCategorieEntreprise: selectedCategorieEcole,
                  onItemPressed: (ecole) {
                    setState(() {
                      selectedEcole = ecole;
                    });
                  },
                ),
              ),
            Divider(),
            MyTextInputWidget(
              textController: searchController,
              leftIcon: Icons.search,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              hint: "Rechercher",
            ),
          ],
        ),
      ),
    );
  }
}
