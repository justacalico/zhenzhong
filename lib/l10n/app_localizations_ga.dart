// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Irish (`ga`).
class AppLocalizationsGa extends AppLocalizations {
  AppLocalizationsGa([String locale = 'ga']) : super(locale);

  @override
  String get appTitle => '震中 Zhenzhong';

  @override
  String get navGame => 'Cluiche';

  @override
  String get navHelp => 'Conas a imirt';

  @override
  String get navSettings => 'Socruithe';

  @override
  String get navAbout => 'Faoi';

  @override
  String get newGame => 'Cluiche nua';

  @override
  String get hint => 'Leid';

  @override
  String get undo => 'Cealaigh';

  @override
  String get shuffle => 'Measc';

  @override
  String timeElapsed(Object time) {
    return 'Am $time';
  }

  @override
  String tilesRemaining(Object count) {
    return 'Tíleanna fágtha $count';
  }

  @override
  String freePairs(Object count) {
    return 'Péirí saora $count';
  }

  @override
  String get wonTitle => 'Bord glanta!';

  @override
  String wonBody(Object time) {
    return 'Bhain tú gach tíl den bhord i $time.';
  }

  @override
  String get stuckTitle => 'Gan aon chor';

  @override
  String get stuckBody =>
      'Níl aon phéire saor fágtha. Measc na tíleanna atá fágtha nó tosaigh cluiche nua.';

  @override
  String get playAgain => 'Imirt arís';

  @override
  String get keepPlaying => 'Lean ar aghaidh';

  @override
  String get close => 'Dún';

  @override
  String get settingsLanguage => 'Teanga';

  @override
  String get settingsTheme => 'Téama';

  @override
  String get languageSystem => 'Córas';

  @override
  String get languageEnGB => 'Traditional English';

  @override
  String get themeSystem => 'Córas';

  @override
  String get themeLight => 'Geal';

  @override
  String get themeDark => 'Dorcha';

  @override
  String get themeOled => 'OLED';

  @override
  String get helpGoalTitle => 'Sprioc';

  @override
  String get helpGoal =>
      'Glan an bord trí phéirí tíleanna saora a mheaitseálann a chéile a bhaint, díreach mar aon le solitaire Mahjongg clasaiceach.';

  @override
  String get helpFreeTitle => 'Tíleanna saora';

  @override
  String get helpFree =>
      'Tá tíl saor nuair nach bhfuil aon tíl eile ina luí uirthi agus nuair atá a taobh clé nó a taobh deas ar a laghad oscailte. Tá tíleanna blocáilte dorchaithe.';

  @override
  String get helpMatchTitle => 'Meaitseáil';

  @override
  String get helpMatch =>
      'Meaitseálann an chuid is mó de na tíleanna le tíl chomhionann. Meaitseálann aon bhláth le haon bhláth eile, agus aon séasúr le haon séasúr eile.';

  @override
  String get helpControlsTitle => 'Rialuithe';

  @override
  String get helpControls =>
      'Tapáil tíl shaor chun í a roghnú, ansin tapáil tíl mheaitseáilte chun an péire a bhaint. Bain úsáid as Leid nuair a bhíonn tú greamaithe, Cealaigh chun cúl a ghlacadh, agus Measc chun na tíleanna atá fágtha a athdheileáil.';

  @override
  String aboutVersion(Object version) {
    return 'Leagan $version';
  }

  @override
  String get checkForUpdates => 'Seiceáil do nuashonruithe';

  @override
  String get updateChecking => 'Á seiceáil…';

  @override
  String get updateUpToDate => 'Tá 震中 cothrom le dáta';

  @override
  String get updateFailed =>
      'Níorbh fhéidir nuashonruithe a sheiceáil. Bain triail eile as níos déanaí.';

  @override
  String updateAvailable(Object version) {
    return 'Tá leagan $version ar fáil';
  }

  @override
  String get updateViewRelease => 'Féach ar an eisiúint seo';

  @override
  String get updateAllReleases => 'Gach eisiúint';

  @override
  String get aboutSource => 'Cód foinse';

  @override
  String get aboutLicence => 'Ceadúnas: AGPL-3.0';

  @override
  String get statistics => 'Staitisticí';

  @override
  String get statsGamesPlayed => 'Cluichí imeartha';

  @override
  String get statsGamesWon => 'Cluichí buaite';

  @override
  String get statsBestTime => 'Am is fearr';

  @override
  String get statsNoGames => 'Gan aon chluiche fós';

  @override
  String get windowClose => 'Dún';

  @override
  String get windowMinimize => 'Íoslaghdaigh';

  @override
  String get windowMaximise => 'Uasmhéadaigh';

  @override
  String get suitCharacters => 'Carachtair';

  @override
  String get suitBamboo => 'Bambú';

  @override
  String get suitCircles => 'Ciorcail';

  @override
  String get suitWind => 'Gaotha';

  @override
  String get suitDragon => 'Dragain';

  @override
  String get suitFlower => 'Bláthanna';

  @override
  String get suitSeason => 'Séasúir';
}
