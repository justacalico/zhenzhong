import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zhenzhong/models/app_update.dart';
import 'package:zhenzhong/services/version_checker.dart';
import 'package:zhenzhong/state/update_store.dart';
import 'package:zhenzhong/utils/link_opener.dart';
import 'package:zhenzhong/views/about_page.dart';

import 'helpers.dart';

Widget wrap(Widget child) => MaterialApp(
      localizationsDelegates: testDelegates,
      supportedLocales: testLocales,
      home: Scaffold(body: child),
    );

UpdateStore storeFor(FakeVersionChecker checker) => UpdateStore(
      checker: checker,
      versionOf: () async => '1.0.0',
    );

void main() {
  setUpAll(loadTestFonts);

  testWidgets('shows version and check button', (tester) async {
    final updates = storeFor(FakeVersionChecker());
    await tester.pumpWidget(wrap(AboutPage(
      updates: updates,
      stats: await testStats(),
      linkOpener: LinkOpener(opener: FakeLinkOpener().call),
    )));
    await tester.pumpAndSettle();
    expect(find.text('Version 1.0.0'), findsOneWidget);
    expect(find.byKey(const Key('check_updates')), findsOneWidget);
    expect(find.text('No games yet'), findsOneWidget);
  });

  testWidgets('up to date result shows feedback and releases link',
      (tester) async {
    final gate = Completer<void>();
    final updates = storeFor(FakeVersionChecker()..gate = gate.future);
    final opener = FakeLinkOpener();
    await tester.pumpWidget(wrap(AboutPage(
      updates: updates,
      stats: await testStats(),
      linkOpener: LinkOpener(opener: opener.call),
    )));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('check_updates')));
    await tester.pump();
    expect(find.text('Checking…'), findsOneWidget);
    gate.complete();
    await tester.pumpAndSettle();
    expect(find.text('震中 is up to date'), findsOneWidget);
    await tester.tap(find.text('震中 is up to date'));
    expect(opener.opened.last,
        Uri.parse(VersionChecker.releasesUrl));
  });

  testWidgets('update available shows version and release links',
      (tester) async {
    final checker = FakeVersionChecker()
      ..result = const AppUpdate(
        currentVersion: '1.0.0',
        latestVersion: '2.0.0',
        updateAvailable: true,
        releaseUrl: 'https://gitlab.com/x/-/releases/v2.0.0',
      );
    final opener = FakeLinkOpener();
    await tester.pumpWidget(wrap(AboutPage(
      updates: storeFor(checker),
      stats: await testStats(),
      linkOpener: LinkOpener(opener: opener.call),
    )));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('check_updates')));
    await tester.pumpAndSettle();
    expect(find.text('Version 2.0.0 is available'), findsOneWidget);
    await tester.tap(find.text('View this release'));
    expect(opener.opened.last,
        Uri.parse('https://gitlab.com/x/-/releases/v2.0.0'));
    await tester.tap(find.text('All releases'));
    expect(opener.opened.last,
        Uri.parse(VersionChecker.releasesUrl));
    await tester.tap(find.text('Version 2.0.0 is available'));
    expect(opener.opened.last,
        Uri.parse('https://gitlab.com/x/-/releases/v2.0.0'));
  });

  testWidgets('failed check shows an error', (tester) async {
    final checker = FakeVersionChecker()..error = 'offline';
    await tester.pumpWidget(wrap(AboutPage(
      updates: storeFor(checker),
      stats: await testStats(),
      linkOpener: LinkOpener(opener: FakeLinkOpener().call),
    )));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('check_updates')));
    await tester.pumpAndSettle();
    expect(find.textContaining("couldn't check", findRichText: true),
        findsNothing);
    expect(
        find.text("Couldn't check for updates. Try again later."),
        findsOneWidget);
  });

  testWidgets('statistics section lists played games', (tester) async {
    final s = await testStats();
    await s.recordGame(won: true, seconds: 95);
    await tester.pumpWidget(wrap(AboutPage(
      updates: storeFor(FakeVersionChecker()),
      stats: s,
      linkOpener: LinkOpener(opener: FakeLinkOpener().call),
    )));
    await tester.pumpAndSettle();
    expect(find.text('Games played'), findsOneWidget);
    expect(find.text('Games won'), findsOneWidget);
    expect(find.text('Best time'), findsOneWidget);
    expect(find.text('1:35'), findsOneWidget);
  });

  testWidgets('source and licence tiles open links', (tester) async {
    final opener = FakeLinkOpener();
    await tester.pumpWidget(wrap(AboutPage(
      updates: storeFor(FakeVersionChecker()),
      stats: await testStats(),
      linkOpener: LinkOpener(opener: opener.call),
    )));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Source code'));
    expect(opener.opened.last,
        Uri.parse('https://gitlab.com/HttpAnimations/zhenzhong'));
    await tester.tap(find.text('Licence: AGPL-3.0'));
    expect(opener.opened.last.toString(), contains('LICENSE'));
  });
}
