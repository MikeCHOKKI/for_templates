import 'package:buzuppro/flavorConfig.dart';
import 'package:buzuppro/main_core.dart';
import 'package:eservice_prive/EserviceHome.dart';

final homeEservices = EserviceHome();

FlavorConfig eServiceFlavorConfig = FlavorConfig()
  ..appTitle = "E-Service Privé"
  ..imageLocation = "assets/images/ic_buzup.png"
  ..home = homeEservices;

void main() {
  mainCommon(eServiceFlavorConfig);
}
