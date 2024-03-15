import 'package:annuaire/AnnuairePage.dart';
import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyExpandableWidget.dart';
import 'package:core/common_folder/widgets/MyMediaWidget.dart';
import 'package:core/common_folder/widgets/MyMenuWidgets.dart';
import 'package:core/common_folder/widgets/MyResponsiveWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/objet/EntreeSortie.dart';
import 'package:core/objet/Entreprise.dart';
import 'package:core/objet/Users.dart';
import 'package:core/pages/objet_details/EntreeSortieDetailsPage.dart';
import 'package:core/pages/objet_list/CommandeListWidget.dart';
import 'package:core/pages/objet_list/EntreeSortieListWidget.dart';
import 'package:core/pages/objet_list/ServicesListWidget.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'ClientsEntrepriseListPage.dart';
import 'FacturierEntreprisePage.dart';
import 'HistoriquesCommandesPage.dart';
import 'ProduitsBoutiquePage.dart';

class BoutiquierDashboard extends StatefulWidget {
  final int selectedPageIndex;
  final bool menuCollapsed;
  final String? idSelectedEntreprise;
  final Entreprise entreprise;
  final Users connectedUser;

  const BoutiquierDashboard(
      {Key? key,
      this.idSelectedEntreprise,
      required this.entreprise,
      required this.connectedUser,
      this.selectedPageIndex = 0,
      this.menuCollapsed = false})
      : super(key: key);

  @override
  State<BoutiquierDashboard> createState() => _BoutiquierDashboardState();
}

