import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zhenzhong/services/window_actions.dart';
import 'package:zhenzhong/widgets/app_shell.dart';
import 'package:zhenzhong/widgets/sidebar.dart';
import 'package:zhenzhong/widgets/title_bar.dart';

import 'helpers.dart';

List<NavDestination> destinations() => [
      NavDestination(
        icon: Icons.one_k,
        label: (l) => 'Page One',
        buildPage: () => const Text('page-one-body'),
      ),
      NavDestination(
        icon: Icons.two_k,
        label: (l) => 'Page Two',
        buildPage: () => const Text('page-two-body'),
      ),
    ];

Widget shellApp({WindowActions? actions}) => MaterialApp(
      localizationsDelegates: testDelegates,
      supportedLocales: testLocales,
      home: AppShell(
        destinations: destinations(),
        actions: actions ?? FakeWindowActions(),
      ),
    );

void main() {
  setUpAll(loadTestFonts);

  testWidgets('desktop shell shows titlebar and sidebar, taps navigate',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    try {
      await tester.pumpWidget(shellApp());
      expect(find.byType(MacTitleBar), findsOneWidget);
      expect(find.byType(NavSidebar), findsOneWidget);
      expect(find.text('page-one-body'), findsOneWidget);
      expect(find.text('page-two-body'), findsNothing);

      await tester.tap(find.byKey(const Key('nav_1')));
      await tester.pump();
      expect(find.text('page-two-body'), findsOneWidget);
      expect(find.text('page-one-body'), findsNothing);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('mobile shell uses a drawer', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    tester.view.physicalSize = const Size(500, 900);
    tester.view.devicePixelRatio = 1;
    try {
      await tester.pumpWidget(shellApp());
      expect(find.byType(MacTitleBar), findsNothing);
      expect(find.byType(NavSidebar), findsNothing);
      expect(find.byType(AppBar), findsOneWidget);

      final scaffold =
          tester.state<ScaffoldState>(find.byType(Scaffold).first);
      scaffold.openDrawer();
      await tester.pumpAndSettle();
      expect(find.byType(NavSidebar), findsOneWidget);
      await tester.tap(find.byKey(const Key('nav_1')));
      await tester.pumpAndSettle();
      expect(find.text('page-two-body'), findsOneWidget);
      expect(find.byType(NavSidebar), findsNothing);
    } finally {
      debugDefaultTargetPlatformOverride = null;
      tester.view.reset();
    }
  });

  test('isDesktopPlatform gates correctly', () {
    expect(isDesktopPlatform(TargetPlatform.linux), isTrue);
    expect(isDesktopPlatform(TargetPlatform.macOS), isTrue);
    expect(isDesktopPlatform(TargetPlatform.windows), isTrue);
    expect(isDesktopPlatform(TargetPlatform.android), isFalse);
    expect(isDesktopPlatform(TargetPlatform.iOS), isFalse);
    expect(isDesktopPlatform(TargetPlatform.fuchsia), isFalse);
  });
}
