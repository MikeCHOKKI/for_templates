import 'package:core/common_folder/constantes/call_all_main_class.dart';
import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyTextInputWidget.dart';
import 'package:flutter/material.dart';
import 'package:forms/FormApercuPage.dart';

import 'FormConstantes.dart';
import 'MyFormField.dart';

class CreateFormPage extends StatefulWidget {
  const CreateFormPage({Key? key}) : super(key: key);

  @override
  State<CreateFormPage> createState() => _CreateFormPageState();
}

class _CreateFormPageState extends State<CreateFormPage> {
  MyForm form = MyForm();

  late ValueNotifier<MyForm> notifyChange;

  void addNewQuestion({int? index}) {
    setState(() {
      form.questionList!.insert(
        index ?? form.questionList!.length - 1,
        FormQuestion(
          question: "",
          type: FormConstantes.questionTypeList.first.nom,
        ),
      );
    });
  }

  void removeQuestion(FormQuestion question) {
    setState(() {
      form.questionList!.remove(question);
    });
  }

  @override
  void initState() {
    form = MyForm(
      titre: "",
      description: "",
      questionList: [
        FormQuestion(
          question: "",
          suggestionList: [],
          isRequired: "0",
          type: FormConstantes.questionTypeList.first.nom,
        ),
      ],
    );
    notifyChange = ValueNotifier(form);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                MyButtonWidget(
                  iconData: Icons.arrow_back_ios_new_outlined,
                  showShadow: false,
                  backColor: Colors.transparent,
                  iconColor: ConstantColor.accentColor,
                  action: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: -30,
                          left: -20,
                          child: Transform.rotate(
                            angle: 90,
                            child: CustomPaint(
                              size: Size(100, 100),
                              painter: CallAllPaintClass().virusPaint1
                                ..color = Colors.grey.shade600.withOpacity(0.3),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -30,
                          right: -20,
                          child: Transform.rotate(
                            angle: -90,
                            child: CustomPaint(
                              size: Size(100, 100),
                              painter: CallAllPaintClass().virusPaint1
                                ..color = Colors.grey.shade600.withOpacity(0.3),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -30,
                          right: -20,
                          child: CustomPaint(
                            size: Size(100, 100),
                            painter: CallAllPaintClass().virusPaint1
                              ..color = Colors.grey.shade600.withOpacity(0.3),
                          ),
                        ),
                        Positioned(
                          bottom: -30,
                          left: -20,
                          child: CustomPaint(
                            size: Size(100, 100),
                            painter: CallAllPaintClass().virusPaint1
                              ..color = Colors.grey.shade600.withOpacity(0.3),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          child: Column(
                            children: [
                              MyTextInputWidget(
                                hint: "Titre du formulaire",
                                showUnderline: true,
                                backColor: Colors.transparent,
                                maxLines: 1,
                                minLines: 1,
                                hintStyle: Styles().getDefaultTextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black54,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    form.titre = value;
                                  });
                                },
                              ),
                              MyTextInputWidget(
                                hint: "Description du formulaire",
                                showUnderline: true,
                                backColor: Colors.transparent,
                                maxLines: 1,
                                minLines: 1,
                                onChanged: (value) {
                                  setState(() {
                                    form.description = value;
                                  });
                                },
                              ),
                              Expanded(
                                child: ListView.separated(
                                  primary: false,
                                  shrinkWrap: true,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(left: 12.0),
                                  itemCount: form.questionList!.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Divider(
                                      color: index % 2 == 0
                                          ? ConstantColor.accentColor
                                          : ConstantColor.secondColor,
                                    );
                                  },
                                  itemBuilder: (context, index) {
                                    return MyFormField(
                                      question: form.questionList![index],
                                      addNewQuestion: () {
                                        setState(() {
                                          addNewQuestion(index: index + 1);
                                        });
                                      },
                                      onQuestionChange: (newQuestion) {
                                        setState(() {
                                          form.questionList![index] = newQuestion;
                                        });
                                      },
                                      removeQuestion: () {
                                        setState(() {
                                          removeQuestion(
                                              form.questionList![index]);
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FormApercuPage(
                      form: notifyChange,
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
}
