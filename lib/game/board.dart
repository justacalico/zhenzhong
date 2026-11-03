import 'dart:math';

import 'package:flutter/foundation.dart';

import 'layout.dart';
import 'tile.dart';

class BoardTile {
  final int id;
  final BoardPos pos;
  TileKind kind;
  bool removed;

  BoardTile({required this.id, required this.pos, required this.kind})
      : removed = false;
}

class Move {
  final BoardTile a;
  final BoardTile b;

  const Move(this.a, this.b);
}

class MahjongGame extends ChangeNotifier {
  final List<BoardPos> layout;
  final List<TileKind> _deck;
  final Random _random;
  final DateTime Function() _clock;

  final List<BoardTile> tiles = [];
  final List<Move> history = [];
  BoardTile? _selectedTile;
  List<Move> _solution = const [];
  bool _won = false;
  DateTime? _startedAt;
  Duration _bankedElapsed = Duration.zero;

  MahjongGame({
    List<BoardPos>? layout,
    List<TileKind>? deck,
    Random? random,
    DateTime Function()? clock,
  })  : layout = layout ?? turtleLayout(),
        _deck = deck ?? standardDeck(),
        _random = random ?? Random(),
        _clock = clock ?? DateTime.now {
    _deal();
  }

  int? get selectedId => _selectedTile?.id;
  BoardTile? get selected => _selectedTile;
  bool get won => _won;
  int get pairsRemoved => history.length;
  int get tilesRemaining => tiles.where((t) => !t.removed).length;

  List<Move> get solution => List.unmodifiable(_solution);

  Duration get elapsed {
    final started = _startedAt;
    if (started == null) return _bankedElapsed;
    return _bankedElapsed + _clock().difference(started);
  }

  Iterable<BoardTile> get _occupied => tiles.where((t) => !t.removed);

  static bool _xOverlap(BoardPos a, BoardPos b) =>
      a.x < b.x + 2 && b.x < a.x + 2;

  static bool _yOverlap(BoardPos a, BoardPos b) =>
      a.y < b.y + 2 && b.y < a.y + 2;

  bool _isFreePos(BoardPos pos, bool Function(BoardPos) occupied) {
    var leftOpen = true;
    var rightOpen = true;
    for (final other in layout) {
      if (other == pos || !occupied(other)) continue;
      if (other.z > pos.z && _xOverlap(pos, other) && _yOverlap(pos, other)) {
        return false;
      }
      if (other.z == pos.z && _yOverlap(pos, other)) {
        if (other.x < pos.x && other.x + 2 >= pos.x) leftOpen = false;
        if (other.x > pos.x && other.x <= pos.x + 2) rightOpen = false;
      }
    }
    return leftOpen || rightOpen;
  }

  bool isFree(BoardTile tile) {
    if (tile.removed) return false;
    final occupied = {for (final t in _occupied) t.pos};
    return _isFreePos(tile.pos, occupied.contains);
  }

  List<BoardTile> freeTiles() =>
      _occupied.where(isFree).toList(growable: false);

  List<Move> availableMoves() {
    final free = freeTiles();
    final moves = <Move>[];
    for (var i = 0; i < free.length; i++) {
      for (var j = i + 1; j < free.length; j++) {
        if (free[i].kind.matches(free[j].kind)) {
          moves.add(Move(free[i], free[j]));
        }
      }
    }
    return moves;
  }

  bool get hasMoves => availableMoves().isNotEmpty;

  void tap(BoardTile tile) {
    if (_won || tile.removed || !isFree(tile)) return;
    final selected = _selectedTile;
    if (selected == tile) {
      _selectedTile = null;
      notifyListeners();
      return;
    }
    if (selected != null && selected.kind.matches(tile.kind)) {
      selected.removed = true;
      tile.removed = true;
      history.add(Move(selected, tile));
      _selectedTile = null;
      if (tilesRemaining == 0) {
        _won = true;
        _bankedElapsed = elapsed;
        _startedAt = null;
      }
      notifyListeners();
      return;
    }
    _selectedTile = tile;
    notifyListeners();
  }

