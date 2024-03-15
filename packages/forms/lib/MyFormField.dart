// ignore_for_file: must_be_immutable

import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyCheckboxWidget.dart';
import 'package:core/common_folder/widgets/MyDropDownWidget.dart';
import 'package:core/common_folder/widgets/MyTextInputWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:flutter/material.dart';

import 'FormConstantes.dart';

class MyFormField extends StatefulWidget {
  FormQuestion question;
  void Function() addNewQuestion;
  void Function() removeQuestion;
  Function(FormQuestion)? onQuestionChange;

  MyFormField({
    Key? key,
    required this.question,
    required this.addNewQuestion,
    required this.removeQuestion,
    required this.onQuestionChange,
  }) : super(key: key);

  @override
  State<MyFormField> createState() => _MyFormFieldState();
}

class _MyFormFieldState extends State<MyFormField> {
  TextEditingController titre = TextEditingController();
  late FormQuestion question;

  String editingSendSuggestion = "";

  bool isRequired = false;

  FormQuestionType? questionType;

  List<FormQuestionType> questionTypeList = [
    FormQuestionType(
      nom: "Réponse Courte",
      icon: Icons.filter_list,
    ),
    FormQuestionType(
      nom: "Réponse Longue",
      icon: Icons.filter_list_rounded,
    ),
    FormQuestionType(
      nom: "Choix multiples",
      icon: Icons.radio_button_off_rounded,
    ),
    FormQuestionType(
      nom: "Case à cocher",
      icon: Icons.check_box_outline_blank_rounded,
    ),
    FormQuestionType(
      nom: "Liste déroulante",
      icon: Icons.arrow_drop_down_circle_rounded,
    ),
    FormQuestionType(
      nom: "Date",
      icon: Icons.date_range_rounded,
    ),
    FormQuestionType(
      nom: "Heure",
      icon: Icons.access_time_rounded,
    ),
  ];

  String oldVal = "";

  FormQuestionType getQuestionTypeByName({required String name}) {
    return FormConstantes.questionTypeList.firstWhere(
        (element) => element.nom.toLowerCase() == name.toLowerCase());
  }

  void addItem({dynamic value, dynamic list, int? index}) {
    setState(() {
      if (index != null) {
        list.insert(index, value);
      } else {
        list.add(value);
      }
    });
  }

  List<MyTextInputWidget> propositionWidgetList = [];

  void addBySelectionType({required FormQuestionType type}) {
    propositionWidgetList.clear();

    if (type == FormConstantes.questionTypeList[1]) {
      addItem(
        list: propositionWidgetList,
        value: MyTextInputWidget(
          hint: "${type.nom}",
          readOnly: true,
          backColor: Colors.white,
          showUnderline: true,
          maxLines: 1,
          minLines: 1,
          onValidated: (value) {
            question.suggestionList!.add(value);
            widget.onQuestionChange!(question);
          },
        ),
      );
    } else if (type == FormConstantes.questionTypeList[2]) {
      addItem(
        list: propositionWidgetList,
        value: MyTextInputWidget(
          hint: "${type.nom}",
          readOnly: true,
          backColor: Colors.white,
          showUnderline: true,
          maxLines: 1,
          minLines: 1,
          onValidated: (value) {
            question.suggestionList!.add(value);
            widget.onQuestionChange!(question);
          },
        ),
      );
    } else if (type == FormConstantes.questionTypeList[3]) {
      addItem(
        list: propositionWidgetList,
        value: MyTextInputWidget(
          textController: TextEditingController(),
          leftIcon: type.icon,
          hint: "Réponse possible",
          backColor: Colors.white,
          maxLines: 1,
          minLines: 1,
          onGetFocus: (value) {
            oldVal = value;
          },
          onLostFocus: (value) {
            print("value: $value,\nliste: ${question.suggestionList}");
            setState(() {
              if (question.suggestionList!.contains(oldVal)) {
                print("contains");
                question.suggestionList![
                    question.suggestionList!.indexOf(oldVal)] = value;
              } else {
                question.suggestionList!.add(value);
                print("not cntainer");
              }
            });
          },
        ),
      );
    } else if (type == FormConstantes.questionTypeList[4]) {
      addItem(
        list: propositionWidgetList,
        value: MyTextInputWidget(
          textController: TextEditingController(),
          leftIcon: type.icon,
          hint: "Réponse possible",
          backColor: Colors.white,
          maxLines: 1,
          minLines: 1,
          onGetFocus: (value) {},
          onLostFocus: (value) {
            question.suggestionList!.add(value);
          },
        ),
      );
    } else if (type == FormConstantes.questionTypeList[5]) {
      addItem(
        list: propositionWidgetList,
        value: MyTextInputWidget(
          textController: TextEditingController(),
          leftIcon: type.icon,
          hint: "Réponse possible",
          backColor: Colors.white,
          maxLines: 1,
          minLines: 1,
          onGetFocus: (value) {},
          onLostFocus: (value) {
            question.suggestionList!.add(value);
          },
        ),
      );
    } else if (type == FormConstantes.questionTypeList[6]) {
      addItem(
        list: propositionWidgetList,
        value: MyTextInputWidget(
          hint: "${type.nom}",
          backColor: Colors.white,
          isDateHeure: true,
          readOnly: true,
          showUnderline: true,
          maxLines: 1,
          minLines: 1,
          onValidated: (value) {
            question.suggestionList!.add(value);
            widget.onQuestionChange!(question);
          },
        ),
      );
    } else if (type == FormConstantes.questionTypeList[7]) {
      addItem(
        list: propositionWidgetList,
        value: MyTextInputWidget(
          hint: "${type.nom}",
          backColor: Colors.white,
          isHeure: true,
          showUnderline: true,
          readOnly: true,
          maxLines: 1,
          minLines: 1,
          onValidated: (value) {
            question.suggestionList!.add(value);
            widget.onQuestionChange!(question);
          },
        ),
      );
    }
  }

