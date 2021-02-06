class LanguageService {
  static final List<String> supportedLanguages = ['en', 'de', 'tr'];
  static final String defaultLanguage = 'en';

  static String getLang(String lang) {
    if (supportedLanguages.contains(lang))
      return lang;
    return defaultLanguage;
  }
}