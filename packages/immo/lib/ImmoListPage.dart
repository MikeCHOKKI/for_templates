import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/objet/Users.dart';
import 'package:core/pages/objet_list/EntrepriseListWidget.dart';
import 'package:flutter/material.dart';

class ImmoListPage extends StatefulWidget {
  final BuildContext? homeContext;
  final Users? userConnected;
  bool? showByProximity, isAdvancedSearch, showCountStack;
  final String theme;
  final String? id_categorie, id_sous_categorie;
  final FocusNode? focusOnSearch;
  final AppBar? appBar;
  ImmoListPage({Key? key,
    this.appBar,
    this.userConnected,
    this.homeContext,
    this.theme = "",
    this.showByProximity = false,
    this.isAdvancedSearch = false,
    this.showCountStack = false,
    this.id_categorie,
    this.id_sous_categorie,
    this.focusOnSearch,}) : super(key: key);

  @override
  State<ImmoListPage> createState() => _ImmoListPageState();
}

class _ImmoListPageState extends State<ImmoListPage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: Container(
      child: Column(
        children: [
          Expanded(
            child: EntrepriseListWidget(
              key: ValueKey<String?>(
                  "${searchController.text}${widget.showByProximity}${widget.isAdvancedSearch}"),
              backColor: Fonctions().isSmallScreen(context)
                  ? ConstantColor.backgroundColor
                  : null,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              themeRecherche: searchController.text,
              homeContext: widget.homeContext,
              showAppBar: false,
              showCountStack: widget.showCountStack,
              isAdvancedSearch: widget.isAdvancedSearch,
              showByProximity: widget.showByProximity,
              id_sous_categorie: widget.id_sous_categorie,
              showSearchBar: true,
            ),
          ),
        ],
      ),
    ),));
  }
}
