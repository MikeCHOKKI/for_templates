import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/Fonctions/firebase_services.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyResponsiveWidget.dart';
import 'package:core/common_folder/widgets/MyStepperWidget.dart';
import 'package:core/common_folder/widgets/MyTextInputWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/formulaires.dart';
import 'package:core/objet/CategorieEntreprise.dart';
import 'package:core/objet/Entreprise.dart';
import 'package:core/pages/objet_details/EntrepriseDetailsPage.dart';
import 'package:core/preferences.dart';
import 'package:flutter/material.dart';

class InscriptionEntreprisePage extends StatefulWidget {
  bool mayShowNext, mayShowPreview;
  void Function(String? value) reload;
  String? idCategorie, latitude, longitude;
  final List<CategorieEntreprise> CategorieEntrepriseList;

  InscriptionEntreprisePage(
      {Key? key,
      required this.CategorieEntrepriseList,
      this.mayShowNext = false,
      this.mayShowPreview = true,
      this.idCategorie,
      this.latitude,
      this.longitude,
      required this.reload})
      : super(key: key);

  @override
  State<InscriptionEntreprisePage> createState() => _InscriptionEntreprisePageState();
}

class _InscriptionEntreprisePageState extends State<InscriptionEntreprisePage> {
  late List<ItemStepperClass> stepperPage;
  GlobalKey<FormFieldState> nomKey = GlobalKey<FormFieldState>();
  TextEditingController nomController = TextEditingController();
  bool mayShowNext = false,
      mayShowPreview = false,
      hideStepper = false,
      showDemandeForGetEntreprise = false,
      showBtnCreateAndUpdateEntreprise = false,
      isLoadVerification = false;
  String messageAlert = "";
  Entreprise? entreprise;
  List<Entreprise> listSource = [];
  ControlsDetails? stepperControl;

