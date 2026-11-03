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
  String get tagline => '一款自由开源的麻将连连看游戏';

  @override
  String get play => '在浏览器中游玩';

  @override
  String get download => '下载';

  @override
  String get releases => 'GitLab 上的版本';

  @override
  String get flatpak => '一键 Flatpak 安装';

  @override
  String get theme => '主题';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get themeOled => 'OLED';

  @override
  String get featuresTitle => '为什么选择震中';

  @override
  String get f1 => '经典乌龟布局，144 张牌';

  @override
  String get f2 => '提示、撤销与洗牌';

  @override
  String get f3 => '桌面、移动与网页';

  @override
  String get f4 => '无广告、无追踪、AGPL-3.0';

  @override
  String get loadingReleases => '正在加载版本…';

  @override
  String get noReleases => '暂无版本';

  @override
  String get flatpakCmd => '使用 Flatpak 安装';

  @override
  String get sourceCode => '源代码';
}
