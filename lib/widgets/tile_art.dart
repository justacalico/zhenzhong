import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/tile.dart';

void paintTileArt(Canvas canvas, TileKind kind, Rect area) {
  final center = area.center;
  final s = area.shortestSide;
  if (kind.suit == Suit.flower) {
    switch (kind.rank) {
      case 1:
        _plum(canvas, center, s);
      case 2:
        _orchid(canvas, center, s);
      case 3:
        _bamboo(canvas, center, s);
      default:
        _chrysanthemum(canvas, center, s);
    }
  } else {
    switch (kind.rank) {
      case 1:
        _spring(canvas, center, s);
      case 2:
        _summer(canvas, center, s);
      case 3:
        _autumn(canvas, center, s);
      default:
        _winter(canvas, center, s);
    }
  }
}

void _petals(Canvas canvas, Offset center, int count, double dist, double w,
    double h, Color color) {
  final paint = Paint()..color = color;
  for (var i = 0; i < count; i++) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(i * 2 * math.pi / count);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(0, -dist), width: w, height: h), paint);
    canvas.restore();
  }
}

void _plum(Canvas canvas, Offset c, double s) {
  final petal = Paint()..color = const Color(0xFFE07A9B);
  for (var i = 0; i < 5; i++) {
    final a = -math.pi / 2 + i * 2 * math.pi / 5;
    canvas.drawCircle(
        c + Offset(math.cos(a), math.sin(a)) * s * 0.16, s * 0.14, petal);
  }
  final stamen = Paint()
    ..color = const Color(0xFF9B2C4F)
    ..strokeWidth = s * 0.02;
  for (var i = 0; i < 6; i++) {
    final a = i * math.pi / 3;
    canvas.drawLine(c, c + Offset(math.cos(a), math.sin(a)) * s * 0.13, stamen);
  }
  canvas.drawCircle(c, s * 0.09, Paint()..color = const Color(0xFFF2C94C));
}

void _orchid(Canvas canvas, Offset c, double s) {
  _petals(canvas, c, 5, s * 0.19, s * 0.1, s * 0.36, const Color(0xFF8E6FB8));
  canvas.drawCircle(c, s * 0.07, Paint()..color = const Color(0xFF5E548E));
  canvas.drawCircle(c.translate(0, s * 0.03), s * 0.03,
      Paint()..color = const Color(0xFFF2C94C));
}

void _bamboo(Canvas canvas, Offset c, double s) {
  final stalk = Paint()..color = const Color(0xFF2D6A4F);
  for (final dx in [-s * 0.15, s * 0.11]) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: c + Offset(dx, 0), width: s * 0.09, height: s * 0.54),
        Radius.circular(s * 0.045),
      ),
      stalk,
    );
  }
  final node = Paint()..color = const Color(0xFF1B4332);
  for (final dx in [-s * 0.15, s * 0.11]) {
    for (final dy in [-s * 0.09, s * 0.11]) {
      canvas.drawRect(
        Rect.fromCenter(
            center: c + Offset(dx, dy), width: s * 0.11, height: s * 0.025),
        node,
      );
    }
  }
  final leaf = Paint()..color = const Color(0xFF52B788);
  for (final (dx, angle) in [(s * 0.11, 0.55), (-s * 0.15, 2.6)]) {
    canvas.save();
    canvas.translate(c.dx + dx, c.dy - s * 0.29);
    canvas.rotate(angle);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(s * 0.13, 0), width: s * 0.26, height: s * 0.08),
      leaf,
    );
    canvas.restore();
  }
}

void _chrysanthemum(Canvas canvas, Offset c, double s) {
  _petals(
      canvas, c, 16, s * 0.16, s * 0.055, s * 0.32, const Color(0xFFE9A03B));
  _petals(canvas, c, 8, s * 0.09, s * 0.06, s * 0.18, const Color(0xFFF2C94C));
  canvas.drawCircle(c, s * 0.05, Paint()..color = const Color(0xFFB26A00));
}

void _spring(Canvas canvas, Offset c, double s) {
  final stem = Paint()
    ..color = const Color(0xFF2D6A4F)
    ..strokeWidth = s * 0.03
    ..strokeCap = StrokeCap.round;
  canvas.drawLine(c + Offset(0, s * 0.32), c - Offset(0, s * 0.04), stem);
  final leaf = Paint()..color = const Color(0xFF52B788);
  for (final (dy, angle, dx) in [
    (-s * 0.08, 0.7, s * 0.14),
    (-s * 0.17, math.pi - 0.7, s * 0.13),
  ]) {
    canvas.save();
    canvas.translate(c.dx, c.dy + dy);
    canvas.rotate(angle);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(dx, 0), width: s * 0.28, height: s * 0.1),
      leaf,
    );
    canvas.restore();
  }
  canvas.drawCircle(
      c - Offset(0, s * 0.3), s * 0.07, Paint()..color = const Color(0xFFE07A9B));
}

void _summer(Canvas canvas, Offset c, double s) {
  final ray = Paint()
    ..color = const Color(0xFFE76F2A)
    ..strokeWidth = s * 0.035
    ..strokeCap = StrokeCap.round;
  for (var i = 0; i < 8; i++) {
    final dir = Offset(
        math.cos(i * math.pi / 4), math.sin(i * math.pi / 4));
    canvas.drawLine(c + dir * s * 0.2, c + dir * s * 0.3, ray);
  }
  canvas.drawCircle(c, s * 0.17, Paint()..color = const Color(0xFFF2A93B));
  canvas.drawCircle(c, s * 0.11, Paint()..color = const Color(0xFFF7CE5B));
}

void _autumn(Canvas canvas, Offset c, double s) {
  canvas.save();
  canvas.translate(c.dx, c.dy);
  canvas.rotate(0.5);
  canvas.drawOval(
    Rect.fromCenter(
        center: Offset.zero, width: s * 0.32, height: s * 0.5),
    Paint()..color = const Color(0xFFD9782D),
  );
  canvas.drawLine(
    Offset(0, -s * 0.19),
    Offset(0, s * 0.3),
    Paint()
      ..color = const Color(0xFF8C4A12)
      ..strokeWidth = s * 0.025
      ..strokeCap = StrokeCap.round,
  );
  canvas.restore();
}

void _winter(Canvas canvas, Offset c, double s) {
  final arm = Paint()
    ..color = const Color(0xFF4C8DCC)
    ..strokeWidth = s * 0.035
    ..strokeCap = StrokeCap.round;
  final tip = Paint()..color = const Color(0xFF4C8DCC);
  for (var i = 0; i < 6; i++) {
    final dir = Offset(math.cos(i * math.pi / 3), math.sin(i * math.pi / 3));
    canvas.drawLine(c, c + dir * s * 0.26, arm);
    canvas.drawCircle(c + dir * s * 0.26, s * 0.03, tip);
  }
  canvas.drawCircle(c, s * 0.05, tip);
}
