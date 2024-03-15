import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:flutter/material.dart';

class BusinessDashBoard extends StatefulWidget {
  int selectedPageIndex;
  bool menuCollapsed;

  BusinessDashBoard({Key? key, this.selectedPageIndex = 0, this.menuCollapsed = false}) : super(key: key);

  @override
  State<BusinessDashBoard> createState() => _BusinessDashBoardState();
}

class _BusinessDashBoardState extends State<BusinessDashBoard> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int currentMenuIndex = 0;
/*late MyMenuWidget myMenuWidget;
  List<DrawerItem> menuItemsList = [
    DrawerItem(
        index: 0,
        iconData: Icons.home_outlined,
        name: "Accueil",
        page: PresentationPage(),
        visible: true),
    DrawerItem(
      index: 1,
      iconData: Icons.business,
      name: "Mon entreprise",
      page: EspaceEntreprisePage(),
      visible: true,
    ),
  ];*/

  bool menuCollapsed = false;

  @override
  void initState() {
    currentMenuIndex = widget.selectedPageIndex;
    print("MenuColla ${widget.menuCollapsed}");
    menuCollapsed = widget.menuCollapsed;

    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    /* myMenuWidget = MyMenuWidget(
        orientation: Axis.vertical,
        menuBody: menuItemsList,
        backColor: ConstantColor.blackMalt,
        iconActiveColor: Colors.white,
        iconNonActiveColor: Colors.white30,
        elevation: 1,
        currentIndex: currentMenuIndex,
        textStyles: Styles().getDefaultTextStyle(
            fontSize: 14, fontWeight: FontWeight.w200, color: Colors.white),
        isCollapsed: menuCollapsed,
        onMenuCollapseChange: (collapsed) {
          setState(() {
            menuCollapsed = collapsed;
          });
        },
        customHeader: Container(
          width: double.infinity,
          color: Colors.transparent,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      alignment: Alignment.center,
                      child: Stack(children: [
                        Opacity(
                          child: Image.asset(
                            "assets/images/ic_buzup.png",
                            color: Colors.white,
                            width: 100,
                            height: 100,
                          ),
                          opacity: 1,
                        ),
                        ClipRect(
                            child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 2.0,
                                    sigmaY: 2.0,
                                    tileMode: TileMode.decal),
                                child: Image.asset(
                                  "assets/images/ic_buzup.png",
                                  width: 100,
                                  height: 100,
                                )))
                      ]),
                    ),
                  ),
                ],
              ),
              MyTextWidget(
                text: "Buz'Up Business",
                theme: BASE_TEXT_THEME.TITLE,
              )
            ],
          ),
        ),
        onTap: (item) {
          setState(() {
            currentMenuIndex = item;
            Fonctions().openPageToGo(
                contextPage: context,
                pageToGo: BusinessDashBoard(
                    selectedPageIndex: item, menuCollapsed: menuCollapsed),
                replacePage: true);
          });
        });*/
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        //  drawer: Fonctions().isSmallScreen(context) ? myMenuWidget : null,
        body: Row(
          children: [
            /*if (!Fonctions().isSmallScreen(context))
              Container(color: ConstantColor.blackMalt, child: myMenuWidget),*/
            Expanded(
              child: Stack(
                children: [
                  Fonctions().getDefaultMaterial(
                    //home: menuItemsList[currentMenuIndex].page,
                    theme: theme,
                  ),
                  if (Fonctions().isSmallScreen(context))
                    SizedBox(
                      height: 40,
                      child: AppBar(
                        iconTheme: IconThemeData(color: ConstantColor.accentColor),
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                    ),
                  /*endDrawer: widget.userConnected != null
            ? UserProfileMenu(scaffoldKey: scaffoldKey, context: widget.homeContext, userConnected: widget.userConnected)
            : null,*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
