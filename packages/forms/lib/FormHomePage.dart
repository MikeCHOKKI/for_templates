import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyMotionDelayAnimator.dart';
import 'package:core/common_folder/widgets/MyResponsiveWidget.dart';
import 'package:flutter/material.dart';
import 'package:forms/CreateFormPage.dart';
import 'package:forms/FormsListPage.dart';

class FormHomePage extends StatefulWidget {
  const FormHomePage({Key? key}) : super(key: key);

  @override
  State<FormHomePage> createState() => _FormHomePageState();
}

class _FormHomePageState extends State<FormHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: MyResponsiveWidget(
          largeScreen: VueLargeScreen(),
          smallScreen: VueSmallScreen(),
          mediumScreen: VueLargeScreen(),
        ),
      ),
    );
  }
}

class VueLargeScreen extends StatefulWidget {
  const VueLargeScreen({Key? key}) : super(key: key);

  @override
  State<VueLargeScreen> createState() => _VueLargeScreenState();
}

class _VueLargeScreenState extends State<VueLargeScreen> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      allowImplicitScrolling: true,
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/cover_home1.jpg",
              ),
              opacity: 0.25,
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Image.asset(
                    "assets/images/form_assets.png",
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      MyMotionDelayAnimator(
                        delay: 1500,
                        inMillisecond: true,
                        movementAnimation: MovementEtat.downToup,
                        child: Container(
                          child: RichText(
                            text: TextSpan(
                              text:
                                  "Créez un formulaire en ligne pour votre entreprise votre école votre service grâce à\n",
                              style: Styles().getDefaultTextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                              children: <InlineSpan>[
                                WidgetSpan(
                                  child: MyMotionDelayAnimator(
                                    delay: 2500,
                                    inMillisecond: true,
                                    movementAnimation: MovementEtat.downToup,
                                    child: Row(
                                      children: [
                                        MyImageModel(
                                          margin: const EdgeInsets.all(8),
                                          height: 36,
                                          width: 36,
                                          urlImage: "assets/images/ic_buzup.png",
                                        ),
                                        RichText(
                                          text: TextSpan(
                                              text: "Buzup",
                                              style: Styles().getDefaultFieldTitle(
                                                fontSize: 18,
                                                color: ConstantColor.accentColor,
                                                fontWeight: FontWeight.w200,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: "Forms",
                                                  style: Styles().getDefaultTextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w900,
                                                    height: 1,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          MyButtonWidget(
                            text: "  Créer un formulaire",
                            iconData: Icons.arrow_forward_outlined,
                            backColor: Colors.transparent,
                            textColor: ConstantColor.accentColor,
                            showShadow: false,
                            action: () {
                              setState(() {});
                              Fonctions().openPageToGo(
                                contextPage: context,
                                pageToGo: CreateFormPage(),
                              );
                            },
                          ),
                          SizedBox(width: 25.0),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: RotatedBox(
            quarterTurns: -1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/cover_home1.jpg",
                  ),
                  opacity: 0.25,
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                ),
              ),
              child: RotatedBox(
                quarterTurns: 1,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            MyMotionDelayAnimator(
                              delay: 1500,
                              inMillisecond: true,
                              movementAnimation: MovementEtat.downToup,
                              child: Container(
                                child: RichText(
                                  text: TextSpan(
                                    text:
                                        "Examinez les graphiques et résulats mis à jour en temps réel avec les réponses recueillies.\n",
                                    style: Styles().getDefaultTextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                MyButtonWidget(
                                  text: "  Mes formulaires",
                                  iconData: Icons.arrow_back_outlined,
                                  backColor: Colors.transparent,
                                  textColor: ConstantColor.accentColor,
                                  showShadow: false,
                                  action: () {
                                    setState(() {});
                                    Fonctions().openPageToGo(
                                      contextPage: context,
                                      pageToGo: FormListPage(),
                                    );
                                  },
                                ),
                                SizedBox(width: 25.0),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Image.asset(
                          "assets/images/form_assets2.png",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class VueSmallScreen extends StatefulWidget {
  const VueSmallScreen({Key? key}) : super(key: key);

  @override
  State<VueSmallScreen> createState() => _VueSmallScreenState();
}

class _VueSmallScreenState extends State<VueSmallScreen> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      allowImplicitScrolling: true,
      scrollDirection: Axis.vertical,
      children: <Widget>[],
    );
  }
}
