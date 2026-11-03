import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zhenzhong/game/board.dart';
import 'package:zhenzhong/widgets/app_shell.dart';

import 'helpers.dart';

void main() {
  setUpAll(loadTestFonts);

  Future<Widget> appUnderTest() async {
    final settings = await testSettings();
    return testApp(
      settings: settings,
      stats: await testStats(),
      game: MahjongGame(random: Random(42)),
      windowActions: FakeWindowActions(),
    );
  }

  Future<void> atDesktop(
    WidgetTester tester,
    Future<void> Function() body,
  ) async {
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

  testWidgets('desktop app shell golden', (tester) async {
    await atDesktop(tester, () async {
      await tester.pumpWidget(await appUnderTest());
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(AppShell),
        matchesGoldenFile('goldens/app_desktop.png'),
      );
    });
  });

  testWidgets('help page golden', (tester) async {
    await atDesktop(tester, () async {
      await tester.pumpWidget(await appUnderTest());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('nav_1')));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(AppShell),
        matchesGoldenFile('goldens/app_help.png'),
      );
    });
  });

  testWidgets('settings page golden', (tester) async {
    await atDesktop(tester, () async {
      await tester.pumpWidget(await appUnderTest());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('nav_2')));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(AppShell),
        matchesGoldenFile('goldens/app_settings.png'),
      );
    });
  });

  testWidgets('about page golden', (tester) async {
    await atDesktop(tester, () async {
      await tester.pumpWidget(await appUnderTest());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('nav_3')));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(AppShell),
        matchesGoldenFile('goldens/app_about.png'),
      );
    });
  });

  testWidgets('mobile shell golden', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    tester.view.physicalSize = const Size(420, 880);
    tester.view.devicePixelRatio = 1;
    try {
      await tester.pumpWidget(await appUnderTest());
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/app_mobile.png'),
      );
    } finally {
      debugDefaultTargetPlatformOverride = null;
      tester.view.reset();
      await tester.pumpWidget(const SizedBox());
    }
  });
}
