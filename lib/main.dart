import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app/data/http/http.dart';
import 'app/data/services/remote/internet_checker.dart';
import 'app/generated/translations.g.dart';
import 'app/my_app.dart';
import 'app/presentation/global/controllers/favorites/favorites_controller.dart';
import 'app/presentation/global/controllers/session_controller.dart';
import 'app/presentation/global/controllers/theme_controller.dart';
import 'app/presentation/inject_reposiotries.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();

  Intl.defaultLocale = LocaleSettings.currentLocale.languageTag;

  final http = Http(
    client: Client(),
    baseUrl: 'https://api.themoviedb.org/3',
    // apiKey: '541a236fbc4bb835c29b84fecee88218',
    apiKey: '6c79a9121b580885ef291dd10a7798d9',
  );
  final systemDarkMode = window.platformBrightness == Brightness.dark;

  await injectRepositories(
    systemDarkMode: systemDarkMode,
    http: http,
    languajeCode: LocaleSettings.currentLocale.languageCode,
    secureStorage: const FlutterSecureStorage(),
    preferences: await SharedPreferences.getInstance(),
    connectivity: Connectivity(),
    internetChecker: InternetChecker(),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeController>(
          create: (context) {
            final preferenceRepository = Repositories.preferences;
            return ThemeController(
              preferenceRepository.darkMode,
              preferenceRepository: preferenceRepository,
            );
          },
        ),
        ChangeNotifierProvider<SessionController>(
          create: (context) => SessionController(
            authenticationRepository: Repositories.authentication,
          ),
        ),
        ChangeNotifierProvider<FavoritesController>(
          create: (context) => FavoritesController(
            accountRepository: Repositories.account,
          ),
        )
      ],
      child: TranslationProvider(
        child: const MyApp(),
      ),
    ),
  );
}
