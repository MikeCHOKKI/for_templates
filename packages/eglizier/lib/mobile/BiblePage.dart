import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyDropDownWidget.dart';
import 'package:core/common_folder/widgets/MyTextInputWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/objet/BibleLivre.dart';
import 'package:core/pages/objet_list/BibleLivreListWidget.dart';
import 'package:core/pages/objet_list/BibleVersetListWidget.dart';
import 'package:flutter/material.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({Key? key}) : super(key: key);

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  BibleLivre? bibleLivre;
  String selectedChapitre = "", theme = "";
  List<String> chapitres = [];
  bool isSearch = false;

  List<String> getChapitre(BibleLivre selectedBibleLivre) {
    final data =
        List<String>.generate(int.parse(selectedBibleLivre.nbr_chapitre!), (counter) => "Chapitre ${counter + 1}");

    setState(() {
      chapitres.addAll(data);
      selectedChapitre = data.first;
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ConstantColor.grisColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    height: 48,
                  ),
                  MyTextWidget(
                    text: "LA BIBLE",
                    theme: BASE_TEXT_THEME.DISPLAY,
                  ),
                  MyTextWidget(
                    text: "Version Louis Second",
                  ),
                  Divider(
                    height: 20,
                    thickness: 0.1,
                  ),
                  SizedBox(
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: BibleLivreListWidget(
                            showAsDropDown: true,
                            backColor: Colors.white,
                            onItemPressed: (selectedBibleLivre) {
                              if (selectedBibleLivre.nbr_chapitre != "0") {
                                setState(() {
                                  bibleLivre = null;
                                  selectedChapitre = "";
                                  chapitres.clear();
                                  setState(() {
                                    bibleLivre = selectedBibleLivre;
                                  });
                                  getChapitre(selectedBibleLivre);
                                });
                              } else {
                                setState(() {
                                  bibleLivre = selectedBibleLivre;
                                  selectedChapitre = "0";
                                });
                              }
                            },
                          ),
                        ),
                        if (isSearch)
                          Expanded(
                            flex: 7,
                            child: SizedBox(
                              height: 50,
                              child: MyTextInputWidget(
                                backColor: Colors.white,
                                hint: "Rechercher...",
                                hintColor: Colors.black,
                                mayCountTextSize: false,
                                radius: 90,
                                maxLines: 1,
                                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                onChanged: (value) {
                                  setState(() {
                                    theme = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        MyButtonWidget(
                          action: () {
                            setState(() {
                              theme = "";
                              isSearch = !isSearch;
                            });
                          },
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          backColor: Colors.black,
                          iconColor: Colors.white,
                          iconData: isSearch ? Icons.close : Icons.search,
                        ),
                        if (!isSearch)
                          if ((selectedChapitre.isNotEmpty && chapitres.isNotEmpty && bibleLivre != null))
                            if (bibleLivre!.id != "0")
                              Expanded(
                                flex: 3,
                                child: MyDropDownWidget(
                                  initialObject: selectedChapitre,
                                  listObjet: chapitres,
                                  onChangedDropDownValue: (value) {
                                    setState(() {
                                      selectedChapitre = value;
                                    });
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (selectedChapitre.isNotEmpty && chapitres.isNotEmpty && bibleLivre != null)
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: BibleVersetListWidget(
                    backColor: Colors.white,
                    key: UniqueKey(),
                    showItemAsCard: true,
                    num_chapitre: selectedChapitre != "0" ? selectedChapitre.split(" ")[1] : "0",
                    num_livre: bibleLivre!.id,
                    theme: theme,
                    isSearch: isSearch,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
