import 'package:buzuppro/flavorConfig.dart';
import 'package:buzuppro/main_core.dart';
import 'package:ou_suis_je/OuSuisJeHomePage.dart';

final home = OuSuisJeHomePage();

void main() {
  final config = FlavorConfig()
    ..appTitle = "Où suis-je"
    ..imageLocation = "assets/images/logo_ou_suis_je.png"
    ..home = home;

  mainCommon(config);
}
