import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { system, light, dark, oled }

const systemLocale = Locale('en', 'GB');

class SettingsStore extends ChangeNotifier {
  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale';
  static const _highlightFreeOnlyKey = 'highlight_free_only';

  final SharedPreferences _prefs;

  AppThemeMode _themeMode = AppThemeMode.system;
  Locale? _locale;
  var _highlightFreeOnly = false;

  SettingsStore(this._prefs);

  static Future<SettingsStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    final store = SettingsStore(prefs);
    store._themeMode = AppThemeMode
        .values[prefs.getInt(_themeKey) ?? AppThemeMode.system.index];
    final code = prefs.getString(_localeKey);
    if (code != null) {
      final parts = code.split('_');
      store._locale =
          parts.length == 1 ? Locale(parts[0]) : Locale(parts[0], parts[1]);
    }
    store._highlightFreeOnly =
        prefs.getBool(_highlightFreeOnlyKey) ?? false;
    return store;
  }

  AppThemeMode get themeMode => _themeMode;
  Locale? get locale => _locale;
  bool get highlightFreeOnly => _highlightFreeOnly;

  ThemeMode get materialThemeMode => switch (_themeMode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark || AppThemeMode.oled => ThemeMode.dark,
      };

  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await _prefs.setInt(_themeKey, mode.index);
  }

  Future<void> setLocale(Locale? locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    if (locale == null) {
      await _prefs.remove(_localeKey);
    } else {
      final code = locale.countryCode == null || locale.countryCode!.isEmpty
          ? locale.languageCode
          : '${locale.languageCode}_${locale.countryCode}';
      await _prefs.setString(_localeKey, code);
    }
  }

  Future<void> setHighlightFreeOnly(bool value) async {
    if (_highlightFreeOnly == value) return;
    _highlightFreeOnly = value;
    notifyListeners();
    await _prefs.setBool(_highlightFreeOnlyKey, value);
  }
}