  bool undo() {
    if (history.isEmpty) return false;
    final move = history.removeLast();
    move.a.removed = false;
    move.b.removed = false;
    _selectedTile = null;
    if (_won) {
      _won = false;
      _startedAt = _clock();
    }
    notifyListeners();
    return true;
  }

  Move? hint() {
    final moves = availableMoves();
    if (moves.isEmpty) return null;
    return moves[_random.nextInt(moves.length)];
  }

  void shuffle() {
    final remaining = _occupied.toList();
    if (remaining.length < 2) return;
    final positions = remaining.map((t) => t.pos).toList();
    final deck = remaining.map((t) => t.kind).toList();
    Map<BoardPos, TileKind> assignment;
    List<(BoardPos, BoardPos)> order;
    try {
      final dealt = _dealOnto(positions, deck);
      assignment = dealt.assignment;
      order = dealt.order;
    } catch (_) {
      final shuffled = List<TileKind>.of(deck)..shuffle(_random);
      assignment = {
        for (var i = 0; i < positions.length; i++)
          positions[i]: shuffled[i],
      };
      order = const [];
    }
    for (final t in remaining) {
      t.kind = assignment[t.pos]!;
    }
    _solution = order
        .map(
          (pair) => Move(
            remaining.firstWhere((t) => t.pos == pair.$1),
            remaining.firstWhere((t) => t.pos == pair.$2),
          ),
        )
        .toList();
    _selectedTile = null;
    notifyListeners();
  }

  void newDeal() {
    _deal();
    notifyListeners();
  }

  void _deal() {
    tiles.clear();
    history.clear();
    _selectedTile = null;
    _won = false;
    final dealt = _dealOnto(layout, List.of(_deck));
    for (var i = 0; i < layout.length; i++) {
      tiles.add(
        BoardTile(id: i, pos: layout[i], kind: dealt.assignment[layout[i]]!),
      );
    }
    _solution = dealt.order
        .map(
          (pair) => Move(
            tiles.firstWhere((t) => t.pos == pair.$1),
            tiles.firstWhere((t) => t.pos == pair.$2),
          ),
        )
        .toList();
    _bankedElapsed = Duration.zero;
    _startedAt = _clock();
  }

  List<(TileKind, TileKind)> _pairUp(List<TileKind> deck) {
    final pool = List<TileKind>.of(deck);
    final pairs = <(TileKind, TileKind)>[];
    while (pool.isNotEmpty) {
      final a = pool.removeLast();
      final mate = pool.indexWhere((b) => b.matches(a));
      if (mate < 0) throw StateError('deck is not pairable');
      pairs.add((a, pool.removeAt(mate)));
    }
    return pairs;
  }

  ({Map<BoardPos, TileKind> assignment, List<(BoardPos, BoardPos)> order})
      _dealOnto(List<BoardPos> positions, List<TileKind> deck) {
    final pairs = _pairUp(deck);
    for (var attempt = 0; attempt < 500; attempt++) {
      final result = _tryDeal(positions, pairs);
      if (result != null) return result;
    }
    throw StateError('could not deal a solvable board');
  }

  ({Map<BoardPos, TileKind> assignment, List<(BoardPos, BoardPos)> order})?
      _tryDeal(List<BoardPos> positions, List<(TileKind, TileKind)> pairs) {
    final occupied = Set<BoardPos>.of(positions);
    final assignment = <BoardPos, TileKind>{};
    final order = <(BoardPos, BoardPos)>[];
    final shuffled = List.of(pairs)..shuffle(_random);
    for (final pair in shuffled) {
      final free = positions
          .where((p) =>
              occupied.contains(p) && _isFreePos(p, occupied.contains))
          .toList();
      if (free.length < 2) return null;
      free.shuffle(_random);
      final first = free[0];
      final second = free[1];
      occupied.remove(first);
      occupied.remove(second);
      assignment[first] = pair.$1;
      assignment[second] = pair.$2;
      order.add((first, second));
    }
    return (assignment: assignment, order: order);
  }
}
