import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/constant.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/formulaires.dart';
import 'package:core/objet/CategorieEntreprise.dart';
import 'package:core/objet/UserAdresse.dart';
import 'package:core/preferences.dart';
import 'package:espace_entreprise/InscriptionEntreprisePage.dart';
import 'package:flutter/material.dart';

class TypeEnregistrementPage extends StatefulWidget {
  final String? latitude;
  final String? longitude;

  const TypeEnregistrementPage({Key? key, this.latitude, this.longitude})
      : super(key: key);

  @override
  State<TypeEnregistrementPage> createState() => _TypeEnregistrementPageState();
}

class _TypeEnregistrementPageState extends State<TypeEnregistrementPage> {
  List<CategorieEntreprise> categorieEntrepriseList = [];

  void getCategorieList() async {
    Preferences(skipLocal: false)
        .getCategorieEntrepriseListFromLocal()
        .then((value) => {
              setState(() {
                categorieEntrepriseList.clear();
                categorieEntrepriseList.addAll(value);
              })
            });
  }

  @override
  void initState() {
  getCategorieList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(constraints: BoxConstraints(maxWidth: Constantes().limitScreenWidth),width: 500,height: 500,
            child: MyCardWidget(
              elevation: 2,padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
              child: Column(
                children: [
                  MyTextWidget(text: "Que voulez-vous enregister ?"),
                  SizedBox(
                    height: 12,
                  ),
                  MyButtonWidget(
                    text: "Une adresse privée",
                    showShadow: false,
                    backColor: theme.primaryColor.withOpacity(0.2),
                    iconData: Icons.add_home_work_sharp,
                    iconColor: theme.primaryColor,
                    textColor: theme.primaryColor,
                    margin: EdgeInsets.all(4),
                    radiusButton: 12,
                    action: () {
                      setState(() {});
                      Fonctions().showWidgetAsDialog(
                        context: context,
                        title: "Ajouter une adresse",
                        widget: Formulaire(
                                contextFormulaire: context,
                                successCallBack: () {})
                            .saveUserAdresseForm(
                          objectUserAdresse: UserAdresse(
                              lat_gps: widget.latitude,
                              long_gps: widget.longitude),
                          paramToShowObject: UserAdresse(
                            nom: "",
                            description: "",
                            code_postal: "",
                            adresse: "",
                            quartier: "",
                            ville: "",
                            pays: "",
                            telephone: "",
                            mail: "",
                            site_web: "",
                            info_sup: "",
                            img_cover_link: "",
                          ),
                        ),
                      );
                      /*Fonctions().openPageToGo(
                        contextPage: context,
                        pageToGo: AnnuairePage(
                          userConnected: widget.userConnected,
                          indexPageToShow: indexPageToShow,
                        ),
                      );*/
                    },
                  ),
                  MyButtonWidget(
                    text: "Votre entreprise",
                    showShadow: false,
                    backColor: theme.primaryColor.withOpacity(0.2),
                    iconData: Icons.business_sharp,
                    iconColor: theme.primaryColor,
                    textColor: theme.primaryColor,
                    margin: EdgeInsets.all(4),
                    radiusButton: 12,
                    action: () {
                      setState(() {});
                      Fonctions().openPageToGo(
                        contextPage: context,
                        pageToGo: InscriptionEntreprisePage(
                          latitude: widget.latitude,
                          longitude: widget.longitude,
                          reload: (value) {
                            setState(() {});
                          },
                          CategorieEntrepriseList: categorieEntrepriseList,
                        ),
                      );
                    },
                  ),
                  MyButtonWidget(
                    text: "Une adresse publique",
                    showShadow: false,
                    backColor: theme.primaryColor.withOpacity(0.2),
                    iconData: Icons.podcasts_sharp,
                    iconColor: theme.primaryColor,
                    textColor: theme.primaryColor,
                    margin: EdgeInsets.all(4),
                    radiusButton: 12,
                    action: () {
                      setState(() {});
                      Fonctions().openPageToGo(
                        contextPage: context,
                        pageToGo: InscriptionEntreprisePage(
                          idCategorie: "cat_points_d_interet",
                          latitude: widget.latitude,
                          longitude: widget.longitude,
                          reload: (value) {
                            setState(() {});
                          },
                          CategorieEntrepriseList: categorieEntrepriseList,
                        ),
                      );
                      /*Fonctions().openPageToGo(
                        contextPage: context,
                        pageToGo: AnnuairePage(
                          userConnected: widget.userConnected,
                          indexPageToShow: indexPageToShow,
                        ),
                      );*/
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
