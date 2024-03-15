import 'package:buzuppro/flavorConfig.dart';
import 'package:buzuppro/main_core.dart';
import 'package:schools/SchoolHome.dart';

final homeSchool = SchoolHome();
FlavorConfig schoolFlavorConfig = FlavorConfig()
  ..appTitle = "BuzUp School"
  ..imageLocation = "assets/images/ic_buzup.png"
  ..home = homeSchool;
void main() {
  mainCommon(schoolFlavorConfig);
}
