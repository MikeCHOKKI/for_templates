import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:flutter/material.dart';

class EserviceFormPage extends StatefulWidget {
  const EserviceFormPage({Key? key}) : super(key: key);

  @override
  State<EserviceFormPage> createState() => _EserviceFormPageState();
}

class _EserviceFormPageState extends State<EserviceFormPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: MyTextWidget(text: ''),
        ),
        body: Container(),
      ),
    );
  }
}
