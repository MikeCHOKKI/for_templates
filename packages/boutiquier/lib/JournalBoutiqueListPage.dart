import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/widgets/MyCheckboxWidget.dart';
import 'package:core/common_folder/widgets/MyDropDownWidget.dart';
import 'package:core/common_folder/widgets/MyLoadingWidget.dart';
import 'package:core/common_folder/widgets/MyTextInputWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/objet/JournalBoutique.dart';
import 'package:core/objet/Users.dart';
import 'package:core/pages/objet_list/JournalBoutiqueListWidget.dart';
import 'package:core/preferences.dart';
import 'package:flutter/material.dart';

class JournalBoutiqueListPage extends StatefulWidget {
  final Color? backColor;
  final String? idSelectedEntreprise;
  final BuildContext? homeContext;
  final Users? userConnected;

  JournalBoutiqueListPage({Key? key, this.idSelectedEntreprise, this.homeContext, this.userConnected, this.backColor})
      : super(key: key);

  @override
  State<JournalBoutiqueListPage> createState() => _JournalBoutiqueListPageState();
}

class _JournalBoutiqueListPageState extends State<JournalBoutiqueListPage> {
  String selectedType = "";
  List<String> typeList = ["Tous"];
  bool isLoading = false, isCheckedVueFiltrer = false;
  TextEditingController searchController = TextEditingController();
  TextEditingController dateDebutController = TextEditingController();
  TextEditingController dateFinController = TextEditingController();
  List<JournalBoutique> journalBoutiqueList = [];

  void getList({String id_entreprise = ""}) async {
    setState(() {
      isLoading = true;
    });
    Preferences(skipLocal: true)
        .getJournalBoutiqueListFromLocal(id_entreprise: id_entreprise)
        .then((value) => {
              setState(() {
                searchController.text = "";
                journalBoutiqueList.clear();
                journalBoutiqueList.addAll(value);
                print("journalBoutiqueList: $journalBoutiqueList");
                isLoading = false;
              })
            })
        .onError((error, stackTrace) => {
              setState(() {
                isLoading = false;
              })
            });
  }

