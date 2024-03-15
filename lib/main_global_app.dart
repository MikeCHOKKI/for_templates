import 'package:buzuppro/BuzupGlobalHome.dart';
import 'package:buzuppro/flavorConfig.dart';
import 'package:buzuppro/main_core.dart';

final homeGlobalHome = GlobalHomePage();

void main() {
  final config = FlavorConfig()
    ..appTitle = "E-Service Privé"
    ..imageLocation = "assets/images/ic_buzup.png"
    ..home = homeGlobalHome;

  mainCommon(config);
}
