import 'package:buzuppro/flavorConfig.dart';
import 'package:buzuppro/main_annuaire.dart';
import 'package:buzuppro/main_eservices.dart';
import 'package:buzuppro/main_school.dart';
import 'package:core/PwaLink.dart';
import 'package:flutter/material.dart';

import 'PwaLoader.dart';
import 'main_business.dart';
import 'main_core.dart';
import 'main_eglizier.dart';
import 'main_vote.dart';

void main({ThemeData? theme}) {
  String url = PwaLink.vote;
  late FlavorConfig pwaConfig;
  switch (url) {
    case PwaLink.annuaire:
      pwaConfig = annuaireFlavorConfig;
      break;
    case PwaLink.eglizier:
      pwaConfig = eglizierFlavorConfig;
      break;
    case PwaLink.eservices:
      pwaConfig = eServiceFlavorConfig;
      break;
    case PwaLink.school:
      pwaConfig = schoolFlavorConfig;
      break;
    case PwaLink.business:
      pwaConfig = businessFlavorConfig;
      break;
    case PwaLink.vote:
      pwaConfig = voteFlavorConfig;
      break;
  }
  pwaConfig.home = PwaLoader(
    url: url,
  );
  mainCommon(pwaConfig);
}
