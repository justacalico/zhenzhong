import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zhenzhong/state/settings_store.dart';
import 'package:zhenzhong/views/help_page.dart';
import 'package:zhenzhong/views/settings_page.dart';
import 'package:zhenzhong/widgets/tile_widget.dart';
import 'package:zhenzhong/game/board.dart';
import 'package:zhenzhong/game/layout.dart';
import 'package:zhenzhong/game/tile.dart';

import 'helpers.dart';

Widget wrap(Widget child, {Locale? locale}) => MaterialApp(
      localizationsDelegates: testDelegates,
      supportedLocales: testLocales,
      locale: locale,
      home: Scaffold(body: child),
    );

void main() {
  setUpAll(loadTestFonts);

  group('SettingsPage', () {
    testWidgets('language radios update the store', (tester) async {
      final settings = await testSettings();
      await tester.pumpWidget(wrap(SettingsPage(settings: settings)));
      expect(find.text('System'), findsWidgets);
      expect(find.text('Traditional English'), findsOneWidget);
      expect(find.text('简体中文'), findsWidgets);
      expect(find.text('Русский'), findsOneWidget);
      expect(find.text('Gaeilge'), findsOneWidget);
      await tester.tap(find.byKey(const Key('locale_zh')));
      await tester.pump();
      expect(settings.locale, const Locale('zh'));
      await tester.tap(find.byKey(const Key('locale_ga')));
      await tester.pump();
      expect(settings.locale, const Locale('ga'));
      await tester.tap(find.byKey(const Key('locale_system')));
      await tester.pump();
      expect(settings.locale, isNull);
    });

    testWidgets('theme radios update the store', (tester) async {
      final settings = await testSettings();
      await tester.pumpWidget(wrap(SettingsPage(settings: settings)));
      await tester.tap(find.byKey(const Key('theme_oled')));
      await tester.pump();
      expect(settings.themeMode, AppThemeMode.oled);
      await tester.tap(find.byKey(const Key('theme_light')));
      await tester.pump();
      expect(settings.themeMode, AppThemeMode.light);
      await tester.tap(find.byKey(const Key('theme_dark')));
      await tester.pump();
      expect(settings.themeMode, AppThemeMode.dark);
      await tester.tap(find.byKey(const Key('theme_system')));
      await tester.pump();
      expect(settings.themeMode, AppThemeMode.system);
    });

    testWidgets('highlight switch updates the store', (tester) async {
      final settings = await testSettings();
      await tester.pumpWidget(wrap(SettingsPage(settings: settings)));
      await tester.tap(find.byKey(const Key('highlight_free_only')));
      await tester.pump();
      expect(settings.highlightFreeOnly, isTrue);
      await tester.tap(find.byKey(const Key('highlight_free_only')));
      await tester.pump();
      expect(settings.highlightFreeOnly, isFalse);
    });
  });

  group('HelpPage', () {
    testWidgets('renders sections and sample tiles', (tester) async {
      await tester.pumpWidget(wrap(const HelpPage()));
      expect(find.text('Goal'), findsOneWidget);
      expect(find.text('Free tiles'), findsOneWidget);
      expect(find.text('Matching'), findsOneWidget);
      expect(find.text('Controls'), findsOneWidget);
      expect(find.text('梅兰竹菊 · 春夏秋冬'), findsOneWidget);
      expect(find.byType(MahjongTileWidget), findsNWidgets(9));
    });
  });

  group('MahjongTileWidget', () {
    testWidgets('renders all states and taps', (tester) async {
      var taps = 0;
      final tile = BoardTile(
        id: 1,
        pos: const BoardPos(0, 0, 0),
        kind: const TileKind(Suit.dragon, 1),
      );
      await tester.pumpWidget(wrap(Center(
        child: MahjongTileWidget(
          tile: tile,
          width: 60,
          height: 76,
          selected: true,
          free: true,
          hinted: true,
          onTap: () => taps++,
        ),
      )));
      await tester.tap(find.byType(MahjongTileWidget));
      expect(taps, 1);
    });

    testWidgets('dimBlocked darkens a blocked tile', (tester) async {
      final tile = BoardTile(
        id: 1,
        pos: const BoardPos(0, 0, 0),
        kind: const TileKind(Suit.flower, 2),
      );
      await tester.pumpWidget(wrap(Center(
        child: MahjongTileWidget(
          tile: tile,
          width: 60,
          height: 76,
          free: false,
          dimBlocked: true,
        ),
      )));
      await tester.pump();
    });

    testWidgets('hover lightens a free tile', (tester) async {
      final tile = BoardTile(
        id: 1,
        pos: const BoardPos(0, 0, 0),
        kind: const TileKind(Suit.wind, 1),
      );
      await tester.pumpWidget(wrap(Center(
        child: MahjongTileWidget(
          tile: tile,
          width: 60,
          height: 76,
        ),
      )));
      final hover = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await hover.addPointer(location: Offset.zero);
      await hover.moveTo(
          tester.getCenter(find.byType(MahjongTileWidget)));
      await tester.pump();
      await hover.moveTo(Offset.zero);
      await tester.pump();
    });
  });
}
