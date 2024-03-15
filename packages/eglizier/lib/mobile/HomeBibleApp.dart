import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/pages/objet_list/EgliseListWidget.dart';
import 'package:core/pages/objet_list/VersetDuJourListWidget.dart';
import 'package:flutter/material.dart';

import 'BiblePage.dart';

class HomeBibleApp extends StatefulWidget {
  const HomeBibleApp({Key? key}) : super(key: key);

  @override
  State<HomeBibleApp> createState() => _HomeBibleAppState();
}

class _HomeBibleAppState extends State<HomeBibleApp> {
  @override
  Widget build(BuildContext context) {
    DateTime lastTimeBackbuttonWasClicked = DateTime.now();
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (DateTime.now().difference(lastTimeBackbuttonWasClicked) >=
              Duration(seconds: 2)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: MyTextWidget(
                  text: "Appuyez de nouveau pour quitter.",
                ),
                duration: Duration(seconds: 2),
              ),
            );
            lastTimeBackbuttonWasClicked = DateTime.now();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 320,
                  color: ConstantColor.grisColor,
                  child: Center(
                    child: VersetDuJourListWidget(),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      primary: true,
                      shrinkWrap: true,
                      children: <Widget>[
                        MyItemCard(
                          iconData: Icons.location_on,
                          text: "Où prier ?",
                          onTap: () {
                            Fonctions().openPageToGo(
                              contextPage: context,
                              pageToGo: EgliseListWidget(
                                showItemAsCard: true,
                              ),
                            );
                          },
                        ),
                        MyItemCard(
                          iconData: Icons.book_outlined,
                          text: "Bilble",
                          onTap: () {
                            Fonctions().openPageToGo(
                              contextPage: context,
                              pageToGo: BiblePage(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyItemCard extends StatefulWidget {
  final IconData iconData;
  final double iconSize, textSize;
  final String text;
  final Color? backgroundColor,
      borderColor,
      iconColor,
      backgroundTextColor,
      textColor;
  final void Function()? onTap;

  const MyItemCard({
    Key? key,
    required this.iconData,
    this.iconSize = 80,
    this.textSize = 12.0,
    this.iconColor,
    this.text = "",
    this.backgroundColor,
    this.borderColor,
    this.backgroundTextColor,
    this.textColor,
    this.onTap,
  }) : super(key: key);

  @override
  State<MyItemCard> createState() => _MyItemCardState();
}

class _MyItemCardState extends State<MyItemCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          border: Border.all(
            color: widget.borderColor ?? theme.primaryColor,
          ),
        ),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(24),
                    child: Icon(
                      widget.iconData,
                      color: widget.iconColor != null
                          ? widget.iconColor!.withOpacity(0.5)
                          : theme.primaryColor,
                      size: widget.iconSize,
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 8, bottom: 8, left: 24, right: 24),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: widget.backgroundTextColor ?? theme.primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0)),
                ),
                child: MyTextWidget(
                  text: '${widget.text}',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  textColor: widget.textColor ?? Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
