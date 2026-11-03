import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:zhenzhong/l10n/app_localizations.dart';

void main() {
  test('every generated getter resolves for every locale', () async {
    for (final locale in AppLocalizations.supportedLocales) {
      final l = await AppLocalizations.delegate.load(locale);
      expect(l.appTitle, isNotEmpty);
      expect(l.navGame, isNotEmpty);
      expect(l.navHelp, isNotEmpty);
      expect(l.navSettings, isNotEmpty);
      expect(l.navAbout, isNotEmpty);
      expect(l.newGame, isNotEmpty);
      expect(l.hint, isNotEmpty);
      expect(l.undo, isNotEmpty);
      expect(l.shuffle, isNotEmpty);
      expect(l.timeElapsed(5), isNotEmpty);
      expect(l.tilesRemaining(3), isNotEmpty);
      expect(l.freePairs(2), isNotEmpty);
      expect(l.wonTitle, isNotEmpty);
      expect(l.wonBody('1:00'), isNotEmpty);
      expect(l.stuckTitle, isNotEmpty);
      expect(l.stuckBody, isNotEmpty);
      expect(l.playAgain, isNotEmpty);
      expect(l.keepPlaying, isNotEmpty);
      expect(l.close, isNotEmpty);
      expect(l.settingsLanguage, isNotEmpty);
      expect(l.settingsTheme, isNotEmpty);
      expect(l.languageSystem, isNotEmpty);
      expect(l.languageEnGB, isNotEmpty);
      expect(l.themeSystem, isNotEmpty);
      expect(l.themeLight, isNotEmpty);
      expect(l.themeDark, isNotEmpty);
      expect(l.themeOled, isNotEmpty);
      expect(l.helpGoalTitle, isNotEmpty);
      expect(l.helpGoal, isNotEmpty);
      expect(l.helpFreeTitle, isNotEmpty);
      expect(l.helpFree, isNotEmpty);
      expect(l.helpMatchTitle, isNotEmpty);
      expect(l.helpMatch, isNotEmpty);
      expect(l.helpControlsTitle, isNotEmpty);
      expect(l.helpControls, isNotEmpty);
      expect(l.aboutVersion('1.0.0'), isNotEmpty);
      expect(l.checkForUpdates, isNotEmpty);
      expect(l.updateChecking, isNotEmpty);
      expect(l.updateUpToDate, isNotEmpty);
      expect(l.updateFailed, isNotEmpty);
      expect(l.updateAvailable('2.0.0'), isNotEmpty);
      expect(l.updateViewRelease, isNotEmpty);
      expect(l.updateAllReleases, isNotEmpty);
      expect(l.aboutSource, isNotEmpty);
      expect(l.aboutLicence, isNotEmpty);
      expect(l.statistics, isNotEmpty);
      expect(l.statsGamesPlayed, isNotEmpty);
      expect(l.statsGamesWon, isNotEmpty);
      expect(l.statsBestTime, isNotEmpty);
      expect(l.statsNoGames, isNotEmpty);
      expect(l.windowClose, isNotEmpty);
      expect(l.windowMinimize, isNotEmpty);
      expect(l.windowMaximise, isNotEmpty);
      expect(l.suitCharacters, isNotEmpty);
      expect(l.suitBamboo, isNotEmpty);
      expect(l.suitCircles, isNotEmpty);
      expect(l.suitWind, isNotEmpty);
      expect(l.suitDragon, isNotEmpty);
      expect(l.suitFlower, isNotEmpty);
      expect(l.suitSeason, isNotEmpty);
    }
  });

  test('delegate and lookup cover every path', () {
    const delegate = AppLocalizations.delegate;
    expect(delegate.isSupported(const Locale('en')), isTrue);
    expect(delegate.isSupported(const Locale('xx')), isFalse);
    expect(delegate.shouldReload(delegate), isFalse);
    for (final locale in const [
      Locale('en', 'GB'),
      Locale('en'),
      Locale('ga'),
      Locale('ru'),
      Locale('zh'),
    ]) {
      expect(lookupAppLocalizations(locale).appTitle, isNotEmpty);
    }
    expect(() => lookupAppLocalizations(const Locale('xx')),
        throwsA(anything));
  });
}
