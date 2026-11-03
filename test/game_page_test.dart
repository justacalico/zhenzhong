import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zhenzhong/game/board.dart';
import 'package:zhenzhong/game/layout.dart';
import 'package:zhenzhong/game/tile.dart';
import 'package:zhenzhong/state/stats_store.dart';
import 'package:zhenzhong/views/game_page.dart';
import 'package:zhenzhong/widgets/tile_widget.dart';

import 'helpers.dart';

MahjongGame twoTileGame() => MahjongGame(
  layout: const [BoardPos(0, 0, 0), BoardPos(4, 0, 0)],
  deck: const [TileKind(Suit.bamboo, 3), TileKind(Suit.bamboo, 3)],
  random: _Zero(),
);

class _Zero implements Random {
  @override
  int nextInt(int max) => 0;

  @override
  bool nextBool() => false;

  @override
  double nextDouble() => 0;
}

Widget wrap(Widget child) => MaterialApp(
  localizationsDelegates: testDelegates,
  supportedLocales: testLocales,
  home: Scaffold(body: child),
);

void main() {
  setUpAll(loadTestFonts);

  Future<StatsStore> stats() => testStats();

  testWidgets('shows status chips and controls', (tester) async {
    final game = twoTileGame();
    await tester.pumpWidget(wrap(GamePage(game: game, stats: await stats())));
    await tester.pump();
    expect(find.byKey(const Key('btn_new')), findsOneWidget);
    expect(find.byKey(const Key('btn_hint')), findsOneWidget);
    expect(find.byKey(const Key('btn_undo')), findsOneWidget);
    expect(find.byKey(const Key('btn_shuffle')), findsOneWidget);
    expect(find.textContaining('2'), findsWidgets);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('tapping a tile pair wins and shows the dialog', (tester) async {
    final game = twoTileGame();
    final s = await stats();
    await tester.pumpWidget(wrap(GamePage(game: game, stats: s)));
    await tester.pump();
    await tester.tap(find.byType(MahjongTileWidget).first);
    await tester.pump();
    await tester.tap(find.byType(MahjongTileWidget).last);
    await tester.pump();
    await tester.pump();
    expect(find.byKey(const Key('won_dialog')), findsOneWidget);
    expect(s.gamesWon, 1);
    await tester.tap(find.text('Play again'));
    await tester.pumpAndSettle();
    expect(game.won, isFalse);
    expect(game.tilesRemaining, 2);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('undo is disabled until a move happens', (tester) async {
    final game = twoTileGame();
    await tester.pumpWidget(wrap(GamePage(game: game, stats: await stats())));
    await tester.pump();
    final undo = tester.widget<TextButton>(find.byKey(const Key('btn_undo')));
    expect(undo.onPressed, isNull);
    await tester.tap(find.byType(MahjongTileWidget).first);
    await tester.tap(find.byType(MahjongTileWidget).last);
    await tester.pump();
    await tester.pump();
    expect(find.byKey(const Key('won_dialog')), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('hint highlights a pair briefly', (tester) async {
    final game = twoTileGame();
    await tester.pumpWidget(wrap(GamePage(game: game, stats: await stats())));
    await tester.pump();
    await tester.tap(find.byKey(const Key('btn_hint')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('shuffle button triggers a shuffle', (tester) async {
    final game = twoTileGame();
    await tester.pumpWidget(wrap(GamePage(game: game, stats: await stats())));
    await tester.pump();
    await tester.tap(find.byKey(const Key('btn_shuffle')));
    await tester.pump();
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('new game button records an abandoned game', (tester) async {
    final game = MahjongGame(
      layout: const [
        BoardPos(0, 0, 0),
        BoardPos(2, 0, 0),
        BoardPos(4, 0, 0),
        BoardPos(6, 0, 0),
      ],
      deck: const [
        TileKind(Suit.bamboo, 3),
        TileKind(Suit.bamboo, 3),
        TileKind(Suit.circles, 5),
        TileKind(Suit.circles, 5),
      ],
      random: _Zero(),
    );
    final s = await stats();
    await tester.pumpWidget(wrap(GamePage(game: game, stats: s)));
    await tester.pump();
    await tester.tap(find.byType(MahjongTileWidget).first);
    await tester.tap(find.byType(MahjongTileWidget).last);
    await tester.pump();
    expect(game.tilesRemaining, 2);
    expect(game.won, isFalse);
    await tester.tap(find.byKey(const Key('btn_new')));
    await tester.pump();
    expect(s.gamesPlayed, 1);
    expect(s.gamesWon, 0);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('stuck dialog offers keep playing', (tester) async {
    final game = stuckGame();
    makeStuck(game);
    await tester.pumpWidget(wrap(GamePage(game: game, stats: await stats())));
    await tester.pump();
    await tester.tap(find.byType(MahjongTileWidget).first);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('stuck_dialog')), findsOneWidget);
    await tester.tap(find.text('Keep playing'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('stuck_dialog')), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('stuck dialog can shuffle the board', (tester) async {
    final game = stuckGame();
    makeStuck(game);
    await tester.pumpWidget(wrap(GamePage(game: game, stats: await stats())));
    await tester.pump();
    await tester.tap(find.byType(MahjongTileWidget).first);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('stuck_dialog')), findsOneWidget);
    await tester.tap(find.descendant(
      of: find.byKey(const Key('stuck_dialog')),
      matching: find.byType(FilledButton),
    ));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('stuck_dialog')), findsNothing);
    expect(game.tilesRemaining, 2);
    await tester.pumpWidget(const SizedBox());
  });
}

MahjongGame stuckGame() => MahjongGame(
  layout: const [
    BoardPos(0, 0, 0),
    BoardPos(2, 0, 0),
    BoardPos(4, 0, 0),
    BoardPos(6, 0, 0),
  ],
  deck: const [
    TileKind(Suit.bamboo, 3),
    TileKind(Suit.bamboo, 3),
    TileKind(Suit.circles, 5),
    TileKind(Suit.circles, 5),
  ],
  random: _Zero(),
);

void makeStuck(MahjongGame game) {
  game.tap(game.tiles[0]);
  game.tap(game.tiles[3]);
  game.tiles[1].kind = const TileKind(Suit.dragon, 1);
  game.tiles[2].kind = const TileKind(Suit.dragon, 2);
}
