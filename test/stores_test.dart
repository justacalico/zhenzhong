import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zhenzhong/models/app_update.dart';
import 'package:zhenzhong/state/settings_store.dart';
import 'package:zhenzhong/state/stats_store.dart';
import 'package:zhenzhong/state/update_store.dart';

import 'helpers.dart';

void main() {
  group('SettingsStore', () {
    test('defaults to system theme and system locale', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await SettingsStore.load();
      expect(store.themeMode, AppThemeMode.system);
      expect(store.materialThemeMode, ThemeMode.system);
      expect(store.locale, isNull);
    });

    test('loads persisted theme and locale', () async {
      SharedPreferences.setMockInitialValues({
        'theme_mode': AppThemeMode.oled.index,
        'locale': 'zh',
      });
      final store = await SettingsStore.load();
      expect(store.themeMode, AppThemeMode.oled);
      expect(store.materialThemeMode, ThemeMode.dark);
      expect(store.locale, const Locale('zh'));
    });

    test('loads persisted region locale', () async {
      SharedPreferences.setMockInitialValues({'locale': 'en_GB'});
      final store = await SettingsStore.load();
      expect(store.locale, const Locale('en', 'GB'));
    });

    test('setThemeMode persists and notifies', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await SettingsStore.load();
      var notified = 0;
      store.addListener(() => notified++);
      await store.setThemeMode(AppThemeMode.light);
      expect(notified, 1);
      expect(store.materialThemeMode, ThemeMode.light);
      await store.setThemeMode(AppThemeMode.light);
      expect(notified, 1);
      await store.setThemeMode(AppThemeMode.dark);
      expect(store.materialThemeMode, ThemeMode.dark);
      expect(
        (await SharedPreferences.getInstance()).getInt('theme_mode'),
        AppThemeMode.dark.index,
      );
    });

    test('setLocale persists and removes for system', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await SettingsStore.load();
      var notified = 0;
      store.addListener(() => notified++);
      await store.setLocale(const Locale('ru'));
      expect(notified, 1);
      expect(store.locale, const Locale('ru'));
      expect(
        (await SharedPreferences.getInstance()).getString('locale'),
        'ru',
      );
      await store.setLocale(const Locale('en', 'GB'));
      expect(
        (await SharedPreferences.getInstance()).getString('locale'),
        'en_GB',
      );
      await store.setLocale(const Locale('ru'));
      expect(notified, 3);
      await store.setLocale(null);
      expect(store.locale, isNull);
      expect(
        (await SharedPreferences.getInstance()).getString('locale'),
        isNull,
      );
    });

    test('setHighlightFreeOnly persists and notifies', () async {
      SharedPreferences.setMockInitialValues(
          {'highlight_free_only': true});
      var store = await SettingsStore.load();
      expect(store.highlightFreeOnly, isTrue);
      var notified = 0;
      store.addListener(() => notified++);
      await store.setHighlightFreeOnly(true);
      expect(notified, 0);
      await store.setHighlightFreeOnly(false);
      expect(notified, 1);
      expect(store.highlightFreeOnly, isFalse);
      expect(
        (await SharedPreferences.getInstance())
            .getBool('highlight_free_only'),
        isFalse,
      );
      SharedPreferences.setMockInitialValues({});
      store = await SettingsStore.load();
      expect(store.highlightFreeOnly, isFalse);
    });
  });

  group('StatsStore', () {
    test('records wins and best time', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await StatsStore.load();
      expect(store.gamesPlayed, 0);
      expect(store.bestSeconds, isNull);
      var notified = 0;
      store.addListener(() => notified++);
      await store.recordGame(won: true, seconds: 300);
      expect(notified, 1);
      expect(store.gamesPlayed, 1);
      expect(store.gamesWon, 1);
      expect(store.bestSeconds, 300);
      await store.recordGame(won: true, seconds: 400);
      expect(store.bestSeconds, 300);
      await store.recordGame(won: false, seconds: 0);
      expect(store.gamesPlayed, 3);
      expect(store.gamesWon, 2);
    });

    test('reloads persisted stats', () async {
      SharedPreferences.setMockInitialValues({
        'stats_played': 5,
        'stats_won': 2,
        'stats_best_seconds': 123,
      });
      final store = await StatsStore.load();
      expect(store.gamesPlayed, 5);
      expect(store.gamesWon, 2);
      expect(store.bestSeconds, 123);
    });
  });

  group('UpdateStore', () {
    test('successful check caches the update', () async {
      final checker = FakeVersionChecker()
        ..result = const AppUpdate(
          currentVersion: '1.0.0',
          latestVersion: '2.0.0',
          updateAvailable: true,
          releaseUrl: 'u',
        );
      final store = UpdateStore(
        checker: checker,
        versionOf: () async => '1.0.0',
      );
      var notified = 0;
      store.addListener(() => notified++);
      await store.check();
      expect(checker.calls, 1);
      expect(store.update!.latestVersion, '2.0.0');
      expect(store.checking, isFalse);
      expect(store.failed, isFalse);
      expect(notified, 2);
    });

    test('failed check sets the failed flag', () async {
      final store = UpdateStore(
        checker: FakeVersionChecker()..error = 'offline',
        versionOf: () async => '1.0.0',
      );
      await store.check();
      expect(store.failed, isTrue);
      expect(store.update, isNull);
      expect(store.checking, isFalse);
    });

    test('concurrent checks share one request', () async {
      final checker = FakeVersionChecker();
      final store = UpdateStore(
        checker: checker,
        versionOf: () async => '1.0.0',
      );
      await Future.wait([store.check(), store.check(), store.check()]);
      expect(checker.calls, 1);
    });

    test('installedVersion passes through', () async {
      final store = UpdateStore(
        checker: FakeVersionChecker(),
        versionOf: () async => '3.2.1',
      );
      expect(await store.installedVersion(), '3.2.1');
    });
  });
}

