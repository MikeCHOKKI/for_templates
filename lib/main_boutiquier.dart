import 'package:boutiquier/BoutiquierHome.dart';
import 'package:buzuppro/flavorConfig.dart';

import 'main_core.dart';

final homeBoutiquier = BoutiquierHome();
FlavorConfig BoutiquierFlavorConfig = FlavorConfig()
  ..appTitle = "Boutiquier"
  ..imageLocation = "assets/images/cfa_icon.png"
  ..home = homeBoutiquier;
void main() {
  mainCommon(BoutiquierFlavorConfig);
}
