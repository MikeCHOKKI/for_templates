import 'dart:convert';
import 'dart:io';

import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'flavorConfig.dart';
import 'main_annuaire.dart';
import 'main_business.dart';
import 'main_eglizier.dart';
import 'main_eservices.dart';
import 'main_global_app.dart';
import 'main_school.dart';
import 'main_vote.dart';

const String globalRoute = "/global";
const String annuaireRoute = "/annuaire";
const String eglizierRoute = "/eglizier";
const String eservicesRoute = "/eservices";
const String businessRoute = "/business";
const String schoolRoute = "/school";
const String voteRoute = "/vote";

Future<void> mainCommon([FlavorConfig? config]) async {
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();
  //usePathUrlStrategy();

  if (!kIsWeb) {
    if (!Platform.isWindows) {
      await Firebase.initializeApp();
    }
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCiVX8RenQVNaatTmWcEe53u3CcrOmRuGs",
        authDomain: "buzup-896cc.firebaseapp.com",
        projectId: "buzup-896cc",
        storageBucket: "buzup-896cc.appspot.com",
        messagingSenderId: "458720174344",
        appId: "1:458720174344:web:1fcc55a6ce05582657ccbd",
      ),
    );
  }
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  runApp(MyApp(config: config!));
}

class MyApp extends StatefulWidget {
  final FlavorConfig? config;

  const MyApp({super.key, required this.config});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Fonctions().getDefaultMaterial(
      theme: widget.config!.themeData,
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name!);
        if (uri.queryParameters.isNotEmpty) {
          Preferences.saveData(
            key: '${Preferences.PREFS_KEYS_QUERYPARAMETERS}${uri.path}',
            response: json.encode(uri.queryParameters),
          );
        }
        switch (uri.path) {
          case globalRoute:
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
            return PageRouteBuilder(
              settings: settings,
              maintainState: false,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              pageBuilder: (context, _, __) {
                return homeGlobalHome;
              },
            );
          case annuaireRoute:
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
            return PageRouteBuilder(
              settings: settings,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              pageBuilder: (context, _, __) {
                return homeAnnuaire;
              },
            );
          case eglizierRoute:
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              /*setState(() {
                themeData = themeEglizier;
                localizationsDelegates = localizationEglizier;
                supportedLocales = supportedEglizier;
              });*/
            });
            return PageRouteBuilder(
              settings: settings,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              pageBuilder: (context, _, __) {
                return homeEglizier;
              },
            );
          case eservicesRoute:
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              /*setState(() {
                themeData = themeEservice;
                localizationsDelegates = localizationEservices;
                supportedLocales = supportedEservices;
              });*/
            });
            return PageRouteBuilder(
              settings: settings,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              pageBuilder: (context, _, __) {
                return homeEservices;
              },
            );
          case businessRoute:
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              /*setState(() {
                themeData = themeBusiness;
                localizationsDelegates = localizationBusiness;
                supportedLocales = supportedBusiness;
              });*/
            });
            return PageRouteBuilder(
              settings: settings,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              pageBuilder: (context, _, __) {
                return homeBusiness;
              },
            );
          case schoolRoute:
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              /*setState(() {
                themeData = themeSchool;
                localizationsDelegates = localizationSchool;
                supportedLocales = supportedLocales;
              });*/
            });
            return PageRouteBuilder(
              settings: settings,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              pageBuilder: (context, _, __) {
                return homeSchool;
              },
            );
          case voteRoute:
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              /* setState(() {
                themeData = themeVote;
                localizationsDelegates = localizationVote;
                supportedLocales = supportedVote;
              });*/
            });
            return PageRouteBuilder(
              settings: settings,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              pageBuilder: (context, _, __) {
                return homeVote;
              },
            );

          default:
            if (widget.config != null) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
              return PageRouteBuilder(
                settings: settings,
                maintainState: false,
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
                pageBuilder: (context, _, __) {
                  return Fonctions().getDefaultMaterial(theme: widget.config!.themeData, home: widget.config!.home!);
                },
              );
            } else {
              return PageRouteBuilder(
                settings: settings,
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
                pageBuilder: (context, _, __) {
                  return Scaffold();
                },
              );
            }
        }
      },
    );
  }
}
