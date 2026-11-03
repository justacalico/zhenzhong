// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => '震中 Zhenzhong';

  @override
  String get navGame => 'Игра';

  @override
  String get navHelp => 'Как играть';

  @override
  String get navSettings => 'Настройки';

  @override
  String get navAbout => 'О программе';

  @override
  String get newGame => 'Новая игра';

  @override
  String get hint => 'Подсказка';

  @override
  String get undo => 'Отменить';

  @override
  String get shuffle => 'Перемешать';

  @override
  String timeElapsed(Object time) {
    return 'Время $time';
  }

  @override
  String tilesRemaining(Object count) {
    return 'Осталось костей $count';
  }

  @override
  String freePairs(Object count) {
    return 'Свободных пар $count';
  }

  @override
  String get wonTitle => 'Поле очищено!';

  @override
  String wonBody(Object time) {
    return 'Вы убрали все кости за $time.';
  }

  @override
  String get stuckTitle => 'Ходов нет';

  @override
  String get stuckBody =>
      'Свободных пар не осталось. Перемешайте кости или начните новую игру.';

  @override
  String get playAgain => 'Играть снова';

  @override
  String get keepPlaying => 'Продолжить';

  @override
  String get close => 'Закрыть';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get languageSystem => 'Системный';

  @override
  String get languageEnGB => 'Traditional English';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeOled => 'OLED';

  @override
  String get helpGoalTitle => 'Цель';

  @override
  String get helpGoal =>
      'Очистите поле, убирая одинаковые пары свободных костей, как в классическом пасьянсе маджонг.';

  @override
  String get helpFreeTitle => 'Свободные кости';

  @override
  String get helpFree =>
      'Кость свободна, если её ничто не накрывает и хотя бы одна сторона, левая или правая, открыта. Заблокированные кости затемнены.';

  @override
  String get helpMatchTitle => 'Пары';

  @override
  String get helpMatch =>
      'Большинство костей снимаются одинаковой парой. Любой цветок сочетается с любым цветком, а любое время года — с любым временем года.';

  @override
  String get helpControlsTitle => 'Управление';

  @override
  String get helpControls =>
      'Коснитесь свободной кости, затем коснитесь подходящей пары, чтобы убрать их. Подсказка покажет ход, Отмена вернёт его, а Перемешать раздаст оставшиеся кости заново.';

  @override
  String aboutVersion(Object version) {
    return 'Версия $version';
  }

  @override
  String get checkForUpdates => 'Проверить обновления';

  @override
  String get updateChecking => 'Проверка…';

  @override
  String get updateUpToDate => '震中 обновлено';

  @override
  String get updateFailed =>
      'Не удалось проверить обновления. Попробуйте позже.';

  @override
  String updateAvailable(Object version) {
    return 'Доступна версия $version';
  }

  @override
  String get updateViewRelease => 'Открыть релиз';

  @override
  String get updateAllReleases => 'Все релизы';

  @override
  String get aboutSource => 'Исходный код';

  @override
  String get aboutLicence => 'Лицензия: AGPL-3.0';

  @override
  String get statistics => 'Статистика';

  @override
  String get statsGamesPlayed => 'Сыграно игр';

  @override
  String get statsGamesWon => 'Выиграно игр';

  @override
  String get statsBestTime => 'Лучшее время';

  @override
  String get statsNoGames => 'Игр пока нет';

  @override
  String get windowClose => 'Закрыть';

  @override
  String get windowMinimize => 'Свернуть';

  @override
  String get windowMaximise => 'Развернуть';

  @override
  String get suitCharacters => 'Иероглифы';

  @override
  String get suitBamboo => 'Бамбук';

  @override
  String get suitCircles => 'Круги';

  @override
  String get suitWind => 'Ветры';

  @override
  String get suitDragon => 'Драконы';

  @override
  String get suitFlower => 'Цветы';

  @override
  String get suitSeason => 'Времена года';
}
