import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends ChangeNotifier {
  LanguageController({Locale? initialLocale})
      : _locale = initialLocale ?? const Locale('ku');

  static const _key = 'app_language_v1';
  Locale _locale;

  Locale get locale => _locale;

  static Future<LanguageController> create() async {
    final preferences = SharedPreferencesAsync();
    final savedCode = await preferences.getString(_key);
    return LanguageController(
        initialLocale: Locale(savedCode == 'ar' ? 'ar' : 'ku'));
  }

  Future<void> changeLanguage(String languageCode) async {
    if (languageCode != 'ku' && languageCode != 'ar') return;
    if (_locale.languageCode == languageCode) return;
    _locale = Locale(languageCode);
    notifyListeners();
    await SharedPreferencesAsync().setString(_key, languageCode);
  }
}
