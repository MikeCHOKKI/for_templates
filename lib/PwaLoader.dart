import 'package:core/common_folder/widgets/MyWebViewWidget.dart';
import 'package:flutter/material.dart';

class PwaLoader extends StatelessWidget {
  final String url;
  const PwaLoader({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
            child: MyWebViewWidget(
          url: url,
          enableNavigation: true,
        )),
      ],
    ));
  }
}
