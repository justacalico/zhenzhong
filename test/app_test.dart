import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zhenzhong/app.dart';
import 'package:zhenzhong/main.dart' as app;
import 'package:zhenzhong/state/settings_store.dart';
import 'package:zhenzhong/theme/app_theme.dart';
import 'package:zhenzhong/widgets/app_shell.dart';
import 'package:zhenzhong/widgets/sidebar.dart';

import 'helpers.dart';

void main() {
  setUpAll(loadTestFonts);

  testWidgets('main bootstraps the full app', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await app.main();
    await tester.pump();
    expect(find.byType(ZhenzhongApp), findsOneWidget);
    expect(find.byType(AppShell), findsOneWidget);
    expect(find.byType(NavSidebar), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('app honours the stored locale', (tester) async {
    SharedPreferences.setMockInitialValues({'locale': 'zh'});
    final settings = await testSettings();
    await tester.pumpWidget(testApp(
      settings: settings,
      stats: await testStats(),
    ));
    await tester.pump();
    expect(find.text('新游戏'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('app honours the stored Russian locale', (tester) async {
    SharedPreferences.setMockInitialValues({'locale': 'ru'});
    final settings = await testSettings();
    await tester.pumpWidget(testApp(
      settings: settings,
      stats: await testStats(),
    ));
    await tester.pump();
    expect(find.text('Новая игра'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('app honours the stored Irish locale', (tester) async {
    SharedPreferences.setMockInitialValues({'locale': 'ga'});
    final settings = await testSettings();
    await tester.pumpWidget(testApp(
      settings: settings,
      stats: await testStats(),
    ));
    await tester.pump();
    expect(find.text('Cluiche nua'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('app falls back to English for unsupported locales',
      (tester) async {
    tester.platformDispatcher.localeTestValue = const Locale('fr', 'FR');
    addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());
    final settings = await testSettings();
    await tester.pumpWidget(testApp(
      settings: settings,
      stats: await testStats(),
    ));
    await tester.pump();
    expect(find.text('New Game'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('app picks zh for a Chinese device locale', (tester) async {
    tester.platformDispatcher.localeTestValue = const Locale('zh', 'CN');
    addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());
    final settings = await testSettings();
    await tester.pumpWidget(testApp(
      settings: settings,
      stats: await testStats(),
    ));
    await tester.pump();
    expect(find.text('新游戏'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('oled mode swaps the dark theme', (tester) async {
    SharedPreferences.setMockInitialValues({
      'theme_mode': AppThemeMode.oled.index,
    });
    final settings = await testSettings();
    await tester.pumpWidget(testApp(
      settings: settings,
      stats: await testStats(),
    ));
    await tester.pump();
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.darkTheme!.scaffoldBackgroundColor, Colors.black);
    await tester.pumpWidget(const SizedBox());
  });

  test('theme data is sane', () {
    expect(AppTheme.light().brightness, Brightness.light);
    expect(AppTheme.dark().brightness, Brightness.dark);
    expect(AppTheme.oled().scaffoldBackgroundColor, Colors.black);
  });
}
