import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/http/http.dart';
import '../data/repositories_implementation/account_repository_impl.dart';
import '../data/repositories_implementation/authentication_repository_impl.dart';
import '../data/repositories_implementation/connectivity_repository_impl.dart';
import '../data/repositories_implementation/languaje_repository.dart';
import '../data/repositories_implementation/movies_repository_imple.dart';
import '../data/repositories_implementation/preference_repository_impl.dart';
import '../data/repositories_implementation/trending_repository_impl.dart';
import '../data/services/local/languaje_service.dart';
import '../data/services/local/session_service.dart';
import '../data/services/remote/account_api.dart';
import '../data/services/remote/authentication_api.dart';
import '../data/services/remote/internet_checker.dart';
import '../data/services/remote/movies_api.dart';
import '../data/services/remote/trending_api.dart';
import '../domain/repositories/account_repository.dart';
import '../domain/repositories/authentication_repository.dart';
import '../domain/repositories/connectivity_repository.dart';
import '../domain/repositories/languaje_repository.dart';
import '../domain/repositories/movies_repository.dart';
import '../domain/repositories/preferences_repository.dart';
import '../domain/repositories/trending_repository.dart';
import 'service_locator/service_locator.dart';

Future<void> injectRepositories({
  required bool systemDarkMode,
  required Http http,
  required String languajeCode,
  required FlutterSecureStorage secureStorage,
  required SharedPreferences preferences,
  required Connectivity connectivity,
  required InternetChecker internetChecker,
}) async {
  final sessionService = SessionService(secureStorage);
  final languageService = LanguageService(languajeCode);

  final AccountAPI accountAPI = AccountAPI(
    http,
    sessionService,
    languageService,
  );

  final authenticationAPI = AuthenticationAPI(http);

  ServiceLocator.instance.put<AccountRepository>(
    AccountRepositoryimpl(
      accountAPI,
      sessionService,
    ),
  );

  ServiceLocator.instance.put<LanguajeRepository>(
    LanguajeRepositoryImpl(
      languageService,
    ),
  );

  ServiceLocator.instance.put<PreferenceRepository>(
    PreferenceRepositoryImpl(
      preferences,
      systemDarkMode,
    ),
  );

  final connectivityRepository =
      ServiceLocator.instance.put<ConnectivityRepository>(
    ConnectivityRepositoryImpl(
      connectivity,
      internetChecker,
    ),
  );

  ServiceLocator.instance.put<AuthenticationRepository>(
    AuthenticationRepositoryImpl(
      authenticationAPI,
      sessionService,
      accountAPI,
    ),
  );

  ServiceLocator.instance.put<TrendingRepository>(
    TrendingRepositoryImpl(
      TrendingAPI(
        http,
        languageService,
      ),
    ),
  );

  ServiceLocator.instance.put<MoviesRepository>(
    MoviesRepositoryImpl(
      MoviesApi(
        http,
        languageService,
      ),
    ),
  );

  await connectivityRepository.initialize();
}

class Repositories {
  Repositories._();
  static AccountRepository get account => ServiceLocator.instance.find();
  static LanguajeRepository get languaje => ServiceLocator.instance.find();
  static PreferenceRepository get preferences => ServiceLocator.instance.find();
  static ConnectivityRepository get connectivity =>
      ServiceLocator.instance.find();
  static AuthenticationRepository get authentication =>
      ServiceLocator.instance.find();
  static TrendingRepository get trending => ServiceLocator.instance.find();
  static MoviesRepository get movies => ServiceLocator.instance.find();
}
