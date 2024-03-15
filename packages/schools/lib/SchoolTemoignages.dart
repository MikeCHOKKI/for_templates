import 'package:core/common_folder/constantes/colorConstant.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyImageModel.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/pages/objet_list/SchoolTemoignagesListWidget.dart';
import 'package:flutter/material.dart';

class SchoolTemoignages extends StatefulWidget {
  const SchoolTemoignages({Key? key}) : super(key: key);

  @override
  State<SchoolTemoignages> createState() => _SchoolTemoignagesState();
}

class _SchoolTemoignagesState extends State<SchoolTemoignages> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ConstantColor.grisColor,
        appBar: AppBar(
          title: MyTextWidget(text: "Nos Témoignages"),
        ),
        body: PageView(
          scrollDirection: Axis.vertical,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 800),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 48),
                                child: MyTextWidget(
                                  text: "Témoignages de vos aînés",
                                  theme: BASE_TEXT_THEME.DISPLAY,
                                ),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: Container(
                                    child: SchoolTemoignagesListWidget(
                                      /*showSearchBar: true,*/
                                      canAddItem: true,
                                      /* onItemPressed: (temoignage){
                                      return MyTextWidget(
          text:"${temoignage}");
                                    },*/
                                      buildCustomItemView: (temoignages) {
                                        if (temoignages.video_link != null && temoignages.video_link!.isNotEmpty) {
                                          return Row(
                                            children: [
                                              Container(
                                                child: MyImageModel(),
                                              ),
                                              Container(
                                                child: MyTextWidget(text: "${temoignages.message}"),
                                              )
                                            ],
                                          );
                                        }
                                        if (temoignages.video_link == null) {
                                        } else {
                                          return MyCardWidget(
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Icon(
                                                    Icons.play_circle_outline,
                                                    size: 100,
                                                    color: ConstantColor.grisColor,
                                                  ),
                                                ),
                                                Container(
                                                  child: ListTile(
                                                    title: Row(
                                                      children: [
                                                        MyImageModel(
                                                          size: 36,
                                                          defaultUrlImage: "assets/images/user.png",
                                                        )
                                                      ],
                                                    ),
                                                    subtitle: MyTextWidget(text: "${temoignages.message}"),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }

                                        /* return (temoignages.video_link != null && temoignages.video_link!.isNotEmpty)? Row(
                                            children: [
                                              Container(
                                                child: Icon(Icons.play_circle_outline, size: 50, color: Colors.red,),
                                              ),
                                              Container(
                                                child: MyTextWidget(
          text:"${temoignages.message}"),
                                              )
                                            ],
                                          ):
                                        temoignages.video_link == null?
                                           Row(
                                            children: [
                                              Container(
                                                child: Center(child: Icon(Icons.play_circle_outline, size: 100, color: Colors.black,)),

                                              ),
                                              Container(
                                                child: MyTextWidget(
          text:"test"),
                                              )
                                            ],
                                          ):SizedBox.shrink(child: MyTextWidget(
          text:"test"),);*/
                                      },
                                    ),
                                  ))
                            ],
                          )),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MyImageModel(
                              urlImage: "assets/images/temoignage.png",
                              fit: BoxFit.cover,
                              size: 530,
                            )
                          ],
                        ),
                      )
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
