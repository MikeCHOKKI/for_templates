import 'package:annuaire/AnnuairePage.dart';
import 'package:annuaire/RubriquesAccueilPage.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyLoadingWidget.dart';
import 'package:core/common_folder/widgets/MyMenuWidgets.dart';
import 'package:core/objet/Users.dart';
import 'package:core/preferences.dart';
import 'package:espace_entreprise/EspaceEntreprise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mdi/mdi.dart';
import 'package:core/pages/objet_list/ActualitesListWidget.dart';

class Home extends StatefulWidget {
  final int currentIndex;
  final Users? userConnected;

  const Home({Key? key, this.userConnected, this.currentIndex = 0}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentMenuItemIndex = 0;
  bool isLoading = false;
  Users? userConnected;

  void getUserConnected() async {
    setState(() {
      isLoading = true;
    });
    final data = await Preferences(skipLocal: false).getUsersListFromLocal(id: widget.userConnected!.id);
    setState(() {
      if (data.isNotEmpty) {
        userConnected = data.single;
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    currentMenuItemIndex = widget.currentIndex;
    if (widget.userConnected != null) {
      if (widget.userConnected!.nom != null) {
        userConnected = widget.userConnected;
      } else {
        getUserConnected();
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DrawerItem> menuItems = [
      DrawerItem(
          iconData: Icons.home_sharp,
          name: "Accueil",
          page: RubriquesAccueilPage(
            userConnected: userConnected,
            homeContext: context,
          ),
          visible: true),
      DrawerItem(
          iconData: Mdi.cardAccountPhone,
          name: "Annuaire",
          page: AnnuairePage(
            homeContext: context,
            userConnected: userConnected,
          ),
          visible: true),
      DrawerItem(
          iconData: Icons.newspaper_sharp,
          name: "Actualités",
          page: ActualiteListWidget(
            homeContext: context,
            userConnected: userConnected,
            showSearchBar: true,
          ),
          visible: true),
      DrawerItem(
          iconData: Mdi.officeBuilding,
          name: "Espace Entreprise",
          page: EspaceEntreprisePage(
            menuHomeContext: context,
            userConnected: userConnected,
          ),
          visible: true),
    ];
    return Scaffold(
      drawer: Fonctions().isSmallScreen(context)
          ? MyMenuWidget(
              currentIndex: currentMenuItemIndex,
              iconNonActiveColor: ConstantColor.secondColor,
              textStyles: Styles().getDefaultTextStyle(color: ConstantColor.secondColor),
              itemList: menuItems,
              customHeader: DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyImageModel(
                        margin: const EdgeInsets.all(24),
                        height: 100,
                        width: 100,
                        urlImage: "assets/images/ic_buzup.png",
                      ),
                    ],
                  ),
                ),
              ),
              onTap: (index) {
                Fonctions().openPageToGo(
                  contextPage: context,
                  replacePage: true,
                  pageToGo: Home(
                    currentIndex: currentMenuItemIndex,
                    userConnected: widget.userConnected,
                  ),
                );
                setState(() {
                  currentMenuItemIndex = index;
                });
              },
            )
          : null,
      body: Row(
        children: [
          if (isLoading) Expanded(child: Center(child: MyLoadingWidget())),
          if (!Fonctions().isSmallScreen(context) && !isLoading)
            Container(
              width: 300,
              child: MyMenuWidget(
                currentIndex: currentMenuItemIndex,
                iconNonActiveColor: ConstantColor.secondColor,
                textStyles: Styles().getDefaultTextStyle(color: ConstantColor.secondColor),
                itemList: menuItems,
                customHeader: DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  child: Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyImageModel(
                          margin: const EdgeInsets.all(24),
                          height: 100,
                          width: 100,
                          urlImage: "assets/images/ic_buzup.png",
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: (index) {
                  Fonctions().openPageToGo(
                    contextPage: context,
                    replacePage: true,
                    pageToGo: Home(
                      currentIndex: currentMenuItemIndex,
                      userConnected: widget.userConnected,
                    ),
                  );
                  setState(() {
                    currentMenuItemIndex = index;
                  });
                },
              ),
            ),
          if (!isLoading)
            Expanded(
                child: Fonctions().getDefaultMaterial(
              home: menuItems[currentMenuItemIndex].page,
              title: 'Buzup Pro',
            ))
        ],
      ),
    );
  }
}
