import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zhenzhong/l10n/app_localizations.dart';
import 'package:zhenzhong/state/settings_store.dart';
import 'package:zhenzhong/state/stats_store.dart';
import 'package:zhenzhong/state/update_store.dart';
import 'package:zhenzhong/game/board.dart';
import 'package:zhenzhong/models/app_update.dart';
import 'package:zhenzhong/services/version_checker.dart';
import 'package:zhenzhong/services/window_actions.dart';
import 'package:zhenzhong/utils/link_opener.dart';
import 'package:zhenzhong/app.dart';

const testDelegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

const testLocales = AppLocalizations.supportedLocales;

var _fontsLoaded = false;

Future<void> loadTestFonts() async {
  if (_fontsLoaded) return;
  _fontsLoaded = true;
  for (final entry in {
    'NotoSans': [
      'assets/fonts/NotoSans-Regular.ttf',
      'assets/fonts/NotoSans-Bold.ttf',
    ],
    'NotoSansSC': [
      'assets/fonts/NotoSansSC-Regular.otf',
      'assets/fonts/NotoSansSC-Bold.otf',
    ],
  }.entries) {
    final loader = FontLoader(entry.key);
    for (final path in entry.value) {
      final bytes = await File(path).readAsBytes();
      loader.addFont(Future.value(bytes.buffer.asByteData()));
    }
    await loader.load();
  }
}

Future<SettingsStore> testSettings({Map<String, Object> prefs = const {}}) {
  SharedPreferences.setMockInitialValues(prefs);
  return SettingsStore.load();
}

Future<StatsStore> testStats({Map<String, Object> prefs = const {}}) {
  SharedPreferences.setMockInitialValues(prefs);
  return StatsStore.load();
}

class FakeWindowActions implements WindowActions {
  final List<String> calls = [];

  @override
  Future<void> close() async => calls.add('close');

  @override
  Future<void> minimize() async => calls.add('minimize');

  @override
  Future<void> startDrag() async => calls.add('drag');

  @override
  Future<void> toggleMaximize() async => calls.add('maximize');
}

class FakeLinkOpener {
  final List<Uri> opened = [];

  Future<bool> call(Uri uri) async {
    opened.add(uri);
    return true;
  }
}

class FakeVersionChecker extends VersionChecker {
  AppUpdate? result;
  Object? error;
  int calls = 0;
  Future<void>? gate;

  @override
  Future<AppUpdate> check(String currentVersion) async {
    calls++;
    await gate;
    if (error != null) throw error!;
    return result ??
        AppUpdate(
          currentVersion: currentVersion,
          releaseUrl: VersionChecker.releasesUrl,
        );
  }
}

Widget testApp({
  required SettingsStore settings,
  required StatsStore stats,
  UpdateStore? updates,
  MahjongGame? game,
  LinkOpener? linkOpener,
  WindowActions? windowActions,
}) {
  return ZhenzhongApp(
    settings: settings,
    stats: stats,
    updates: updates,
    game: game,
    linkOpener: linkOpener ?? LinkOpener(opener: FakeLinkOpener().call),
    windowActions: windowActions ?? FakeWindowActions(),
  );
}
