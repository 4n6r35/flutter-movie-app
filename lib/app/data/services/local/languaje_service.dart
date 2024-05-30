class LanguageService {
  LanguageService(this._languageCode);
  String _languageCode;
  String get languageCode => _languageCode;

  void serLanguageCode(String code) {
    _languageCode = code;
  }
}
