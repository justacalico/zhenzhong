import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'game/board.dart';
import 'l10n/app_localizations.dart';
import 'l10n/l10n.dart';
import 'services/window_actions.dart';
import 'services/window_setup.dart';
import 'state/settings_store.dart';
import 'state/stats_store.dart';
import 'state/update_store.dart';
import 'theme/app_theme.dart';
import 'utils/link_opener.dart';
import 'views/about_page.dart';
import 'views/game_page.dart';
import 'views/help_page.dart';
import 'views/settings_page.dart';
import 'widgets/app_shell.dart';
import 'widgets/sidebar.dart';

Future<void> bootstrap() async {
  try {
    await initializeWindow();
  } catch (_) {}
  final settings = await SettingsStore.load();
  final stats = await StatsStore.load();
  runApp(ZhenzhongApp(settings: settings, stats: stats));
}

class ZhenzhongApp extends StatelessWidget {
  final SettingsStore settings;
  final StatsStore stats;
  final UpdateStore updates;
  final MahjongGame game;
  final LinkOpener linkOpener;
  final WindowActions windowActions;

  ZhenzhongApp({
    super.key,
    required this.settings,
    required this.stats,
    UpdateStore? updates,
    MahjongGame? game,
    LinkOpener? linkOpener,
    this.windowActions = defaultWindowActions,
  })  : updates = updates ?? UpdateStore(),
        game = game ?? MahjongGame(),
        linkOpener = linkOpener ?? LinkOpener();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) => MaterialApp(
        onGenerateTitle: (context) => l10n(context).appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: settings.themeMode == AppThemeMode.oled
            ? AppTheme.oled()
            : AppTheme.dark(),
        themeMode: settings.materialThemeMode,
        locale: settings.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (device, supported) {
          if (device != null) {
            for (final locale in supported) {
              if (locale.languageCode == device.languageCode) {
                return locale;
              }
            }
          }
          return systemLocale;
        },
        home: AppShell(
          actions: windowActions,
          destinations: [
            NavDestination(
              icon: Icons.grid_4x4,
              label: (l) => l.navGame,
              buildPage: () => GamePage(game: game, stats: stats),
            ),
            NavDestination(
              icon: Icons.help_outline,
              label: (l) => l.navHelp,
              buildPage: () => HelpPage(),
            ),
            NavDestination(
              icon: Icons.settings_outlined,
              label: (l) => l.navSettings,
              buildPage: () => SettingsPage(settings: settings),
            ),
            NavDestination(
              icon: Icons.info_outline,
              label: (l) => l.navAbout,
              buildPage: () =>
                  AboutPage(updates: updates, stats: stats, linkOpener: linkOpener),
            ),
          ],
        ),
      ),
    );
  }
}
