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
  String get tagline => 'Свободный пасьянс маджонг с открытым кодом';

  @override
  String get play => 'Играть в браузере';

  @override
  String get download => 'Скачать';

  @override
  String get releases => 'Релизы на GitLab';

  @override
  String get flatpak => 'Установка Flatpak в один клик';

  @override
  String get theme => 'Тема';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeOled => 'OLED';

  @override
  String get featuresTitle => 'Почему 震中';

  @override
  String get f1 => 'Классическая раскладка, 144 кости';

  @override
  String get f2 => 'Подсказки, отмена и перемешивание';

  @override
  String get f3 => 'Десктоп, мобильные и веб';

  @override
  String get f4 => 'Без рекламы и слежки, AGPL-3.0';

  @override
  String get loadingReleases => 'Загрузка релизов…';

  @override
  String get noReleases => 'Релизов пока нет';

  @override
  String get flatpakCmd => 'Установить через Flatpak';

  @override
  String get sourceCode => 'Исходный код';
}
