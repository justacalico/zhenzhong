import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ga.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('en', 'GB'),
    Locale('ga'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en_GB, this message translates to:
  /// **'震中 Zhenzhong'**
  String get appTitle;

  /// No description provided for @navGame.
  ///
  /// In en_GB, this message translates to:
  /// **'Game'**
  String get navGame;

  /// No description provided for @navHelp.
  ///
  /// In en_GB, this message translates to:
  /// **'How to Play'**
  String get navHelp;

  /// No description provided for @navSettings.
  ///
  /// In en_GB, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navAbout.
  ///
  /// In en_GB, this message translates to:
  /// **'About'**
  String get navAbout;

  /// No description provided for @newGame.
  ///
  /// In en_GB, this message translates to:
  /// **'New Game'**
  String get newGame;

  /// No description provided for @hint.
  ///
  /// In en_GB, this message translates to:
  /// **'Hint'**
  String get hint;

  /// No description provided for @undo.
  ///
  /// In en_GB, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @shuffle.
  ///
  /// In en_GB, this message translates to:
  /// **'Shuffle'**
  String get shuffle;

  /// No description provided for @timeElapsed.
  ///
  /// In en_GB, this message translates to:
  /// **'Time {time}'**
  String timeElapsed(Object time);

  /// No description provided for @tilesRemaining.
  ///
  /// In en_GB, this message translates to:
  /// **'Tiles left {count}'**
  String tilesRemaining(Object count);

  /// No description provided for @freePairs.
  ///
  /// In en_GB, this message translates to:
  /// **'Free pairs {count}'**
  String freePairs(Object count);

  /// No description provided for @wonTitle.
  ///
  /// In en_GB, this message translates to:
  /// **'Board cleared!'**
  String get wonTitle;

  /// No description provided for @wonBody.
  ///
  /// In en_GB, this message translates to:
  /// **'You removed every tile in {time}.'**
  String wonBody(Object time);

  /// No description provided for @stuckTitle.
  ///
  /// In en_GB, this message translates to:
  /// **'No moves left'**
  String get stuckTitle;

  /// No description provided for @stuckBody.
  ///
  /// In en_GB, this message translates to:
  /// **'No free pairs remain. Shuffle the remaining tiles or start a new game.'**
  String get stuckBody;

  /// No description provided for @playAgain.
  ///
  /// In en_GB, this message translates to:
  /// **'Play again'**
  String get playAgain;

  /// No description provided for @keepPlaying.
  ///
  /// In en_GB, this message translates to:
  /// **'Keep playing'**
  String get keepPlaying;

  /// No description provided for @close.
  ///
  /// In en_GB, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @settingsLanguage.
  ///
  /// In en_GB, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en_GB, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @languageSystem.
  ///
  /// In en_GB, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageEnGB.
  ///
  /// In en_GB, this message translates to:
  /// **'Traditional English'**
  String get languageEnGB;

  /// No description provided for @themeSystem.
  ///
  /// In en_GB, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en_GB, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en_GB, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeOled.
  ///
  /// In en_GB, this message translates to:
  /// **'OLED'**
  String get themeOled;

  /// No description provided for @helpGoalTitle.
  ///
  /// In en_GB, this message translates to:
  /// **'Goal'**
  String get helpGoalTitle;

  /// No description provided for @helpGoal.
  ///
  /// In en_GB, this message translates to:
  /// **'Clear the board by removing matching pairs of free tiles, just like the classic Mahjongg solitaire.'**
  String get helpGoal;

  /// No description provided for @helpFreeTitle.
  ///
  /// In en_GB, this message translates to:
  /// **'Free tiles'**
  String get helpFreeTitle;

  /// No description provided for @helpFree.
  ///
  /// In en_GB, this message translates to:
  /// **'A tile is free when no tile covers it and at least one of its left or right sides is open. Blocked tiles appear dimmed.'**
  String get helpFree;

  /// No description provided for @helpMatchTitle.
  ///
  /// In en_GB, this message translates to:
  /// **'Matching'**
  String get helpMatchTitle;

  /// No description provided for @helpMatch.
  ///
  /// In en_GB, this message translates to:
  /// **'Most tiles pair with an identical tile. Any flower pairs with any flower, and any season pairs with any season.'**
  String get helpMatch;

  /// No description provided for @helpControlsTitle.
  ///
  /// In en_GB, this message translates to:
  /// **'Controls'**
  String get helpControlsTitle;

  /// No description provided for @helpControls.
  ///
  /// In en_GB, this message translates to:
  /// **'Tap a free tile to select it, then tap a matching free tile to remove the pair. Use Hint when you are stuck, Undo to take a move back, and Shuffle to redeal the remaining tiles.'**
  String get helpControls;

  /// No description provided for @aboutVersion.
  ///
  /// In en_GB, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(Object version);

  /// No description provided for @checkForUpdates.
  ///
  /// In en_GB, this message translates to:
  /// **'Check for updates'**
  String get checkForUpdates;

  /// No description provided for @updateChecking.
  ///
  /// In en_GB, this message translates to:
  /// **'Checking…'**
  String get updateChecking;

  /// No description provided for @updateUpToDate.
  ///
  /// In en_GB, this message translates to:
  /// **'震中 is up to date'**
  String get updateUpToDate;

  /// No description provided for @updateFailed.
  ///
  /// In en_GB, this message translates to:
  /// **'Couldn\'t check for updates. Try again later.'**
  String get updateFailed;

  /// No description provided for @updateAvailable.
  ///
  /// In en_GB, this message translates to:
  /// **'Version {version} is available'**
  String updateAvailable(Object version);

  /// No description provided for @updateViewRelease.
  ///
  /// In en_GB, this message translates to:
  /// **'View this release'**
  String get updateViewRelease;

  /// No description provided for @updateAllReleases.
  ///
  /// In en_GB, this message translates to:
  /// **'All releases'**
  String get updateAllReleases;

  /// No description provided for @aboutSource.
  ///
  /// In en_GB, this message translates to:
  /// **'Source code'**
  String get aboutSource;

  /// No description provided for @aboutLicence.
  ///
  /// In en_GB, this message translates to:
  /// **'Licence: AGPL-3.0'**
  String get aboutLicence;

  /// No description provided for @statistics.
  ///
  /// In en_GB, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @statsGamesPlayed.
  ///
  /// In en_GB, this message translates to:
  /// **'Games played'**
  String get statsGamesPlayed;

  /// No description provided for @statsGamesWon.
  ///
  /// In en_GB, this message translates to:
  /// **'Games won'**
  String get statsGamesWon;

  /// No description provided for @statsBestTime.
  ///
  /// In en_GB, this message translates to:
  /// **'Best time'**
  String get statsBestTime;

  /// No description provided for @statsNoGames.
  ///
  /// In en_GB, this message translates to:
  /// **'No games yet'**
  String get statsNoGames;

  /// No description provided for @windowClose.
  ///
  /// In en_GB, this message translates to:
  /// **'Close'**
  String get windowClose;

  /// No description provided for @windowMinimize.
  ///
  /// In en_GB, this message translates to:
  /// **'Minimise'**
  String get windowMinimize;

  /// No description provided for @windowMaximise.
  ///
  /// In en_GB, this message translates to:
  /// **'Maximise'**
  String get windowMaximise;

  /// No description provided for @suitCharacters.
  ///
  /// In en_GB, this message translates to:
  /// **'Characters'**
  String get suitCharacters;

  /// No description provided for @suitBamboo.
  ///
  /// In en_GB, this message translates to:
  /// **'Bamboo'**
  String get suitBamboo;

  /// No description provided for @suitCircles.
  ///
  /// In en_GB, this message translates to:
  /// **'Circles'**
  String get suitCircles;

  /// No description provided for @suitWind.
  ///
  /// In en_GB, this message translates to:
  /// **'Winds'**
  String get suitWind;

  /// No description provided for @suitDragon.
  ///
  /// In en_GB, this message translates to:
  /// **'Dragons'**
  String get suitDragon;

  /// No description provided for @suitFlower.
  ///
  /// In en_GB, this message translates to:
  /// **'Flowers'**
  String get suitFlower;

  /// No description provided for @suitSeason.
  ///
  /// In en_GB, this message translates to:
  /// **'Seasons'**
  String get suitSeason;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ga', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'GB':
            return AppLocalizationsEnGb();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ga':
      return AppLocalizationsGa();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
