import 'package:buzuppro/flavorConfig.dart';
import 'package:buzuppro/main_core.dart';
import 'package:oryx/OryxHomePage.dart';

final homeOryx = OryxHomePage();
FlavorConfig oryxFlavorConfig = FlavorConfig()
  ..appTitle = "Oryx"
  ..imageLocation = "assets/images/cfa_icon.png"
  ..home = homeOryx;
void main() {
  mainCommon(oryxFlavorConfig);
}
