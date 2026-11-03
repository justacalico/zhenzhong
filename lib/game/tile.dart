import 'package:flutter/material.dart';

enum Suit { characters, bamboo, circles, wind, dragon, flower, season }

class TileKind {
  final Suit suit;
  final int rank;

  const TileKind(this.suit, this.rank);

  bool matches(TileKind other) {
    if (suit == Suit.flower || suit == Suit.season) {
      return suit == other.suit;
    }
    return suit == other.suit && rank == other.rank;
  }

  String get topGlyph {
    const digits = '一二三四五六七八九';
    switch (suit) {
      case Suit.characters:
      case Suit.bamboo:
      case Suit.circles:
        return digits[rank - 1];
      case Suit.wind:
        return '东南西北'[rank - 1];
      case Suit.dragon:
        return '中发白'[rank - 1];
      case Suit.flower:
        return '梅兰竹菊'[rank - 1];
      case Suit.season:
        return '春夏秋冬'[rank - 1];
    }
  }

  String? get bottomGlyph => switch (suit) {
        Suit.characters => '万',
        Suit.bamboo => '条',
        Suit.circles => '筒',
        _ => null,
      };

  Color get faceColor => switch (suit) {
        Suit.characters => const Color(0xFF1D3557),
        Suit.bamboo => const Color(0xFF2D6A4F),
        Suit.circles => const Color(0xFF7B2CBF),
        Suit.wind => const Color(0xFF343A40),
        Suit.dragon => rank == 1
            ? const Color(0xFFC1121F)
            : rank == 2
                ? const Color(0xFF2D6A4F)
                : const Color(0xFF1D3557),
        Suit.flower => const Color(0xFFC1121F),
        Suit.season => const Color(0xFF2D6A4F),
      };

  @override
  bool operator ==(Object other) =>
      other is TileKind && suit == other.suit && rank == other.rank;

  @override
  int get hashCode => Object.hash(suit, rank);
}

List<TileKind> standardDeck() {
  final deck = <TileKind>[];
  for (var copy = 0; copy < 4; copy++) {
    for (final suit in [Suit.characters, Suit.bamboo, Suit.circles]) {
      for (var rank = 1; rank <= 9; rank++) {
        deck.add(TileKind(suit, rank));
      }
    }
    for (var rank = 1; rank <= 4; rank++) {
      deck.add(TileKind(Suit.wind, rank));
    }
    for (var rank = 1; rank <= 3; rank++) {
      deck.add(TileKind(Suit.dragon, rank));
    }
  }
  for (var rank = 1; rank <= 4; rank++) {
    deck.add(TileKind(Suit.flower, rank));
    deck.add(TileKind(Suit.season, rank));
  }
  return deck;
}
