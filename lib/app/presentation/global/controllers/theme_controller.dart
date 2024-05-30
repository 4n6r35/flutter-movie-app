import 'package:flutter/widgets.dart';

import '../../../domain/repositories/preferences_repository.dart';

class ThemeController extends ChangeNotifier {
  ThemeController(
    this._darkMode, {
    required this.preferenceRepository,
  });

  final PreferenceRepository preferenceRepository;

  bool _darkMode;
  bool get darkMode => _darkMode;

  void onChange(bool darkMode) {
    _darkMode = darkMode;
    preferenceRepository.setDarkMode(_darkMode);
    notifyListeners();
  }
}
