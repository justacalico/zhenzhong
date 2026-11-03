import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:zhenzhong/game/board.dart';
import 'package:zhenzhong/game/layout.dart';
import 'package:zhenzhong/game/tile.dart';

class ZeroRandom implements Random {
  @override
  int nextInt(int max) => 0;

  @override
  bool nextBool() => false;

  @override
  double nextDouble() => 0;
}

MahjongGame rowGame(
  int tiles,
  List<TileKind> deck, {
  DateTime Function()? clock,
}) =>
    MahjongGame(
      layout: [
        for (var i = 0; i < tiles; i++) BoardPos(i * 2, 0, 0),
      ],
      deck: deck,
      random: ZeroRandom(),
      clock: clock,
    );

List<int> kindIds(List<BoardTile> tiles) =>
    tiles.map((t) => t.kind.suit.index * 100 + t.kind.rank).toList()..sort();

void main() {
  group('layout and deck', () {
    test('turtle layout has 144 unique positions', () {
      final layout = turtleLayout();
      expect(layout.length, 144);
      expect(layout.toSet().length, 144);
    });

    test('standard deck has 144 pairable tiles', () {
      final deck = standardDeck();
      expect(deck.length, 144);
      final counts = <TileKind, int>{};
      for (final k in deck) {
        counts[k] = (counts[k] ?? 0) + 1;
      }
      for (final entry in counts.entries) {
        if (entry.key.suit == Suit.flower || entry.key.suit == Suit.season) {
          expect(entry.value, 1);
        } else {
          expect(entry.value, 4);
        }
      }
    });

    test('unpairable decks throw while dealing', () {
      expect(
        () => rowGame(2, const [
          TileKind(Suit.bamboo, 3),
          TileKind(Suit.circles, 5),
        ]),
        throwsStateError,
      );
    });

    test('undealable layouts throw while dealing', () {
      expect(
        () => MahjongGame(
          layout: const [BoardPos(0, 0, 0), BoardPos(0, 0, 1)],
          deck: const [TileKind(Suit.bamboo, 3), TileKind(Suit.bamboo, 3)],
          random: ZeroRandom(),
        ),
        throwsStateError,
      );
    });
  });

  group('dealing', () {
    test('fresh game is solvable to the end', () {
      final game = MahjongGame(random: Random(7));
      expect(game.solution.length, 72);
      for (final move in game.solution) {
        game.tap(move.a);
        game.tap(move.b);
      }
      expect(game.won, isTrue);
      expect(game.tilesRemaining, 0);
      expect(game.pairsRemoved, 72);
    });

    test('ten seeds all deal solvable boards', () {
      for (var seed = 0; seed < 10; seed++) {
        final game = MahjongGame(random: Random(seed));
        for (final move in game.solution) {
          game.tap(move.a);
          game.tap(move.b);
        }
        expect(game.won, isTrue, reason: 'seed $seed not solvable');
      }
    });

    test('a fresh board always has at least one move', () {
      for (var seed = 10; seed < 15; seed++) {
        final game = MahjongGame(random: Random(seed));
        expect(game.availableMoves(), isNotEmpty);
      }
    });
  });

  group('tile rules', () {
    test('free tile on the end of a row, blocked in the middle', () {
      final game = rowGame(4, [
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.circles, 5),
        const TileKind(Suit.circles, 5),
      ]);
      final ends = game.freeTiles();
      expect(ends.length, 2);
      expect(ends.map((t) => t.pos.x).toSet(), {0, 6});
      expect(game.isFree(game.tiles[1]), isFalse);
    });

    test('tile covered from above is not free', () {
      final game = MahjongGame(
        layout: const [
          BoardPos(0, 0, 0),
          BoardPos(0, 0, 1),
          BoardPos(4, 0, 0),
          BoardPos(4, 0, 1),
        ],
        deck: const [
          TileKind(Suit.wind, 1),
          TileKind(Suit.wind, 1),
          TileKind(Suit.bamboo, 2),
          TileKind(Suit.bamboo, 2),
        ],
        random: ZeroRandom(),
      );
      final covered = game.tiles.firstWhere((t) => t.pos.z == 0);
      final onTop = game.tiles.firstWhere((t) => t.pos.z == 1);
      expect(game.isFree(covered), isFalse);
      expect(game.isFree(onTop), isTrue);
    });

    test('tap selects, re-tap deselects, matching removes the pair', () {
      final game = rowGame(4, [
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.circles, 5),
        const TileKind(Suit.circles, 5),
      ]);
      final ends = game.freeTiles();
      game.tap(ends[0]);
      expect(game.selected, ends[0]);
      game.tap(ends[0]);
      expect(game.selected, isNull);
      game.tap(ends[0]);
      game.tap(ends[1]);
      expect(game.tilesRemaining, 2);
      expect(game.history.length, 1);
      expect(game.selected, isNull);
    });

    test('tapping a blocked tile does nothing', () {
      final game = rowGame(4, [
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.circles, 5),
        const TileKind(Suit.circles, 5),
      ]);
      game.tap(game.tiles[1]);
      expect(game.selected, isNull);
    });

    test('tapping a non-matching free tile moves the selection', () {
      final game = rowGame(4, [
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.circles, 5),
        const TileKind(Suit.circles, 5),
      ]);
      final ends = game.freeTiles();
      ends[1].kind = const TileKind(Suit.wind, 2);
      game.tap(ends[0]);
      game.tap(ends[1]);
      expect(game.selected, ends[1]);
      expect(game.tilesRemaining, 4);
    });

    test('tapping a removed tile does nothing', () {
      final game = rowGame(2, const [
        TileKind(Suit.bamboo, 3),
        TileKind(Suit.bamboo, 3),
      ]);
      final t = game.tiles[0];
      game.tap(game.tiles[0]);
      game.tap(game.tiles[1]);
      expect(game.won, isTrue);
      game.tap(t);
      expect(game.selected, isNull);
    });

    test('taps are ignored once the game is won', () {
      final game = rowGame(4, [
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.circles, 5),
        const TileKind(Suit.circles, 5),
      ]);
      game.tap(game.freeTiles()[0]);
      game.tap(game.freeTiles()[1]);
      game.tap(game.freeTiles()[0]);
      game.tap(game.freeTiles()[1]);
      expect(game.won, isTrue);
      game.undo();
      expect(game.won, isFalse);
      game.tap(game.freeTiles()[0]);
      final sel = game.selected!;
      game.tap(game
          .freeTiles()
          .firstWhere((t) => t != sel && t.kind.matches(sel.kind)));
      expect(game.won, isTrue);
    });
  });

  group('undo, hint, shuffle, new deal', () {
    test('undo restores the pair and clears selection', () {
      final game = rowGame(4, [
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.circles, 5),
        const TileKind(Suit.circles, 5),
      ]);
      final ends = game.freeTiles();
      game.tap(ends[0]);
      game.tap(ends[1]);
      expect(game.undo(), isTrue);
      expect(game.tilesRemaining, 4);
      expect(game.history, isEmpty);
      expect(game.undo(), isFalse);
    });

    test('undo after winning resumes the game', () {
      var now = DateTime(2026, 1, 1);
      final game = rowGame(
        2,
        const [TileKind(Suit.bamboo, 3), TileKind(Suit.bamboo, 3)],
        clock: () => now,
      );
      game.tap(game.tiles[0]);
      game.tap(game.tiles[1]);
      expect(game.won, isTrue);
      expect(game.undo(), isTrue);
      expect(game.won, isFalse);
      expect(game.tilesRemaining, 2);
      now = now.add(const Duration(seconds: 30));
      expect(game.elapsed.inSeconds, greaterThanOrEqualTo(30));
    });

    test('hint returns a free matching pair or null when stuck', () {
      final game = rowGame(4, [
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.circles, 5),
        const TileKind(Suit.circles, 5),
      ]);
      final move = game.hint()!;
      expect(move.a.kind.matches(move.b.kind), isTrue);
      game.tiles[0].kind = const TileKind(Suit.dragon, 1);
      game.tiles[3].kind = const TileKind(Suit.dragon, 2);
      expect(game.hint(), isNull);
      expect(game.hasMoves, isFalse);
    });

    test('shuffle keeps the same kinds and stays solvable', () {
      final game = rowGame(6, [
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.circles, 5),
        const TileKind(Suit.circles, 5),
        const TileKind(Suit.wind, 1),
        const TileKind(Suit.wind, 1),
      ]);
      final before = kindIds(game.tiles);
      game.shuffle();
      expect(kindIds(game.tiles), before);
      expect(game.hasMoves, isTrue);
    });

    test('shuffle on an undealable remainder falls back to random', () {
      final game = MahjongGame(random: Random(3));
      final stacked = game.tiles
          .where((t) =>
              t.pos == const BoardPos(14, 3, 1) ||
              t.pos == const BoardPos(14, 3, 2))
          .toList();
      expect(stacked.length, 2);
      for (final t in game.tiles) {
        if (!stacked.contains(t)) t.removed = true;
      }
      expect(game.tilesRemaining, 2);
      expect(() => game.shuffle(), returnsNormally);
    });

    test('shuffle with fewer than two tiles is a no-op', () {
      final game = rowGame(2, const [
        TileKind(Suit.bamboo, 3),
        TileKind(Suit.bamboo, 3),
      ]);
      game.tap(game.tiles[0]);
      game.tap(game.tiles[1]);
      expect(game.tilesRemaining, 0);
      expect(() => game.shuffle(), returnsNormally);
    });

    test('new deal resets the board', () {
      final game = rowGame(4, [
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.circles, 5),
        const TileKind(Suit.circles, 5),
      ]);
      game.tap(game.freeTiles()[0]);
      game.tap(game.freeTiles()[1]);
      game.newDeal();
      expect(game.tilesRemaining, 4);
      expect(game.history, isEmpty);
      expect(game.won, isFalse);
      expect(game.selected, isNull);
    });
  });

  group('timer', () {
    test('elapsed accumulates from the injected clock', () {
      var now = DateTime(2026, 1, 1, 12);
      final game = rowGame(
        2,
        const [TileKind(Suit.bamboo, 3), TileKind(Suit.bamboo, 3)],
        clock: () => now,
      );
      now = now.add(const Duration(seconds: 90));
      expect(game.elapsed, const Duration(seconds: 90));
      game.tap(game.tiles[0]);
      game.tap(game.tiles[1]);
      now = now.add(const Duration(hours: 1));
      expect(game.elapsed, const Duration(seconds: 90));
    });
  });

  group('notifications', () {
    test('listeners fire on select, match, undo, shuffle and new deal', () {
      var count = 0;
      final game = rowGame(4, [
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.bamboo, 3),
        const TileKind(Suit.circles, 5),
        const TileKind(Suit.circles, 5),
      ])
        ..addListener(() => count++);
      game.tap(game.freeTiles()[0]);
      expect(count, 1);
      game.tap(game.selected!);
      expect(count, 2);
      game.tap(game.freeTiles()[0]);
      expect(count, 3);
      game.tap(game.freeTiles().firstWhere((t) => t != game.selected));
      expect(count, 4);
      game.undo();
      expect(count, 5);
      game.shuffle();
      expect(count, 6);
      game.newDeal();
      expect(count, 7);
    });
  });
}
