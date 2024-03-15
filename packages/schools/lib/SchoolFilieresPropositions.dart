import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:flutter/material.dart';

class SchoolFilieresPropositions extends StatefulWidget {
  const SchoolFilieresPropositions({Key? key}) : super(key: key);

  @override
  State<SchoolFilieresPropositions> createState() => _SchoolFilieresPropositionsState();
}

class _SchoolFilieresPropositionsState extends State<SchoolFilieresPropositions> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ConstantColor.grisColor,
        appBar: AppBar(
          title: MyTextWidget(text: 'Notre Orientation pour vous'),
        ),
        body: PageView(
          scrollDirection: Axis.vertical,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 950),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
                                child: MyTextWidget(
                                  text:
                                      "Félicitation pour votre BAC. Au vu de vos résultats, nous vous proposons les filières qui suivent: ",
                                  theme: BASE_TEXT_THEME.TITLE,
                                ),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: Container(
                                    child: Row(
                                      children: [
                                        /*SchoolFilieresListWidget(

                                        ),*/
                                        MyTextWidget(
                                          text:
                                              "NB: Nous tenons à vous préciser que ceci n'est pas une liste exhaustive.. ",
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MyImageModel(
                                urlImage: "assets/images/school_student.png",
                                fit: BoxFit.cover,
                                size: 500,
                              )
                            ],
                          ))
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
