// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => '震中 Zhenzhong';

  @override
  String get navGame => 'Game';

  @override
  String get navHelp => 'How to Play';

  @override
  String get navSettings => 'Settings';

  @override
  String get navAbout => 'About';

  @override
  String get newGame => 'New Game';

  @override
  String get hint => 'Hint';

  @override
  String get undo => 'Undo';

  @override
  String get shuffle => 'Shuffle';

  @override
  String timeElapsed(Object time) {
    return 'Time $time';
  }

  @override
  String tilesRemaining(Object count) {
    return 'Tiles left $count';
  }

  @override
  String freePairs(Object count) {
    return 'Free pairs $count';
  }

  @override
  String get wonTitle => 'Board cleared!';

  @override
  String wonBody(Object time) {
    return 'You removed every tile in $time.';
  }

  @override
  String get stuckTitle => 'No moves left';

  @override
  String get stuckBody =>
      'No free pairs remain. Shuffle the remaining tiles or start a new game.';

  @override
  String get playAgain => 'Play again';

  @override
  String get keepPlaying => 'Keep playing';

  @override
  String get close => 'Close';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnGB => 'Traditional English';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeOled => 'OLED';

  @override
  String get helpGoalTitle => 'Goal';

  @override
  String get helpGoal =>
      'Clear the board by removing matching pairs of free tiles, just like the classic Mahjongg solitaire.';

  @override
  String get helpFreeTitle => 'Free tiles';

  @override
  String get helpFree =>
      'A tile is free when no tile covers it and at least one of its left or right sides is open. Blocked tiles appear dimmed.';

  @override
  String get helpMatchTitle => 'Matching';

  @override
  String get helpMatch =>
      'Most tiles pair with an identical tile. Any flower pairs with any flower, and any season pairs with any season.';

  @override
  String get helpControlsTitle => 'Controls';

  @override
  String get helpControls =>
      'Tap a free tile to select it, then tap a matching free tile to remove the pair. Use Hint when you are stuck, Undo to take a move back, and Shuffle to redeal the remaining tiles.';

  @override
  String aboutVersion(Object version) {
    return 'Version $version';
  }

  @override
  String get checkForUpdates => 'Check for updates';

  @override
  String get updateChecking => 'Checking…';

  @override
  String get updateUpToDate => '震中 is up to date';

  @override
  String get updateFailed => 'Couldn\'t check for updates. Try again later.';

  @override
  String updateAvailable(Object version) {
    return 'Version $version is available';
  }

  @override
  String get updateViewRelease => 'View this release';

  @override
  String get updateAllReleases => 'All releases';

  @override
  String get aboutSource => 'Source code';

  @override
  String get aboutLicence => 'Licence: AGPL-3.0';

  @override
  String get statistics => 'Statistics';

  @override
  String get statsGamesPlayed => 'Games played';

  @override
  String get statsGamesWon => 'Games won';

  @override
  String get statsBestTime => 'Best time';

  @override
  String get statsNoGames => 'No games yet';

  @override
  String get windowClose => 'Close';

  @override
  String get windowMinimize => 'Minimise';

  @override
  String get windowMaximise => 'Maximise';

  @override
  String get suitCharacters => 'Characters';

  @override
  String get suitBamboo => 'Bamboo';

  @override
  String get suitCircles => 'Circles';

  @override
  String get suitWind => 'Winds';

  @override
  String get suitDragon => 'Dragons';

  @override
  String get suitFlower => 'Flowers';

  @override
  String get suitSeason => 'Seasons';
}

/// The translations for English, as used in the United Kingdom (`en_GB`).
class AppLocalizationsEnGb extends AppLocalizationsEn {
  AppLocalizationsEnGb() : super('en_GB');

  @override
  String get appTitle => '震中 Zhenzhong';

  @override
  String get navGame => 'Game';

  @override
  String get navHelp => 'How to Play';

  @override
  String get navSettings => 'Settings';

  @override
  String get navAbout => 'About';

  @override
  String get newGame => 'New Game';

  @override
  String get hint => 'Hint';

  @override
  String get undo => 'Undo';

  @override
  String get shuffle => 'Shuffle';

  @override
  String timeElapsed(Object time) {
    return 'Time $time';
  }

  @override
  String tilesRemaining(Object count) {
    return 'Tiles left $count';
  }

  @override
  String freePairs(Object count) {
    return 'Free pairs $count';
  }

  @override
  String get wonTitle => 'Board cleared!';

  @override
  String wonBody(Object time) {
    return 'You removed every tile in $time.';
  }

  @override
  String get stuckTitle => 'No moves left';

  @override
  String get stuckBody =>
      'No free pairs remain. Shuffle the remaining tiles or start a new game.';

  @override
  String get playAgain => 'Play again';

  @override
  String get keepPlaying => 'Keep playing';

  @override
  String get close => 'Close';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnGB => 'Traditional English';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeOled => 'OLED';

  @override
  String get helpGoalTitle => 'Goal';

  @override
  String get helpGoal =>
      'Clear the board by removing matching pairs of free tiles, just like the classic Mahjongg solitaire.';

  @override
  String get helpFreeTitle => 'Free tiles';

  @override
  String get helpFree =>
      'A tile is free when no tile covers it and at least one of its left or right sides is open. Blocked tiles appear dimmed.';

  @override
  String get helpMatchTitle => 'Matching';

  @override
  String get helpMatch =>
      'Most tiles pair with an identical tile. Any flower pairs with any flower, and any season pairs with any season.';

  @override
  String get helpControlsTitle => 'Controls';

  @override
  String get helpControls =>
      'Tap a free tile to select it, then tap a matching free tile to remove the pair. Use Hint when you are stuck, Undo to take a move back, and Shuffle to redeal the remaining tiles.';

  @override
  String aboutVersion(Object version) {
    return 'Version $version';
  }

  @override
  String get checkForUpdates => 'Check for updates';

  @override
  String get updateChecking => 'Checking…';

  @override
  String get updateUpToDate => '震中 is up to date';

  @override
  String get updateFailed => 'Couldn\'t check for updates. Try again later.';

  @override
  String updateAvailable(Object version) {
    return 'Version $version is available';
  }

  @override
  String get updateViewRelease => 'View this release';

  @override
  String get updateAllReleases => 'All releases';

  @override
  String get aboutSource => 'Source code';

  @override
  String get aboutLicence => 'Licence: AGPL-3.0';

  @override
  String get statistics => 'Statistics';

  @override
  String get statsGamesPlayed => 'Games played';

  @override
  String get statsGamesWon => 'Games won';

  @override
  String get statsBestTime => 'Best time';

  @override
  String get statsNoGames => 'No games yet';

  @override
  String get windowClose => 'Close';

  @override
  String get windowMinimize => 'Minimise';

  @override
  String get windowMaximise => 'Maximise';

  @override
  String get suitCharacters => 'Characters';

  @override
  String get suitBamboo => 'Bamboo';

  @override
  String get suitCircles => 'Circles';

  @override
  String get suitWind => 'Winds';

  @override
  String get suitDragon => 'Dragons';

  @override
  String get suitFlower => 'Flowers';

  @override
  String get suitSeason => 'Seasons';
}