  @override
  void dispose() {
    searchController.dispose();
    dateDebutController.dispose();
    dateFinController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    selectedType = typeList.first;
    print("idSelectedEntreprise: ${widget.idSelectedEntreprise}");
    if (widget.idSelectedEntreprise != null) {
      getList(id_entreprise: widget.idSelectedEntreprise!);
    }
    searchController.addListener(() {
      setState(() {
        //themeRecherche = searchController.text;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Fonctions().defaultAppBar(
          context: context,
          titre: "Journal de bord",
          iconColor: ConstantColor.accentColor,
          titreColor: ConstantColor.accentColor,
          isNotRoot: true,
          elevation: 0.0,
          backgroundColor: Fonctions().isSmallScreen(context) ? Colors.white : ConstantColor.transparentColor),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            if (!Fonctions().isSmallScreen(context)) _largeScreenFilter(),
            if (Fonctions().isSmallScreen(context)) _smallScreenFilter(),
            if (isLoading) Expanded(child: Center(child: MyLoadingWidget())),
            if (!isLoading)
              Expanded(
                  child: JournalBoutiqueListWidget(
                list: journalBoutiqueList,
                showItemAsCard: false,
                backColor: Fonctions().isLargeScreen(context) ? Colors.white : null,
                showSelected: true,
              ))
          ],
        ),
      ),
    );
  }

  Widget _largeScreenFilter({Key? key}) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Container()),
            SizedBox(
              width: 100,
              child: Row(
                children: [
                  MyCheckboxWidget(
                    isChecked: isCheckedVueFiltrer,
                    switchChecked: (bool? value) {
                      setState(() {
                        isCheckedVueFiltrer = value!;
                      });
                    },
                  ),
                  SizedBox(
                    width: 60,
                    child: MyTextWidget(
                      text: "Vue filtrée",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 34,
                    child: MyTextWidget(
                      text: "Type",
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: MyDropDownWidget(
                        initialObject: selectedType,
                        listObjet: typeList,
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        margin: EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        onChangedDropDownValue: (value) {
                          setState(() {
                            selectedType = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (Fonctions().isLargeScreen(context))
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: MyTextWidget(
                        text: "DU",
                      ),
                    ),
                    Expanded(
                      child: MyTextInputWidget(
                        textController: dateDebutController,
                        isDate: true,
                        hintLabel: "date debut",
                      ),
                    ),
                    SizedBox(
                      width: 20,
                      child: MyTextWidget(
                        text: "AU",
                      ),
                    ),
                    Expanded(
                      child: MyTextInputWidget(
                        textController: dateFinController,
                        isDate: true,
                        hintLabel: "date fin",
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: MyTextInputWidget(
                textController: searchController,
                hint: "Rechercher...",
                margin: EdgeInsets.symmetric(horizontal: 8),
                radius: 8,
                border:
                    Border.all(width: 1.0, color: ConstantColor.grisColor, strokeAlign: BorderSide.strokeAlignInside),
                leftWidget: const Icon(
                  Icons.search,
                  size: 20,
                  color: ConstantColor.primaryColor,
                ),
              ),
            ),
          ],
        ),
        if (Fonctions().isMediumScreen(context))
          Row(
            children: [
              SizedBox(
                width: 20,
                child: MyTextWidget(
                  text: "DU",
                ),
              ),
              Expanded(
                child: MyTextInputWidget(
                  textController: dateDebutController,
                  isDate: true,
                  hintLabel: "date debut",
                ),
              ),
              SizedBox(
                width: 20,
                child: MyTextWidget(
                  text: "AU",
                ),
              ),
              Expanded(
                child: MyTextInputWidget(
                  textController: dateFinController,
                  isDate: true,
                  hintLabel: "date fin",
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _smallScreenFilter({Key? key}) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Container()),
            SizedBox(
              width: 100,
              child: Row(
                children: [
                  MyCheckboxWidget(
                    isChecked: isCheckedVueFiltrer,
                    switchChecked: (bool? value) {
                      setState(() {
                        isCheckedVueFiltrer = value!;
                      });
                    },
                  ),
                  SizedBox(
                    width: 60,
                    child: MyTextWidget(
                      text: "Vue filtrée",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        MyTextInputWidget(
          textController: searchController,
          hint: "Rechercher...",
          margin: EdgeInsets.symmetric(horizontal: 8),
          radius: 8,
          border: Border.all(width: 1.0, color: ConstantColor.grisColor, strokeAlign: BorderSide.strokeAlignInside),
          leftWidget: const Icon(
            size: 20,
            Icons.search,
            color: ConstantColor.primaryColor,
          ),
        ),
        if (Fonctions().isMediumScreen(context))
          Row(
            children: [
              SizedBox(
                width: 20,
                child: MyTextWidget(
                  text: "DU",
                ),
              ),
              Expanded(
                child: MyTextInputWidget(
                  textController: dateDebutController,
                  isDate: true,
                  hintLabel: "date debut",
                ),
              ),
              SizedBox(
                width: 20,
                child: MyTextWidget(
                  text: "AU",
                ),
              ),
              Expanded(
                child: MyTextInputWidget(
                  textController: dateFinController,
                  isDate: true,
                  hintLabel: "date fin",
                ),
              ),
            ],
          ),
        Row(
          children: [
            SizedBox(
              width: 20,
              child: MyTextWidget(
                text: "DU",
              ),
            ),
            Expanded(
              child: MyTextInputWidget(
                textController: dateDebutController,
                isDate: true,
                hintLabel: "date debut",
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 20,
              child: MyTextWidget(
                text: "AU",
              ),
            ),
            Expanded(
              child: MyTextInputWidget(
                textController: dateFinController,
                isDate: true,
                hintLabel: "date fin",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
