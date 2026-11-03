import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zhenzhong/game/tile.dart';

void main() {
  group('TileKind', () {
    test('identical suited kinds match', () {
      const a = TileKind(Suit.bamboo, 3);
      const b = TileKind(Suit.bamboo, 3);
      const c = TileKind(Suit.bamboo, 4);
      const d = TileKind(Suit.circles, 3);
      expect(a.matches(b), isTrue);
      expect(a.matches(c), isFalse);
      expect(a.matches(d), isFalse);
    });

    test('any flower matches any flower, any season any season', () {
      const plum = TileKind(Suit.flower, 1);
      const mum = TileKind(Suit.flower, 3);
      const spring = TileKind(Suit.season, 1);
      const winter = TileKind(Suit.season, 4);
      expect(plum.matches(mum), isTrue);
      expect(spring.matches(winter), isTrue);
      expect(plum.matches(spring), isFalse);
    });

    test('equality and hashCode', () {
      const a = TileKind(Suit.wind, 2);
      const b = TileKind(Suit.wind, 2);
      const c = TileKind(Suit.wind, 3);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a == c, isFalse);
      expect(a == Object(), isFalse);
    });

    test('glyphs for every suit', () {
      expect(const TileKind(Suit.characters, 1).topGlyph, '一');
      expect(const TileKind(Suit.characters, 9).topGlyph, '九');
      expect(const TileKind(Suit.characters, 5).bottomGlyph, '万');
      expect(const TileKind(Suit.bamboo, 2).bottomGlyph, '条');
      expect(const TileKind(Suit.circles, 7).bottomGlyph, '筒');
      expect(const TileKind(Suit.wind, 1).topGlyph, '东');
      expect(const TileKind(Suit.wind, 4).topGlyph, '北');
      expect(const TileKind(Suit.dragon, 1).topGlyph, '中');
      expect(const TileKind(Suit.dragon, 3).topGlyph, '白');
      expect(const TileKind(Suit.flower, 2).topGlyph, '兰');
      expect(const TileKind(Suit.season, 4).topGlyph, '冬');
      expect(const TileKind(Suit.wind, 1).bottomGlyph, isNull);
    });

    test('face colors', () {
      expect(const TileKind(Suit.characters, 1).faceColor,
          const Color(0xFF1D3557));
      expect(const TileKind(Suit.bamboo, 1).faceColor,
          const Color(0xFF2D6A4F));
      expect(const TileKind(Suit.circles, 1).faceColor,
          const Color(0xFF7B2CBF));
      expect(const TileKind(Suit.wind, 1).faceColor,
          const Color(0xFF343A40));
      expect(const TileKind(Suit.dragon, 1).faceColor,
          const Color(0xFFC1121F));
      expect(const TileKind(Suit.dragon, 2).faceColor,
          const Color(0xFF2D6A4F));
      expect(const TileKind(Suit.dragon, 3).faceColor,
          const Color(0xFF1D3557));
      expect(const TileKind(Suit.flower, 1).faceColor,
          const Color(0xFFC1121F));
      expect(const TileKind(Suit.season, 1).faceColor,
          const Color(0xFF2D6A4F));
    });
  });
}

