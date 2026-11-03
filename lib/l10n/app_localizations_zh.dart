// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '震中 Zhenzhong';

  @override
  String get navGame => '游戏';

  @override
  String get navHelp => '玩法说明';

  @override
  String get navSettings => '设置';

  @override
  String get navAbout => '关于';

  @override
  String get newGame => '新游戏';

  @override
  String get hint => '提示';

  @override
  String get undo => '撤销';

  @override
  String get shuffle => '洗牌';

  @override
  String timeElapsed(Object time) {
    return '用时 $time';
  }

  @override
  String tilesRemaining(Object count) {
    return '剩余牌 $count';
  }

  @override
  String freePairs(Object count) {
    return '可用对子 $count';
  }

  @override
  String get wonTitle => '牌桌已清空！';

  @override
  String wonBody(Object time) {
    return '你在 $time 内移除了所有的牌。';
  }

  @override
  String get stuckTitle => '无牌可消';

  @override
  String get stuckBody => '没有可用的对子了。可以洗混剩余的牌或开始新游戏。';

  @override
  String get playAgain => '再来一局';

  @override
  String get keepPlaying => '继续游戏';

  @override
  String get close => '关闭';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsTiles => '牌面';

  @override
  String get highlightFreeOnly => '仅高亮可用的牌';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get languageEnGB => 'Traditional English';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get themeOled => 'OLED';

  @override
  String get helpGoalTitle => '目标';

  @override
  String get helpGoal => '像经典的麻将连连看一样，成对移除可用的相同牌，清空整个牌桌。';

  @override
  String get helpFreeTitle => '可用牌';

  @override
  String get helpFree =>
      '一张牌在没有被压住，且左侧或右侧至少有一边敞开时就是可用的。在设置中开启“仅高亮可用的牌”可以让其它牌变暗。';

  @override
  String get helpMatchTitle => '配对';

  @override
  String get helpMatch => '大部分牌需要完全相同才能配对。任意花牌可以互相配对，任意季牌也可以互相配对。';

  @override
  String get helpControlsTitle => '操作';

  @override
  String get helpControls =>
      '点一张可用牌选中它，再点一张匹配的可用牌即可消除。卡住时用提示，点错了用撤销，也可以用洗牌重新排列剩余的牌。';

  @override
  String aboutVersion(Object version) {
    return '版本 $version';
  }

  @override
  String get checkForUpdates => '检查更新';

  @override
  String get updateChecking => '正在检查…';

  @override
  String get updateUpToDate => '震中已是最新版本';

  @override
  String get updateFailed => '无法检查更新，请稍后再试。';

  @override
  String updateAvailable(Object version) {
    return '新版本 $version 可用';
  }

  @override
  String get updateViewRelease => '查看此版本';

  @override
  String get updateAllReleases => '所有版本';

  @override
  String get aboutSource => '源代码';

  @override
  String get aboutLicence => '许可证：AGPL-3.0';

  @override
  String get statistics => '统计';

  @override
  String get statsGamesPlayed => '已玩局数';

  @override
  String get statsGamesWon => '已胜局数';

  @override
  String get statsBestTime => '最佳用时';

  @override
  String get statsNoGames => '还没有玩过';

  @override
  String get windowClose => '关闭';

  @override
  String get windowMinimize => '最小化';

  @override
  String get windowMaximise => '最大化';

  @override
  String get suitCharacters => '万子';

  @override
  String get suitBamboo => '条子';

  @override
  String get suitCircles => '筒子';

  @override
  String get suitWind => '风牌';

  @override
  String get suitDragon => '箭牌';

  @override
  String get suitFlower => '花牌';

  @override
  String get suitSeason => '季牌';
}
