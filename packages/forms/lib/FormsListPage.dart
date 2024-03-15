import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyNoDataWidget.dart';
import 'package:flutter/material.dart';

class FormListPage extends StatefulWidget {
  const FormListPage({Key? key}) : super(key: key);

  @override
  State<FormListPage> createState() => _FormListPageState();
}

class _FormListPageState extends State<FormListPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
              child: Container(
                child: Center(
                  child: MyNoDataWidget(
                    message: "Vous n'avez encore recu aucune réponse pour ce formulaire",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