class _BoutiquierDashboardState extends State<BoutiquierDashboard> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int currentMenuIndex = 0;
  bool menuCollapsed = false;
  Entreprise entreprise = Entreprise();
  EntreeSortie? selectedEntreeSortie;
  String? idSelectedEntreprise;
  List<DrawerItem> menuItemsList = [];
  Widget pageToShow = Container();
  bool mayShowChildAppBar = true;

  void initPage() {
    setState(() {
      pageToShow = ProduitsBoutiquePage(
        showAppBar: mayShowChildAppBar,
        idSelectedEntreprise: idSelectedEntreprise,
      );
    });
    menuItemsList.add(DrawerItem(
        iconData: FluentIcons.box_20_regular,
        name: "Gestion des produits",
        visible: true,
        submenu: [DrawerItem(iconData: Icons.add, name: "Ajouter", visible: true)],
        page: ProduitsBoutiquePage(
          showAppBar: mayShowChildAppBar,
          idSelectedEntreprise: idSelectedEntreprise,
        )));
    menuItemsList.add(DrawerItem(
        iconData: FluentIcons.service_bell_16_regular,
        name: "Gestion des services",
        visible: true,
        page: ServicesListWidget(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          showAppBar: mayShowChildAppBar,
          idSelectedEntreprise: idSelectedEntreprise,
          canAddItem: true,
          canRefresh: true,
          canEditItem: true,
          canDeleteItem: true,
          showAsGridView: true,
        )));
    menuItemsList.add(DrawerItem(
        iconData: FluentIcons.note_20_regular,
        name: "Faire une facture",
        visible: true,
        page: FacturierEntreprisePage(
          entreprise: entreprise,
          userConnected: widget.connectedUser,
          showAppBar: mayShowChildAppBar,
        )));
    menuItemsList.add(DrawerItem(
        iconData: FluentIcons.history_24_regular,
        name: "Historique des ventes",
        visible: true,
        page: HistoriquesCommandesEntreprisePage(
          showAppBar: mayShowChildAppBar,
        )));
    menuItemsList.add(DrawerItem(
        iconData: FluentIcons.person_20_regular,
        name: "Annuaire des clients",
        visible: true,
        page: ClientsEntrepriseListPage(
          entreprise: widget.entreprise,
          showAppBar: mayShowChildAppBar,
        )));
    menuItemsList.add(DrawerItem(
      iconData: FluentIcons.building_20_regular,
      name: "Trouver des fournisseurs",
      visible: true,
      page: AnnuairePage(),
    ));
  }

  void openPage() {
    if (Fonctions().isSmallScreen(context)) Fonctions().openPageToGo(contextPage: context, pageToGo: pageToShow);
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsFlutterBinding.ensureInitialized();
    entreprise = widget.entreprise ?? Entreprise();
    idSelectedEntreprise = widget.idSelectedEntreprise;
    currentMenuIndex = widget.selectedPageIndex;
    menuCollapsed = widget.menuCollapsed;

    super.initState();

    initPage();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
      endDrawer: Fonctions().isMediumScreen(context) ? _boutiqueOptionsBlocAsMenu() : null,
      body: MyResponsiveWidget(
        largeScreen: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: pageToShow),
            _boutiqueOptionsBlocAsMenu(),
          ],
        ),
        mediumScreen: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Spacer(),
                  InkWell(
                    child: Icon(
                      Icons.menu,
                      size: 16,
                    ),
                    onTap: () {
                      setState(() {
                        scaffoldKey.currentState!.openEndDrawer();
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: pageToShow,
            ),
          ],
        ),
        smallScreen: SingleChildScrollView(
          child: Column(
            children: [
              _statsBloc(),
              MyCardWidget(
                child: MyExpandableWidget(
                  child: _boutiqueOptionsBlocAsList(),
                  title: 'Gestion de la boutique',
                  isExpanded: true,
                ),
              ),
              MyCardWidget(
                child: CommandeListWidget(
                  physics: NeverScrollableScrollPhysics(),
                  showAppBar: false,
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.only(
                    top: 16,
                  ),
                  maxItem: 5,
                  //canRefresh: false,
                  backColor: Colors.white,
                  showItemAsCard: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _boutiqueOptionsBlocAsMenu() {
    return MyMenuWidget(
        headerHeight: 100,
        isCollapsed: true,
        customHeader: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyMediaWidget(
              width: 72,
              height: 72,
              backgroundColor: Colors.white,
              urlImage: entreprise.img_logo_link!.isNotEmpty
                  ? entreprise.img_logo_link
                  : "https://${ConstantUrl.urlServer}${ConstantUrl.logoEntrepriseBase}${entreprise!.id_sous_categorie}.jpg",
              /* isEditable: entreprise!.img_logo_link!.isEmpty &&
                widget.userConnected != null &&
                widget.userConnected!.id == widget.entreprise.id,*/
              fit: BoxFit.contain,
              showButtonToSend: true,
            ),
          ],
        ),
        itemList: menuItemsList,
        backColor: ConstantColor.lightColor,
        onTap: (index) {
          setState(() {
            pageToShow = menuItemsList[index].page!;
          });
        });
  }

  Widget _boutiqueOptionsBlocAsList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return buzupMoreServiceCard(
            title: menuItemsList[index].name,
            icon: menuItemsList[index].iconData,
            action: () {
              setState(() {
                pageToShow = menuItemsList[index].page!;
                openPage();
              });
            });
      },
      itemCount: menuItemsList.length,
      primary: false,
      shrinkWrap: true,
    );
  }

  /*

      ],
    );
  }
*/

  Widget _statsBloc({Key? key}) {
    return MyCardWidget(
      child: GridView(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200, mainAxisExtent: 56, mainAxisSpacing: 4, crossAxisSpacing: 4),
        primary: false,
        shrinkWrap: true,
        children: [
          Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_circle_down,
                  color: ConstantColor.greenSuccessColor,
                  size: 24,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextWidget(
                      text: "Total des entrées",
                      theme: BASE_TEXT_THEME.BODY_SMALL,
                    ),
                    MyTextWidget(
                      text: "2000000 F CFA",
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_circle_up,
                  color: ConstantColor.redErrorColor,
                  size: 24,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextWidget(
                      text: "Total des sorties",
                      theme: BASE_TEXT_THEME.BODY_SMALL,
                    ),
                    MyTextWidget(
                      text: "2000000 F CFA",
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_circle_up,
                  color: ConstantColor.redErrorColor,
                  size: 24,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextWidget(
                      text: "Total des sorties",
                      theme: BASE_TEXT_THEME.BODY_SMALL,
                    ),
                    MyTextWidget(
                      text: "2000000 F CFA",
                    ),
                  ],
                )
              ],
            ),
          ),
          /*MyCardWidget(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_circle_up,
                  color: ConstantColor.redErrorColor,
                  size: 24,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextWidget(
                      text: "Total des sorties",
                      theme: BASE_TEXT_THEME.BODY_SMALL,
                    ),
                    MyTextWidget(
                      text: "2000000 F CFA",
                    ),
                  ],
                )
              ],
            ),
          ),*/
        ],
      ),
    );
  }

  Widget buzupMoreServiceCard(
      {String? title,
      String? description,
      IconData? icon,
      Color? iconBackColor,
      Color? cardBackColor,
      Color? btBackColor,
      Color? btTextColor,
      TextStyle? titleStyle,
      TextStyle? descriptionStyle,
      String? btText,
      Function? action}) {
    return InkWell(
      onTap: () {
        if (action != null) action();
      },
      child: Fonctions().isSmallScreen(context)
          ? Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(8),
                  child: Icon(
                    icon,
                    color: ConstantColor.accentColor,
                  ),
                ),
                if (title != null)
                  MyTextWidget(
                    text: title,
                    textAlign: TextAlign.center,
                    theme: BASE_TEXT_THEME.TITLE_SMALL,
                  ),
              ],
            )
          : MyCardWidget(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Container(
                      padding: EdgeInsets.all(24),
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: iconBackColor ?? ConstantColor.blackMalt,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: Fonctions().isSmallScreen(context) ? 24 : 16,
                        color: ConstantColor.lightColor,
                      ),
                    ),
                  if (title != null)
                    MyTextWidget(
                      text: title,
                      textAlign: TextAlign.center,
                      theme: Fonctions().isSmallScreen(context)
                          ? BASE_TEXT_THEME.TITLE_SMALL
                          : BASE_TEXT_THEME.LABEL_SMALL,
                    ),
                ],
              ),
            ),
    );
  }

  Widget _entreeSortieListBloc({Key? key}) {
    return EntreeSortieListWidget(
      showAppBar: Fonctions().isSmallScreen(context),
      showSearchBar: true,
      showItemAsCard: false,
      canAddItem: true,
      canEditItem: true,
      showDateDebut: true,
      showDateFin: true,
      backColor: Fonctions().isSmallScreen(context) ? ConstantColor.backgroundColor : Colors.white,
      idSelectedEntreprise: widget.idSelectedEntreprise,
      padding: EdgeInsets.all(12),
      onItemPressed: (valueEntreeSortie) {
        setState(() {
          selectedEntreeSortie = valueEntreeSortie;
          if (Fonctions().isSmallScreen(context)) {
            Fonctions().openPageToGo(
              contextPage: context,
              pageToGo: EntreeSortieDetailsPage(
                entreesortie: valueEntreeSortie,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                showAppBar: true,
              ),
            );
          }
        });
      },
    );
  }
}
