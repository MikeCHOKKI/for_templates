import 'package:annuaire/AnnuaireHome.dart';
import 'package:annuaire/AnnuairePage.dart';
import 'package:core/PwaLink.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyResponsiveWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/pages/objet_list/ActualitesListWidget.dart';
import 'package:core/pages/objet_list/ProduitListWidget.dart';
import 'package:eservice_prive/EserviceHome.dart';
import 'package:espace_entreprise/EspaceEntreprise.dart';
import 'package:flash_note/FlashNoteHome.dart';
import 'package:flutter/material.dart';
import 'package:oryx/OryxHomePage.dart';
import 'package:ou_suis_je/OuSuisJeHomePage.dart';
import 'package:pharmacie/PharmacieHomePage.dart';
import 'package:schools/SchoolHome.dart';

class PresentationPage extends StatefulWidget {
  final AppBar? appBar;

  PresentationPage({Key? key, this.appBar}) : super(key: key);

  @override
  State<PresentationPage> createState() => _PresentationPageState();
}

class _PresentationPageState extends State<PresentationPage> with SingleTickerProviderStateMixin {
  int selectedPage = 0;
  int currentMenuIndex = 0;
  PageController controller = PageController(initialPage: 0);

  void moveToNextSection() {
    setState(() {
      selectedPage++;
      controller.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInExpo);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Fonctions().isSmallScreen(context)
            ? widget.appBar ??
                Fonctions().defaultAppBar(
                    context: context,
                    tailleAppBar: 56,
                    elevation: 0,
                    // homeContext: widget.menuHomeContext,
                    //object: userConnectedInfos,
                    //scaffoldKey: scaffoldKey,
                    //showAccount: true,
                    titleWidget: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              MyImageModel(
                                urlImage: "assets/images/ic_buzup.png",
                                margin: EdgeInsets.zero,
                                fit: BoxFit.contain,
                                size: 36,
                              ),
                              MyTextWidget(
                                text: "Buz'Up",
                                theme: BASE_TEXT_THEME.TITLE_LARGE,
                                textColor: ConstantColor.blackMalt,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    actionWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyButtonWidget(
                          text: "Espace Entreprise",
                          margin: EdgeInsets.only(right: 24),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          action: () {
                            Fonctions().openPageToGo(contextPage: context, pageToGo: EspaceEntreprisePage());
                          },
                        ),
                      ],
                    ))
            : null,
        drawer: null,
        body: MyResponsiveWidget(
          smallScreen: SmallScreenView(),
          largeScreen: Container(
              child: PageView(
            scrollDirection: Axis.vertical,
            controller: controller,
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "assets/images/global_home_back.jpg",
                        ),
                        fit: BoxFit.cover)),
                child: Container(
                  color: Colors.white.withOpacity(0.8),
                  child: Column(
                    children: [
                      Container(
                        height: 72,
                        padding: EdgeInsets.symmetric(horizontal: 80),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Spacer(),
                            MyImageModel(
                              urlImage: "assets/images/ic_buzup.png",
                            ),

                            MyTextWidget(
                              text: "Buz'Up",
                              theme: BASE_TEXT_THEME.HEADLINE_SMALL,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              constraints: BoxConstraints(maxWidth: 800),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MyTextWidget(
                                        text: "Passons votre entreprise à un autre niveau",
                                        theme: BASE_TEXT_THEME.DISPLAY,
                                        textColor: ConstantColor.accentColor,
                                        /* style: Styles().getDefaultFieldTitle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.w900,
                                            height: 1,
                                            color: ConstantColor.accentColor),*/
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(vertical: 24),
                                        child: MyTextWidget(
                                          text:
                                              "Bienvenue sur Buz'Up. Ici nous avons réunis tous les services utiles à la prospérité de votre entreprise. Améliorez votre façons de communiquer et de gérer le quotidien de votre entreprise ",
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                moveToNextSection();
                                              },
                                              icon: Icon(
                                                Icons.arrow_downward,
                                                color: ConstantColor.accentColor,
                                                size: 48,
                                              )),
                                        ],
                                      )
                                    ],
                                  )),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      MyImageModel(
                                        urlImage: 'assets/images/global_home_img.png',
                                        fit: BoxFit.cover,
                                        size: 500,
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: ConstantColor.accentColor.withOpacity(0.9),
                child: Stack(
                  children: [
                    Positioned(
                      right: 40,
                      top: 200,
                      child: Transform.rotate(
                        angle: 40,
                        child: Container(
                          height: 800,
                          width: 300,
                          decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(180)),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: 800),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: MyImageModel(
                                      urlImage: 'assets/images/global_home_annuaire_mascot.png',
                                      size: 800,
                                    ),
                                  ),
                                ],
                              )),
                              SizedBox(
                                width: 72,
                              ),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyTextWidget(
                                    text: "Annuaire",
                                    textColor: Colors.white,
                                    theme: BASE_TEXT_THEME.DISPLAY,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 24),
                                    child: MyTextWidget(
                                      text:
                                          "Faites découvrir votre entreprise par vos clients et tissez des liens avec de nouveaux partenaires. L'annuaire Buz'Up vous donne accès à plus de 15.000 adresses et contacts d'entreprises au Bénin.",
                                      textColor: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      MyButtonWidget(
                                        text: "Voir l'annuaire",
                                        backColor: Colors.white,
                                        textColor: ConstantColor.accentColor,
                                        action: () {
                                          Fonctions().openPageToGo(
                                            contextPage: context,
                                            pageToGo: AnnuairePage(),
                                          );
                                        },
                                      ),
                                      MyButtonWidget(
                                        text: "Inscrire mon entreprise",
                                        backColor: Colors.white,
                                        textColor: ConstantColor.accentColor,
                                        action: () {
                                          Fonctions().openUrl(PwaLink.business);
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            moveToNextSection();
                                          },
                                          icon: Icon(
                                            Icons.arrow_downward,
                                            color: Colors.white,
                                            size: 48,
                                          )),
                                    ],
                                  )
                                ],
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "assets/images/global_home_back.jpg",
                        ),
                        fit: BoxFit.cover)),
                child: Container(
                  color: Colors.white.withOpacity(0.9),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              constraints: BoxConstraints(maxWidth: 800),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MyTextWidget(
                                        text: "E-Services Privés",
                                        theme: BASE_TEXT_THEME.DISPLAY,
                                        textColor: ConstantColor.accentColor,
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(vertical: 24),
                                        child: MyTextWidget(
                                          text:
                                              "Gagnez du temps et réduisez les risques d'accident. Accédez aux services des administrations privées du Bénin depuis le confort de votre fauteuil.",
                                        ),
                                      ),
                                      MyButtonWidget(
                                        text: "Accéder aux services",
                                        backColor: Colors.white,
                                        textColor: ConstantColor.accentColor,
                                        action: () {
                                          Fonctions().openPageToGo(
                                            contextPage: context,
                                            pageToGo: EserviceHome(),
                                          );
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                moveToNextSection();
                                              },
                                              icon: Icon(
                                                Icons.arrow_downward,
                                                color: ConstantColor.accentColor,
                                                size: 48,
                                              )),
                                        ],
                                      )
                                    ],
                                  )),
                                  SizedBox(
                                    width: 72,
                                  ),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      MyImageModel(
                                        urlImage: 'assets/images/global_home_service_mascot.png',
                                        fit: BoxFit.cover,
                                        size: 500,
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //AnnuaireHome(),
              PharmacieHomePage(),
              SchoolHome(),
              OryxHomePage(),
              //EglizierHomePage(),
            ],
          )),
        ));
  }

  Widget SmallScreenView() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    constraints: BoxConstraints(maxWidth: 500),
                    child: GridView(
                      padding: EdgeInsets.only(top: 36, right: 16, left: 16, bottom: 48),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200),
                      primary: false,
                      shrinkWrap: true,
                      children: [
                        buzupMoreServiceCard(
                            title: "Annuaire",
                            assetPath: "assets/images/ic_buzup.png",
                            description: "Trouvez des adresses et contacts d'entreprises partout au Bénin",
                            action: () {
                              Fonctions().openPageToGo(contextPage: context, pageToGo: AnnuaireHome());
                            }),
                        buzupMoreServiceCard(
                            title: "Pharmacies",
                            assetPath: "assets/images/ic_buzup_pharma.png",
                            description: "Trouvez les pharmacies les plus proches de chez vous.",
                            action: () {
                              Fonctions().openPageToGo(contextPage: context, pageToGo: PharmacieHomePage());
                            }),
                        buzupMoreServiceCard(
                            title: "Où suis-je",
                            assetPath: "assets/images/ic_ou_suis_je.png",
                            description: "Obtenez des information sur votre position actuelle",
                            action: () {
                              Fonctions().openPageToGo(contextPage: context, pageToGo: OuSuisJeHomePage());
                            }),
                        buzupMoreServiceCard(
                            title: "School",
                            assetPath: "assets/images/ic_buzup_school.png",
                            description: "Trouvez les écoles de formations et leurs filières",
                            action: () {
                              Fonctions().openPageToGo(contextPage: context, pageToGo: SchoolHome());
                            }),
                        buzupMoreServiceCard(
                            title: "FlashNote",
                            description: "Que disent les buzuppeur des produits de votre quotidien.",
                            action: () {
                              Fonctions().openPageToGo(contextPage: context, pageToGo: FlashNoteHome());
                            }),
                        buzupMoreServiceCard(
                            title: "Gaz Oryx",
                            assetPath: "assets/images/logo_oryx_energies.png",
                            description: "Trouvez le vendeur de Gaz le plus proche de vous.",
                            action: () {
                              Fonctions().openPageToGo(contextPage: context, pageToGo: OryxHomePage());
                            }),
                        buzupMoreServiceCard(
                            title: "E-Service privé",
                            description: "Une façon simplifiée d'accéder aux services des entreprises.",
                            action: () {
                              Fonctions().openPageToGo(contextPage: context, pageToGo: EserviceHome());
                            }),
                        buzupMoreServiceCard(
                            title: "Market",
                            description: "Ce que vendent les entreprises, achetez-les en ligne.",
                            action: () {
                              Fonctions().openPageToGo(
                                  contextPage: context,
                                  pageToGo: ProduitListWidget(
                                    showAsGrid: true,
                                    showItemAsCard: true,
                                    showSearchBar: true,
                                    showAppBar: true,
                                    title: "Buz'Up Market",
                                    padding: EdgeInsets.symmetric(horizontal: 24),
                                  ));
                            }),
                        /* buzupMoreServiceCard(
                            title: "Immo",
                            icon: Icons.holiday_village,
                            description: "Achetez, vendez, louez des biens immobilier .",
                            action: () {
                              Fonctions().openPageToGo(contextPage: context, pageToGo: ImmoHomePage());
                            }),*/
                        buzupMoreServiceCard(
                            title: "News",
                            description: "Les entreprises partagent avec vous leur quotidien.",
                            action: () {
                              Fonctions().openPageToGo(
                                  contextPage: context,
                                  pageToGo: ActualiteListWidget(
                                    showItemAsCard: true,
                                    showAppBar: true,
                                    showAsGrid: true,
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  ));
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buzupMoreServiceCard(
      {String? title,
      String? description,
      String? assetPath,
      Color? iconBackColor,
      Color? cardBackColor,
      Color? btBackColor,
      Color? btTextColor,
      TextStyle? titleStyle,
      TextStyle? descriptionStyle,
      String? btText,
      Function? action}) {
    return GestureDetector(
      onTap: () {
        if (action != null) action();
      },
      child: MyCardWidget(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (assetPath != null)
              Container(
                padding: EdgeInsets.all(4),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBackColor ?? Colors.black,
                  shape: BoxShape.circle,
                ),
                child: MyImageModel(
                  urlImage: assetPath,
                  size: 36,
                ),
              ),
            if (title != null)
              MyTextWidget(
                text: title,
                textAlign: TextAlign.center,
                theme: BASE_TEXT_THEME.TITLE,
              ),
            if (description != null)
              MyTextWidget(
                text: description,
                textAlign: TextAlign.center,
                theme: BASE_TEXT_THEME.BODY_SMALL,
              ),
          ],
        ),
      ),
    );
  }
}
