import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyResponsiveWidget.dart';
import 'package:core/common_folder/widgets/MyTextInputWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/objet/Commande.dart';
import 'package:core/objet/GestionnaireEntreprise.dart';
import 'package:core/objet/Users.dart';
import 'package:core/pages/objet_details/CommandeDetailsPage.dart';
import 'package:core/pages/objet_list/CommandeListWidget.dart';
import 'package:core/preferences.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date format
import 'package:split_view/split_view.dart';

class HistoriquesCommandesEntreprisePage extends StatefulWidget {
  final Color? backColor;
  final String? idSelectedEntreprise;
  final BuildContext? homeContext;
  final Users? userConnected;
  final PreferredSizeWidget? appBar;
  final bool? showAppBar;

  HistoriquesCommandesEntreprisePage(
      {Key? key,
      this.homeContext,
      this.idSelectedEntreprise,
      this.userConnected,
      this.backColor,
      this.showAppBar = false,
      this.appBar})
      : super(key: key);

  @override
  State<HistoriquesCommandesEntreprisePage> createState() => _HistoriquesCommandesEntreprisePageState();
}

class _HistoriquesCommandesEntreprisePageState extends State<HistoriquesCommandesEntreprisePage> {
  TextEditingController searchController = TextEditingController();
  TextEditingController dateDebutController = TextEditingController();
  TextEditingController dateFinController = TextEditingController();
  bool isCheckedVueFiltrer = false, isSwitchedStats = false;
  GestionnaireEntreprise selectedGestionnaire = GestionnaireEntreprise(role: "Tous");
  bool isLoading = false;
  List<Commande> commandeList = [];
  Commande? commandeSelected;
  Users vendeur = Users();
  List<double> weightSplitter = [1, 0];

  /* void getList({String id_entreprise = ""}) async {
    setState(() {
      isLoading = true;
    });
    Preferences(skipLocal: true)
        .getCommandeListFromLocal(id_entreprise: id_entreprise)
        .then((value) => {
              setState(() {
                searchController.text = "";
                commandeList.clear();
                commandeList.addAll(value);
                isLoading = false;
              })
            })
        .onError((error, stackTrace) => {
              setState(() {
                isLoading = false;
              })
            });
  }*/

  /*Users mapUsersJson({required String user}) {
    if (user.isNotEmpty) {
      final list = jsonDecode(user);
      List<Users> usersList = list.map((dynamic item) => Users.fromMap(item)).toList();
      vendeur = usersList.first;
    }
  }*/

  /*void mapClientJson({required String client}) {
    if (client.isNotEmpty) {
      final list = jsonDecode(client);
      List<Client> clientList = list.map((dynamic item) => Client.fromMap(item)).toList();
      client = clientList.first;
    }
  }*/

