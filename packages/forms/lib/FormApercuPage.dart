import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyTextInputWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:flutter/material.dart';

import 'FormConstantes.dart';

class FormApercuPage extends StatefulWidget {
  final ValueNotifier<MyForm> form;

  const FormApercuPage({Key? key, required this.form}) : super(key: key);

  @override
  State<FormApercuPage> createState() => _FormApercuPageState();
}

class _FormApercuPageState extends State<FormApercuPage> {
  TextEditingController textEditingController = TextEditingController();

  Widget getWidgetByTypeQuestion([String type = "", dynamic value]) {
    if (type == FormConstantes.questionTypeList[0].nom) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: MyTextInputWidget(
          hint: "$value",
          backColor: Colors.white,
          readOnly: true,
          showUnderline: true,
          maxLines: 1,
          minLines: 1,
        ),
      );
    } else if (type == FormConstantes.questionTypeList[1].nom) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: MyTextInputWidget(
          hint: "$value",
          backColor: Colors.white,
          readOnly: true,
          showUnderline: true,
          maxLines: 1,
          minLines: 1,
        ),
      );
    } else if (type == FormConstantes.questionTypeList[2].nom) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 4),
      );
    } else if (type == FormConstantes.questionTypeList[3].nom) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 4),
      );
    } else if (type == FormConstantes.questionTypeList[4].nom) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 4),
      );
    } else if (type == FormConstantes.questionTypeList[5].nom) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: MyTextInputWidget(
          hint: "$value",
          backColor: Colors.white,
          isDateHeure: true,
          readOnly: true,
          showUnderline: true,
          maxLines: 1,
          minLines: 1,
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: MyTextInputWidget(
          hint: "$value",
          backColor: Colors.white,
          isHeure: true,
          showUnderline: true,
          readOnly: true,
          maxLines: 1,
          minLines: 1,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ValueListenableBuilder<MyForm>(
        valueListenable: widget.form,
        builder: (context, form, _) {
          return ListView(
            padding: EdgeInsets.all(12.0),
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: MyTextWidget(
                        text:
                            "${form.titre!.isNotEmpty ? form.titre : "Titre du formulaire"}",
                        theme: BASE_TEXT_THEME.TITLE,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: MyTextWidget(
                        text:
                            "${form.description!.isNotEmpty ? form.description : "Description du formulaire"}",
                      ),
                    )
                  ],
                ),
              ),
              ListView.builder(
                itemCount: form.questionList!.length,
                primary: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final question = form.questionList![index];
                  return Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: MyTextWidget(
                                text:
                                    "${question.question!.isNotEmpty ? question.question : "Titre de la question"}",
                              ),
                            )
                          ],
                        ),
                      ),
                      getWidgetByTypeQuestion(
                          question.type!, question.suggestionList)
                    ],
                  );
                },
              ),
              Container(
                child: MyTextInputWidget(
                  textController: TextEditingController(text: form.toJson()),
                  maxLength: 10000000000,
                  isMultiline: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
