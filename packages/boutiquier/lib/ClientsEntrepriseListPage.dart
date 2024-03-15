import 'package:core/common_folder/Constantes/colorConstant.dart';
import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/constant.dart';
import 'package:core/common_folder/constantes/enums.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyCardWidget.dart';
import 'package:core/common_folder/widgets/MyLoadingWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/objet/Entreprise.dart';
import 'package:core/objet/Users.dart';
import 'package:core/pages/objet_list/UsersListWidget.dart';
import 'package:core/preferences.dart';
import 'package:flutter/material.dart';

class ClientsEntrepriseListPage extends StatefulWidget {
  Entreprise entreprise;
  final PreferredSizeWidget? appBar;
  final bool? showAppBar;
  ClientsEntrepriseListPage({Key? key, required this.entreprise, this.showAppBar = false, this.appBar})
      : super(key: key);

  @override
  State<ClientsEntrepriseListPage> createState() => _ClientsEntrepriseListPageState();
}

class _ClientsEntrepriseListPageState extends State<ClientsEntrepriseListPage> {
  bool isLoading = false;
  List<Users> clientList = [];
  getClients() async {
    setState(() {
      isLoading = true;
    });
    clientList = await Preferences().getUsersListFromLocal(
      type: TYPE_USER.TYPE_USER_CLIENT,
      id_entreprise: widget.entreprise.id,
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar == true
          ? widget.appBar != null
              ? widget.appBar
              : Fonctions().defaultAppBar(
                  context: context,
                  titre: "Vos clients",
                  iconColor: Theme.of(context).primaryColor,
                  titreColor: Theme.of(context).primaryColor,
                  isNotRoot: true,
                  elevation: 0.0,
                  backgroundColor: Fonctions().isSmallScreen(context) ? Colors.white : ConstantColor.transparentColor)
          : null,
      body: Column(
        children: [
          if (isLoading) Center(child: MyLoadingWidget()),
          if (!isLoading)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    constraints: BoxConstraints(maxWidth: Constantes().limitScreenWidth),
                    child: MyCardWidget(
                      cardColor: Colors.white,
                      child: UsersListWidget(
                        backColor: Colors.white,
                        showSearchBar: true,
                        list: clientList,
                        buildCustomItemView: (client, _) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyTextWidget(
                                      text: "${client.nom} ${client.prenom}".trim(),
                                      theme: BASE_TEXT_THEME.TITLE_SMALL,
                                    ),
                                    MyTextWidget(text: "${client.telephone}"),
                                  ],
                                ),
                                MyButtonWidget(
                                  iconData: Icons.call,
                                  iconColor: Colors.white,
                                  action: () {
                                    Fonctions().callPhone("${client.telephone}");
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
