import 'package:flutter/foundation.dart';
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

  Future<void> withDesktop(
      WidgetTester tester, Future<void> Function() body) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    try {
      await body();
    } finally {
      debugDefaultTargetPlatformOverride = null;
      tester.view.reset();
      await tester.pumpWidget(const SizedBox());
    }
  }

  Future<Widget> appFor(Map<String, Object> prefs) async => testApp(
        settings: await testSettings(prefs: prefs),
        stats: await testStats(prefs: prefs),
      );

  testWidgets('main bootstraps the full app', (tester) async {
    await withDesktop(tester, () async {
      SharedPreferences.setMockInitialValues({});
      await app.main();
      await tester.pump();
      expect(find.byType(ZhenzhongApp), findsOneWidget);
      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(NavSidebar), findsOneWidget);
    });
  });

  testWidgets('app honours the stored locale', (tester) async {
    await withDesktop(tester, () async {
      await tester.pumpWidget(await appFor({'locale': 'zh'}));
      await tester.pump();
      expect(find.text('新游戏'), findsOneWidget);
    });
  });

  testWidgets('app honours the stored Russian locale', (tester) async {
    await withDesktop(tester, () async {
      await tester.pumpWidget(await appFor({'locale': 'ru'}));
      await tester.pump();
      expect(find.text('Новая игра'), findsOneWidget);
    });
  });

  testWidgets('app honours the stored Irish locale', (tester) async {
    await withDesktop(tester, () async {
      await tester.pumpWidget(await appFor({'locale': 'ga'}));
      await tester.pump();
      expect(find.text('Cluiche nua'), findsOneWidget);
    });
  });

  testWidgets('app falls back to English for unsupported locales',
      (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('fr', 'FR')];
    await withDesktop(tester, () async {
      try {
        await tester.pumpWidget(await appFor({}));
        await tester.pump();
        expect(find.text('New Game'), findsOneWidget);
      } finally {
        tester.platformDispatcher.clearLocaleTestValue();
      }
    });
  });

  testWidgets('app picks zh for a Chinese device locale', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('zh', 'CN')];
    await withDesktop(tester, () async {
      try {
        await tester.pumpWidget(await appFor({}));
        await tester.pump();
        expect(find.text('新游戏'), findsOneWidget);
      } finally {
        tester.platformDispatcher.clearLocaleTestValue();
      }
    });
  });

  testWidgets('oled mode swaps the dark theme', (tester) async {
    await withDesktop(tester, () async {
      await tester.pumpWidget(
          await appFor({'theme_mode': AppThemeMode.oled.index}));
      await tester.pump();
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.darkTheme!.scaffoldBackgroundColor, Colors.black);
    });
  });

  test('theme data is sane', () {
    expect(AppTheme.light().brightness, Brightness.light);
    expect(AppTheme.dark().brightness, Brightness.dark);
    expect(AppTheme.oled().scaffoldBackgroundColor, Colors.black);
  });
}
