import 'package:annuaire/AnnuaireHome.dart';
import 'package:buzuppro/flavorConfig.dart';

import 'main_core.dart';

final homeAnnuaire = AnnuaireHome();

FlavorConfig annuaireFlavorConfig = FlavorConfig()
  ..appTitle = "Annuaire"
  ..imageLocation = "assets/images/cfa_icon.png"
  ..home = homeAnnuaire;
void main() {
  mainCommon(annuaireFlavorConfig);
}
