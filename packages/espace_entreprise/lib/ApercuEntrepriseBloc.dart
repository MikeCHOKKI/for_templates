import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyInfosContactWidget.dart';
import 'package:core/common_folder/widgets/MyMotionDelayAnimator.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/objet/Entreprise.dart';
import 'package:espace_entreprise/EspaceEntreprise.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

class ApercuEntrepriseBloc extends StatelessWidget {
  final Entreprise entreprise;
  final BuildContext? homeContext;
  final String title;
  final TextStyle? titleStyle;

  const ApercuEntrepriseBloc({super.key, required this.entreprise, this.homeContext, this.title = "", this.titleStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: title.isNotEmpty,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: MyTextWidget(text: title, theme: BASE_TEXT_THEME.TITLE, overflow: TextOverflow.ellipsis),
          ),
        ),
        MyCardWidget(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MouseRegion(
                cursor: MaterialStateMouseCursor.clickable,
                child: GestureDetector(
                  onTap: () {
                    Fonctions().openPageToGo(
                      contextPage: context,
                      pageToGo: SafeArea(
                        child: EspaceEntreprisePage(
                          entrepriseToShowDetails: entreprise,
                          appBar: AppBar(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            iconTheme: IconThemeData(color: ConstantColor.accentColor),
                            title: MyTextWidget(
                                text: "${entreprise.nom}",
                                maxLines: 1,
                                textColor: ConstantColor.accentColor,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        MyImageModel(
                          size: 36,
                          urlImage:
                              "https://${ConstantUrl.urlServer}${ConstantUrl.base}${entreprise.img_logo_link ?? 'assets/images/logo_defaut.png'}",
                          isRounded: true,
                          defaultUrlImage: "assets/images/logo_defaut.png",
                          showDefaultImage: true,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: MyTextWidget(
                              text: entreprise.nom!.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.arrow_right_alt_sharp,
                              color: ConstantColor.accentColor,
                              size: 22,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(),
              Column(
                children: [
                  if (entreprise.telephone1!.isNotEmpty)
                    MyMotionDelayAnimator(
                      delay: 4500,
                      movementAnimation: MovementEtat.downToup,
                      child: GestureDetector(
                        onTap: () {
                          Fonctions().makePhoneCall(entreprise.telephone1!);
                        },
                        child: MyInfosContactWidget(
                          iconInfos: Mdi.phone,
                          title: "Téléphone",
                          content: "${entreprise.code_telephone1}${entreprise.telephone1}",
                          onPressed: () {
                            Fonctions().makePhoneCall("${entreprise.code_telephone1}${entreprise.telephone1}");
                          },
                        ),
                      ),
                    ),
                  if (entreprise.telephone2!.isNotEmpty)
                    MyMotionDelayAnimator(
                      delay: 5500,
                      movementAnimation: MovementEtat.downToup,
                      child: GestureDetector(
                        onTap: () {
                          Fonctions().makePhoneCall(entreprise.telephone2!);
                        },
                        child: MyInfosContactWidget(
                          iconInfos: Mdi.phone,
                          title: "Téléphone 2",
                          content: "${entreprise.code_telephone2}${entreprise.telephone2}",
                          onPressed: () {
                            Fonctions().makePhoneCall("${entreprise.code_telephone2}${entreprise.telephone2}");
                          },
                        ),
                      ),
                    ),
                  MyMotionDelayAnimator(
                    delay: 6500,
                    movementAnimation: MovementEtat.downToup,
                    child: GestureDetector(
                      onTap: () {
                        Fonctions().openUrl("mailto:${entreprise.mail!}");
                      },
                      child: MyInfosContactWidget(
                        iconInfos: Icons.mail,
                        title: "Mail",
                        content: "${entreprise.mail!}",
                        onPressed: () {
                          Fonctions().openUrl("${entreprise.mail!}");
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
