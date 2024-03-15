import 'package:buzuppro/flavorConfig.dart';
import 'package:buzuppro/main_core.dart';
import 'package:event/EventHomePage.dart';

final homeEvent = EventHomePage();

FlavorConfig evenementFlavorConfig = FlavorConfig()
  ..appTitle = "Evènements"
  ..imageLocation = "assets/images/ic_buzup.png"
  ..home = homeEvent;

void main() {
  mainCommon(evenementFlavorConfig);
}
