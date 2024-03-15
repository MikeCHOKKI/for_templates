import 'package:buzuppro/flavorConfig.dart';
import 'package:buzuppro/main_core.dart';
import 'package:espace_entreprise/EspaceEntreprise.dart';

final homeBusiness = EspaceEntreprisePage();
FlavorConfig businessFlavorConfig = FlavorConfig()
  ..appTitle = "Buzup Business"
  ..imageLocation = "assets/images/ic_buzup.png"
  ..home = homeBusiness;

void main() {
  mainCommon(businessFlavorConfig);
}
