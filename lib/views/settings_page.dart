import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/l10n.dart';
import '../state/settings_store.dart';

class SettingsPage extends StatelessWidget {
  final SettingsStore settings;

  const SettingsPage({super.key, required this.settings});

  static List<(Locale?, String Function(AppLocalizations))> _locales() => [
        (null, (l) => l.languageSystem),
        (const Locale('en', 'GB'), (l) => l.languageEnGB),
        (const Locale('zh'), (l) => '简体中文'),
        (const Locale('ru'), (l) => 'Русский'),
        (const Locale('ga'), (l) => 'Gaeilge'),
      ];

  static List<(AppThemeMode, String Function(AppLocalizations))> _themes() => [
        (AppThemeMode.system, (l) => l.themeSystem),
        (AppThemeMode.light, (l) => l.themeLight),
        (AppThemeMode.dark, (l) => l.themeDark),
        (AppThemeMode.oled, (l) => l.themeOled),
      ];

  @override
  Widget build(BuildContext context) {
    final l = l10n(context);
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l.settingsLanguage,
              style: Theme.of(context).textTheme.titleMedium),
          RadioGroup<Locale?>(
            groupValue: settings.locale,
            onChanged: settings.setLocale,
            child: Column(
              children: [
                for (final (locale, label) in _locales())
                  RadioListTile<Locale?>(
                    key: Key('locale_${locale?.toString() ?? 'system'}'),
                    value: locale,
                    title: Text(label(l)),
                    dense: true,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(l.settingsTheme,
              style: Theme.of(context).textTheme.titleMedium),
          RadioGroup<AppThemeMode>(
            groupValue: settings.themeMode,
            onChanged: (v) {
              if (v != null) settings.setThemeMode(v);
            },
            child: Column(
              children: [
                for (final (mode, label) in _themes())
                  RadioListTile<AppThemeMode>(
                    key: Key('theme_${mode.name}'),
                    value: mode,
                    title: Text(label(l)),
                    dense: true,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
