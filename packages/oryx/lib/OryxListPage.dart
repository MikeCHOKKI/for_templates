import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/objet/Users.dart';
import 'package:core/pages/objet_list/EntrepriseListWidget.dart';
import 'package:flutter/material.dart';

class OryxListPage extends StatefulWidget {
  final BuildContext? homeContext;
  final Users? userConnected;
  bool? showByProximity, isAdvancedSearch, showCountStack;
  final String? id_categorie, id_sous_categorie, theme, title;
  final FocusNode? focusOnSearch;
  final AppBar? appBar;
  OryxListPage({
    Key? key,
    this.appBar,
    this.userConnected,
    this.homeContext,
    this.title,
    this.theme = "",
    this.showByProximity = false,
    this.isAdvancedSearch = false,
    this.showCountStack = false,
    this.id_categorie,
    this.id_sous_categorie,
    this.focusOnSearch,
  }) : super(key: key);

  @override
  State<OryxListPage> createState() => _OryxListPageState();
}

class _OryxListPageState extends State<OryxListPage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: EntrepriseListWidget(
                key: ValueKey<String?>("${searchController.text}${widget.showByProximity}${widget.isAdvancedSearch}"),
                backColor: Fonctions().isSmallScreen(context) ? ConstantColor.backgroundColor : null,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                themeRecherche: widget.theme,
                title: widget.title,
                homeContext: widget.homeContext,
                showAppBar: true,
                showCountStack: widget.showCountStack,
                isAdvancedSearch: widget.isAdvancedSearch,
                showByProximity: widget.showByProximity,
                id_sous_categorie: widget.id_sous_categorie,
                showSearchBar: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
