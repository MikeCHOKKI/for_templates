import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/widgets/MyMenuWidgets.dart';
import 'package:core/pages/objet_list/SchoolFilieresListWidget.dart';
import 'package:espace_entreprise/EspaceEntreprise.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:schools/SchoolFiliereListPage.dart';
import 'package:schools/SchoolHome.dart';

class SchoolDashboard extends StatefulWidget {
  int currentIndex;

  SchoolDashboard({Key? key, required this.currentIndex}) : super(key: key);

  @override
  State<SchoolDashboard> createState() => _SchoolDashboardState();
}

class _SchoolDashboardState extends State<SchoolDashboard> {
  int currentMenuItemIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    currentMenuItemIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DrawerItem> menuItems = [
      DrawerItem(iconData: Icons.home, name: "Accueil", page: SchoolHome(), visible: true),
      DrawerItem(iconData: Icons.school, name: "Ecoles", page: SchoolFiliereListPage(), visible: true),
      DrawerItem(
          iconData: Icons.list,
          name: "Filières",
          page: SchoolFilieresListWidget(
            canAddItem: true,
          ),
          visible: true),
      DrawerItem(iconData: Mdi.officeBuilding, name: "Espace Entreprise", page: EspaceEntreprisePage(), visible: true),
    ];
    MyMenuWidget menuWidget = MyMenuWidget(
        onTap: (index) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SchoolDashboard(currentIndex: currentMenuItemIndex)));
          setState(() {
            currentMenuItemIndex = index;
          });
        },
        currentIndex: currentMenuItemIndex,
        itemList: menuItems);
    return SafeArea(
      child: Row(
        children: [
          if (!Fonctions().isSmallScreen(context)) Container(width: 300, child: menuWidget),
          Expanded(
            child: Fonctions().getDefaultMaterial(
              home: menuItems[currentMenuItemIndex].page,
            ),
          )
        ],
      ),
    );
  }
}