  void verificationEntreprise({String nom = ""}) {
    if (nomKey.currentState!.validate() == false) {
      return;
    } else {
      setState(() {
        isLoadVerification = true;
      });
      Preferences(skipLocal: true)
          .getEntrepriseListFromLocal(nom: nom, min_index: 0)
          .then((value) => {
                setState(() {
                  listSource.clear();
                  listSource.addAll(value);
                  if (listSource.isEmpty) {
                    isLoadVerification = false;
                    if (stepperControl != null) stepperControl!.onStepContinue!();
                    //mayShowNext = true;
                    entreprise = Entreprise(
                        nom: nomController.text,
                        id_categorie: widget.idCategorie,
                        lat_gps: widget.latitude,
                        long_gps: widget.longitude);
                  } else {
                    hideStepper = true;
                    if (FirebaseServices.userConnectedFirebaseID == listSource.first.id_users) {
                      messageAlert =
                          "Vous aviez déjà créé une entreprise avec ce nom.\n Veuillez entrer un autre nom. Merci";
                      showBtnCreateAndUpdateEntreprise = true;
                    } else {
                      messageAlert = "Ce nom d'entreprise existe déjà.\n Voir les détails ci-dessous.";
                    }
                  }
                  isLoadVerification = false;
                })
              })
          .onError((error, stackTrace) => {
                setState(() {
                  isLoadVerification = false;
                })
              });
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    mayShowPreview = widget.mayShowPreview;
    mayShowNext = widget.mayShowNext;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: MyResponsiveWidget(
          smallScreen: Column(
            children: [
              SizedBox(
                height: 40,
                child: _titleBloc(title: "Enregistrement"),
              ),
              Expanded(
                child: MyCardWidget(
                  child: Column(
                    children: [
                      if (!showDemandeForGetEntreprise && messageAlert.isNotEmpty) _messageAlertBloc(),
                      if (showBtnCreateAndUpdateEntreprise)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Expanded(child: _btnModifierEntreprise()),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: _btnCreerNouvelleEntreprise(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      if (hideStepper && !showDemandeForGetEntreprise && !showBtnCreateAndUpdateEntreprise)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Expanded(child: _btnCeNestPasMonEntreprise()),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child: _btnCestMonEntreprise()),
                                ],
                              )
                            ],
                          ),
                        ),
                      if (showDemandeForGetEntreprise) _demandeAcquisitionBloc(),
                      if (!hideStepper)
                        Expanded(
                          child: _stepperBloc(),
                        ),
                      if (listSource.isNotEmpty && !showDemandeForGetEntreprise && !mayShowNext && hideStepper)
                        Expanded(child: _entrepriseDetailsPageBloc(entreprise: listSource.first)),
                    ],
                  ),
                ),
              )
            ],
          ),
          largeScreen: Column(
            children: [
              SizedBox(
                height: 40,
                child: _titleBloc(),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 820),
                    child: MyCardWidget(
                      child: Column(
                        children: [
                          if (!showDemandeForGetEntreprise && messageAlert.isNotEmpty) _messageAlertBloc(),
                          if (showBtnCreateAndUpdateEntreprise)
                            Row(
                              children: [
                                Spacer(),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _btnModifierEntreprise(),
                                      SizedBox(width: 8),
                                      _btnCreerNouvelleEntreprise()
                                    ],
                                  ),
                                )
                              ],
                            ),
                          if (hideStepper && !showDemandeForGetEntreprise && !showBtnCreateAndUpdateEntreprise)
                            Row(
                              children: [
                                Spacer(),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _btnCeNestPasMonEntreprise(),
                                      SizedBox(width: 8),
                                      _btnCestMonEntreprise()
                                    ],
                                  ),
                                )
                              ],
                            ),
                          if (showDemandeForGetEntreprise)
                            Expanded(
                              child: Center(
                                child: _demandeAcquisitionBloc(),
                              ),
                            ),
                          if (!hideStepper)
                            Expanded(
                              child: _stepperBloc(),
                            ),
                          if (listSource.isNotEmpty && !showDemandeForGetEntreprise && !mayShowNext && hideStepper)
                            Expanded(
                              child: _entrepriseDetailsPageBloc(entreprise: listSource.first),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _entrepriseDetailsPageBloc({Key? key, required Entreprise entreprise}) {
    return EntrepriseDetailsPage(
      key: ValueKey<String>("${entreprise}"),
      entreprise: entreprise,
    );
  }

  Widget _demandeAcquisitionBloc({Key? key}) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(maxWidth: 500),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: MyTextWidget(
            text: "Veuillez faire une demande d'acquisition pour cette entreprise. "
                "Vous recevrez par mail une réponse après vérification des informations. Merci",
            theme: BASE_TEXT_THEME.TITLE,
            textColor: ConstantColor.redErrorColor,
          ),
        ),
        MyButtonWidget(
          rounded: true,
          text: "Faire une demande",
          backColor: Theme.of(context).primaryColor,
          action: () {
            Fonctions().openUrl("contact@buzup.app");
          },
        ),
      ],
    );
  }

  Widget _btnCestMonEntreprise({Key? key}) {
    return MyButtonWidget(
      radiusButton: 12,
      text: "C'est mon entreprise",
      backColor: Theme.of(context).primaryColor,
      action: () {
        showDemandeForGetEntreprise = true;
        setState(() {});
      },
    );
  }

  Widget _btnCeNestPasMonEntreprise({Key? key}) {
    return MyButtonWidget(
      radiusButton: 12,
      backColor: Colors.black,
      text: "Ce n'est pas mon entreprise",
      action: () {
        Fonctions().showWidgetAsDialog(
          context: context,
          onCloseDialog: () {
            Navigator.pop(context);
            hideStepper = false;
            entreprise = null;
            setState(() {});
          },
          title: "",
          widget: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: MyCardWidget(
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      cardColor: ConstantColor.redErrorColor.withOpacity(0.1),
                      child: Center(
                        child: MyTextWidget(
                          text: "Veuillez bien créer une entreprise avec un autre nom.\n Merci.",
                          theme: BASE_TEXT_THEME.TITLE,
                          textColor: ConstantColor.redErrorColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _btnCreerNouvelleEntreprise({Key? key}) {
    return MyButtonWidget(
      radiusButton: 12,
      text: "Créer une nouvelle",
      backColor: Theme.of(context).primaryColor,
      action: () {
        hideStepper = false;
        entreprise = null;
        messageAlert = "";
        nomController.text = "";
        showBtnCreateAndUpdateEntreprise = false;
        setState(() {});
      },
    );
  }

  Widget _btnModifierEntreprise({Key? key}) {
    return MyButtonWidget(
      radiusButton: 12,
      backColor: Colors.black,
      text: "Modifier l'entreprise",
      action: () {
        Navigator.of(context).pop(listSource.first.id);
        widget.reload(listSource.first.id);
        setState(() {});
      },
    );
  }

  Widget _messageAlertBloc({Key? key}) {
    return Row(
      children: [
        Expanded(
          child: MyCardWidget(
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            cardColor: ConstantColor.redErrorColor.withOpacity(0.1),
            child: Center(
              child: MyTextWidget(text: messageAlert, textColor: ConstantColor.redErrorColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _titleBloc({Key? key, String title = "Enregistrement d'entreprise"}) {
    return Row(
      children: [
        SizedBox(
          width: 65,
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: MyTextWidget(text: title, theme: BASE_TEXT_THEME.TITLE, textColor: Colors.black, maxLines: 1),
          ),
        ),
        SizedBox(
          width: 65,
          child: MyButtonWidget(
            iconData: Icons.close_sharp,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            showShadow: false,
            backColor: ConstantColor.transparentColor,
            iconColor: ConstantColor.redErrorColor,
            action: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _stepperBloc({Key? key}) {
    return Container(
      color: Colors.white,
      child: MyStepperWidget(
        customWidget: (control, list) {
          stepperControl = control;
          return Row(
            children: <Widget>[
              Spacer(),
              if (mayShowNext)
                MyButtonWidget(
                  rounded: true,
                  text: "Terminer",
                  backColor: Theme.of(context).primaryColor,
                  action: () {
                    if (control.currentStep == list.length - 1) {
                      Navigator.pop(context);
                      widget.reload(entreprise!.id);
                    }
                  },
                )
            ],
          );
        },
        widgetStepper: [
          ItemStepperClass(
            index: 0,
            name: "Identification",
            page: Container(
              constraints: BoxConstraints(maxWidth: 500),
              child: Column(
                children: [
                  MyTextInputWidget(
                    backColor: Colors.transparent,
                    border: Border.all(color: Colors.black, width: 0.3),
                    padding: EdgeInsets.symmetric(vertical: 0),
                    validationKey: nomKey,
                    textController: nomController,
                    isRequired: true,
                    hintLabel: "nom",
                  ),
                  Row(
                    children: <Widget>[
                      MyButtonWidget(
                        text: "Poursuivre",
                        rounded: true,
                        loaderColor: Colors.white,
                        margin: EdgeInsets.all(12),
                        load: isLoadVerification,
                        action: () async {
                          verificationEntreprise(nom: nomController.text.trim());
                        },
                      ),
                      Spacer()
                    ],
                  ),
                ],
              ),
            ),
          ),
          ItemStepperClass(
            index: 1,
            name: "A propos",
            page: Container(
              constraints: BoxConstraints(maxWidth: 500),
              child: Formulaire(
                  contextFormulaire: context,
                  mayPopNavigatorOnSuccess: false,
                  successCallBack: (value) {
                    entreprise = value;
                    if (stepperControl != null) stepperControl!.onStepContinue!();
                    mayShowNext = false;
                    setState(() {});
                  }).saveEntrepriseForm(
                  paramToShowObject: Entreprise(
                    id_categorie: widget.idCategorie != null ? null : "",
                    id_sous_categorie: widget.idCategorie != null ? null : "",
                    forme_legale: "",
                    description: "",
                    adresse: "",
                    quartier: "",
                    ville: "",
                    pays: "",
                    horaire_ouverture: "",
                  ),
                  objectEntreprise: entreprise,
                  onPreViewPressed: () {
                    if (stepperControl != null) stepperControl!.onStepCancel!();
                  },
                  isInStepper: true,
                  categorieEntrepriseList: widget.CategorieEntrepriseList),
            ),
          ),
          ItemStepperClass(
            index: 2,
            name: "Contacts",
            page: Container(
              constraints: BoxConstraints(maxWidth: 500),
              child: Formulaire(
                  contextFormulaire: context,
                  mayPopNavigatorOnSuccess: false,
                  successCallBack: (value) {
                    entreprise = value;
                    if (stepperControl != null) stepperControl!.onStepContinue!();
                    mayShowNext = false;
                    setState(() {});
                  }).saveEntrepriseForm(
                  paramToShowObject: Entreprise(
                    mail: "",
                    telephone1: "",
                    telephone2: "",
                    whatsapp: "",
                  ),
                  isInStepper: true,
                  objectEntreprise: entreprise),
            ),
          ),
          /*ItemStepperClass(
              index: 3,
              name: "Liens sociaux",
              page: Container(
                constraints: BoxConstraints(maxWidth: 500),
                child: Formulaire(
                    contextFormulaire: context,
                    mayPopNavigatorOnSuccess: false,
                    successCallBack: (value) {
                      entreprise = value;
                      if (stepperControl != null) stepperControl!.onStepContinue!();
                      mayShowNext = false;
                      setState(() {});
                    }).saveEntrepriseForm(
                    paramToShowObject: Entreprise(
                      facebook: "",
                      instagram: "",
                      twitter: "",
                      skype: "",
                      youtube: "",
                      linkedin: "",
                      telegram: "",
                      tiktok: "",
                      site_web: "",
                    ),
                    objectEntreprise: entreprise,
                    isInStepper: true),
              ),),*/
          ItemStepperClass(
            index: 4,
            name: "Détails",
            page: Container(
              constraints: BoxConstraints(maxWidth: 500),
              child: Formulaire(
                  contextFormulaire: context,
                  mayPopNavigatorOnSuccess: false,
                  successCallBack: (value) {
                    entreprise = value;
                    if (stepperControl != null) stepperControl!.onStepContinue!();
                    mayShowNext = true;
                    setState(() {});
                  }).saveEntrepriseForm(
                  paramToShowObject: Entreprise(
                    rccm: "",
                    ifu: "",
                    date_creation: "",
                    nom_responsable: "",
                  ),
                  objectEntreprise: entreprise,
                  isInStepper: true),
            ),
          ),
          ItemStepperClass(
            index: 5,
            name: "Vérification",
            page: SizedBox(
              height: 500,
              child: Column(
                children: [
                  if (entreprise != null) Expanded(child: _entrepriseDetailsPageBloc(entreprise: entreprise!)),
                ],
              ),
            ),
          ),
        ],
        /*showNextButton: mayShowNext,
                                  showPreviousButton: mayShowPreview,
                                  onChangedShowButton:
                                      (ControlsDetails control, bool value) {
                                    setState(() {
                                      if (value == true) {
                                        control.onStepContinue!();
                                        mayShowNext = false;
                                      } else {
                                        Navigator.pop(context);
                                        widget.reload(entreprise!.id);
                                      }
                                    });
                                  },*/
      ),
    );
  }
}