  Future<List<double>> getSplitterWeights() async {
    final splitterWeights = await Preferences.getPrefValueByKey(key: Preferences.PREFS_KEY_SPLITTERWEIGHTS);
    setState(() {
      if (splitterWeights.isNotEmpty && commandeSelected != null) {
        weightSplitter = [double.parse(splitterWeights.split("|")[0]), double.parse(splitterWeights.split("|")[1])];
      } else {
        weightSplitter = commandeSelected == null ? [1, 0] : [0.65, 0.35];
      }
    });
    return weightSplitter;
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
    getSplitterWeights();
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
      resizeToAvoidBottomInset: false,
      appBar: widget.showAppBar == true
          ? widget.appBar != null
              ? widget.appBar
              : Fonctions().defaultAppBar(
                  context: context,
                  titre: "Historiques",
                  iconColor: Theme.of(context).primaryColor,
                  titreColor: Theme.of(context).primaryColor,
                  isNotRoot: true,
                  elevation: 0.0,
                  backgroundColor: Fonctions().isSmallScreen(context) ? Colors.white : ConstantColor.transparentColor)
          : null,
      backgroundColor: widget.backColor,
      body: MyResponsiveWidget(
        largeScreen: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _switchBtnStats(),
                  ],
                ),
              ),
              /* Container(
                height: 70,
                child: Row(
                  children: [
                    */ /* Expanded(
                      child: _gestionnaireEntrepriseBloc(),
                    ),*/ /*
                    Expanded(child: _dateDebutBloc()),
                    Expanded(child: _dateFinBloc()),
                    Expanded(child: _searchBloc()),
                    _switchBtnStats()
                  ],
                ),
              ),*/
              if (isSwitchedStats)
                Container(
                  height: 120,
                  padding: EdgeInsets.symmetric(vertical: 4),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: CardStats(
                          title: "CA DE LA PERIODE",
                          content: "41111111 F CFA",
                          cardColor: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: CardStats(
                            title: "MARGE DE LA PERIODE",
                            content: "41111111 F CFA",
                            cardColor: ConstantColor.accentColor),
                      ),
                      Expanded(
                        child: CardStats(
                          title: "NBR DE VENTE",
                          content: "41",
                          cardColor: ConstantColor.greenSuccessColor,
                        ),
                      )
                    ],
                  ),
                ),
              Expanded(
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
                    print("Horizon: $weights");
                    await Preferences.saveData(
                        key: Preferences.PREFS_KEY_SPLITTERWEIGHTS, response: "${weights[0]}|${weights[1]}");
                  },
                  children: [
                    MyCardWidget(
                      child: _commandeListBloc(),
                    ),
                    if (commandeSelected != null && commandeSelected!.code != null)
                      CommandeDetailsPage(
                        commande: commandeSelected!,
                        key: ValueKey<String>(commandeSelected.toString()),
                      ),
                  ],
                ),
              ),
              /*Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: MyCardWidget(
                        child: _commandeListBloc(),
                      ),
                    ),
                    if (commandeSelected != null &&
                        commandeSelected!.code != null)
                      Expanded(
                        flex: 1,
                        child: CommandeDetailsPage(
                          commande: commandeSelected!,
                          key: ValueKey<String>(commandeSelected.toString()),
                        ),
                      ),
                  ],
                ),
              )*/
            ],
          ),
        ),
        smallScreen: _smallScreen(),
      ),
    );
  }

  Widget _switchBtnStats({Key? key}) {
    return SizedBox(
      height: 35,
      child: Row(
        children: [
          Switch(
            value: isSwitchedStats,
            activeColor: ConstantColor.accentColor,
            onChanged: (bool switchValue) async {
              setState(() {
                isSwitchedStats = !isSwitchedStats;
              });
            },
          ),
          Container(
            child: MyTextWidget(
              text: "Afficher les stats",
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallScreen() {
    return Column(
      children: [
        Expanded(child: _commandeListBloc()),
      ],
    );
  }

  Widget _commandeListBloc({Key? key}) {
    return CommandeListWidget(
      showAppBar: false,
      idSelectedEntreprise: widget.idSelectedEntreprise,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      backColor: Fonctions().isSmallScreen(context) ? null : Colors.white,
      showItemAsCard: false,
      showSearchBar: true,
      showDateDebut: true,
      showDateFin: true,
      canDeleteItem: true,
      onItemPressed: (valueFacture) async {
        setState(() {
          commandeSelected = valueFacture;
          if (Fonctions().isSmallScreen(context)) {
            Fonctions().openPageToGo(
              contextPage: context,
              pageToGo: CommandeDetailsPage(
                commande: valueFacture,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                showAppBar: true,
              ),
            );
          }
        });
        await getSplitterWeights();
      },
    );
  }

  Widget _searchBloc({Key? key}) {
    return Row(
      children: [
        Expanded(
          child: MyTextInputWidget(
            textController: searchController,
            hint: "Rechercher...",
            //margin: EdgeInsets.symmetric(horizontal: 8),
            backColor: ConstantColor.lightColor,
            radius: 8,
            leftWidget: const Icon(
              Icons.search,
              size: 20,
              color: ConstantColor.grisColor,
            ),
          ),
        ),
        /*SizedBox(
          width: 100,
          child: Row(
            children: [
              Expanded(
                child: MyCheckboxWidget(
                  isChecked: isCheckedVueFiltrer,
                  switchChecked: (bool? value) {
                    setState(() {
                      isCheckedVueFiltrer = value!;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 70,
                child: MyTextWidget(
                  text: "Vue filtrée",
                ),
              ),
            ],
          ),
        ),*/
      ],
    );
  }

  Widget _dateDebutBloc({Key? key}) {
    return MyTextInputWidget(
      textController: dateDebutController,
      isDate: true,
      backColor: ConstantColor.lightColor,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      leftWidget: MyTextWidget(
        text: "Du",
      ),
      hint: "${DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(Duration(days: 1)))}",
    );
  }

  Widget _dateFinBloc({Key? key}) {
    return MyTextInputWidget(
      textController: dateFinController,
      backColor: ConstantColor.lightColor,
      padding: EdgeInsets.symmetric(horizontal: 8),
      leftWidget: MyTextWidget(
        text: "Au",
      ),
      isDate: true,
      hint: "${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
    );
  }
}

class CardStats extends StatelessWidget {
  final String title;
  final String content;
  final Color? cardColor;
  final Color? textColor;

  const CardStats({Key? key, required this.title, this.content = "0", this.cardColor, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyCardWidget(
      cardColor: cardColor,
      borderColor: cardColor,
      elevation: 2,
      child: Column(
        children: [
          Container(
            child: MyTextWidget(
              text: title,
              theme: BASE_TEXT_THEME.TITLE,
              textColor: textColor ?? Colors.white,
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),
          Container(
            child: MyTextWidget(
              text: content,
              theme: BASE_TEXT_THEME.TITLE,
              textColor: textColor ?? Colors.white,
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),
        ],
      ),
    );
  }
}
