import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyMotionDelayAnimator.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/objet/Users.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

import 'Home.dart';

class Menu extends StatefulWidget {
  final int currentIndex;
  final Users? userConnected;

  const Menu({Key? key, this.currentIndex = 0, this.userConnected}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Widget drawerHeader() {
    return DrawerHeader(
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
    );
  }

  Widget drawerItem({
    IconData? icon,
    String? text,
    bool isActive = false,
    GestureTapCallback? onTap,
  }) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: MyButtonWidget(
          iconData: icon,
          backColor: Colors.white,
          showShadow: false,
          iconColor: isActive ? ConstantColor.accentColor : ConstantColor.secondColor,
        ),
        title: MyTextWidget(
          text: text!,
          textColor: isActive ? ConstantColor.accentColor : ConstantColor.textColor,
        ),
        trailing: isActive
            ? MyMotionDelayAnimator(
                delay: 2500,
                movementAnimation: MovementEtat.leftToright,
                child: const Icon(
                  Icons.arrow_right_rounded,
                  color: ConstantColor.accentColor,
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 2.0,
      backgroundColor: Colors.white,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 200,
            child: drawerHeader(),
          ),
          drawerItem(
            icon: Icons.home_sharp,
            isActive: widget.currentIndex == 0,
            text: "Accueil",
            onTap: () {
              Fonctions().openPageToGo(
                contextPage: context,
                replacePage: true,
                pageToGo: Home(
                  currentIndex: 0,
                  userConnected: widget.userConnected,
                ),
              );
            },
          ),
          drawerItem(
            icon: Mdi.cardAccountPhone,
            isActive: widget.currentIndex == 1,
            text: "Annuaire",
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => Home(
                    currentIndex: 1,
                    userConnected: widget.userConnected,
                  ),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),
          drawerItem(
            icon: Icons.newspaper_sharp,
            text: "Actualités",
            isActive: widget.currentIndex == 2,
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => Home(
                    currentIndex: 2,
                    userConnected: widget.userConnected,
                  ),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),
          /*drawerItem(
            icon: Icons.shopping_cart,
            text: "Produits",
            isActive: widget.currentIndex == 3,
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => Home(
                    currentIndex: 3,
                    userConnected: widget.userConnected,
                  ),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),*/
          drawerItem(
            icon: Mdi.officeBuilding,
            text: "Espace Entreprise",
            isActive: widget.currentIndex == 3,
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => Home(
                    currentIndex: 3,
                    userConnected: widget.userConnected,
                  ),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