  @override
  void initState() {
    question = widget.question;
    questionType = getQuestionTypeByName(name: question.type!);
    addBySelectionType(type: getQuestionTypeByName(name: question.type!));

    super.initState();
    titre.addListener(() {
      question.question = titre.text;
      widget.onQuestionChange!(question);
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      question.isRequired = isRequired ? "1" : "0";
      widget.onQuestionChange!(question);
    });

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: MyTextInputWidget(
                    textController: titre,
                    hint:
                        "${getQuestionTypeByName(name: question.type!) == FormConstantes.questionTypeList[2] || getQuestionTypeByName(name: question.type!) == FormConstantes.questionTypeList[3] ? "Réponse possible" : "Question"}",
                    backColor: Colors.white,
                    maxLines: 1,
                    showUnderline: true,
                    minLines: 1,
                    hintStyle: Styles().getDefaultTextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Expanded(
                  child: MyDropDownWidget(
                    initialObject: questionType,
                    listObjet: FormConstantes.questionTypeList,
                    buildItem: (value) {
                      return Row(
                        children: <Widget>[
                          Icon(
                            value.icon,
                            color: Colors.black,
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: MyTextWidget(
                                text: "${value.nom}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          )
                        ],
                      );
                    },
                    onChangedDropDownValue: (value) {
                      setState(() {
                        questionType = value;
                        question.type = value.nom;
                        question.suggestionList!.clear();

                        addBySelectionType(type: value);
                      });
                    },
                  ),
                ),
                MyCheckboxWidget(
                  title: "Requis",
                  isChecked: isRequired,
                  switchChecked: (value) {
                    isRequired = value!;
                  },
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              ListView.builder(
                primary: false,
                itemCount: propositionWidgetList.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(right: 24.0),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: propositionWidgetList[index],
                      ),
                      if (getQuestionTypeByName(name: question.type!) ==
                              FormConstantes.questionTypeList[2] ||
                          getQuestionTypeByName(name: question.type!) ==
                              FormConstantes.questionTypeList[3] ||
                          getQuestionTypeByName(name: question.type!) ==
                              FormConstantes.questionTypeList[4])
                        Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: Icon(
                              Icons.remove_circle_outline_sharp,
                              color: ConstantColor.accentColor,
                              size: 20,
                            ),
                            onPressed: () {
                              // widget.removeQuestion!(question);
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
              if (getQuestionTypeByName(name: question.type!) ==
                      FormConstantes.questionTypeList[2] ||
                  getQuestionTypeByName(name: question.type!) ==
                      FormConstantes.questionTypeList[3] ||
                  getQuestionTypeByName(name: question.type!) ==
                      FormConstantes.questionTypeList[4])
                Row(
                  children: <Widget>[
                    Expanded(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            addItem(
                              list: propositionWidgetList,
                              value: MyTextInputWidget(
                                textController: TextEditingController(),
                                leftIcon:
                                    getQuestionTypeByName(name: question.type!)
                                        .icon,
                                hint: "Réponse possible" +
                                    (propositionWidgetList.length).toString(),
                                backColor: Colors.white,
                                maxLines: 1,
                                minLines: 1,
                                onGetFocus: (value) {
                                  if (question.suggestionList!.isNotEmpty) {
                                    oldVal = value;
                                  }
                                },
                                onLostFocus: (value) {
                                  print(
                                      "value: $value,\nliste: ${question.suggestionList}");
                                  setState(() {
                                    if (question.suggestionList!
                                        .contains(oldVal)) {
                                      print("contains");
                                      question.suggestionList![question
                                          .suggestionList!
                                          .indexOf(oldVal)] = value;
                                    } else {
                                      question.suggestionList!.add(value);
                                      print("not cntainer");
                                    }
                                  });
                                },
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: MyTextWidget(
                              text: "Ajouter un autre",
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(
                    Icons.add_circle_outline_sharp,
                    color: ConstantColor.accentColor,
                    size: 20,
                  ),
                  onPressed: () {
                    widget.addNewQuestion();
                    setState(() {});
                  },
                ),
              ),
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(
                    Icons.remove_circle_outline_sharp,
                    color: ConstantColor.accentColor,
                    size: 20,
                  ),
                  onPressed: () {
                    widget.removeQuestion();
                    setState(() {});
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
