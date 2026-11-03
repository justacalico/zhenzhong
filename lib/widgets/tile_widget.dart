import 'package:flutter/material.dart';

import '../game/board.dart';
import '../game/tile.dart';
import 'tile_art.dart';

class MahjongTileWidget extends StatefulWidget {
  final BoardTile tile;
  final double width;
  final double height;
  final double depth;
  final bool selected;
  final bool free;
  final bool hinted;
  final bool dimBlocked;
  final VoidCallback? onTap;

  const MahjongTileWidget({
    super.key,
    required this.tile,
    required this.width,
    required this.height,
    this.depth = 6,
    this.selected = false,
    this.free = true,
    this.hinted = false,
    this.dimBlocked = false,
    this.onTap,
  });

  @override
  State<MahjongTileWidget> createState() => _MahjongTileWidgetState();
}

class _MahjongTileWidgetState extends State<MahjongTileWidget> {
  var _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: CustomPaint(
          size: Size(widget.width + widget.depth, widget.height + widget.depth),
          painter: _TilePainter(
            tile: widget.tile,
            faceWidth: widget.width,
            faceHeight: widget.height,
            depth: widget.depth,
            selected: widget.selected,
            free: widget.free,
            hinted: widget.hinted,
            dimBlocked: widget.dimBlocked,
            hovered: _hovering && widget.free && !widget.tile.removed,
          ),
        ),
      ),
    );
  }
}

class _TilePainter extends CustomPainter {
  final BoardTile tile;
  final double faceWidth;
  final double faceHeight;
  final double depth;
  final bool selected;
  final bool free;
  final bool hinted;
  final bool dimBlocked;
  final bool hovered;

  _TilePainter({
    required this.tile,
    required this.faceWidth,
    required this.faceHeight,
    required this.depth,
    required this.selected,
    required this.free,
    required this.hinted,
    required this.dimBlocked,
    required this.hovered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final faceRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, faceWidth, faceHeight),
      Radius.circular(depth * 1.2),
    );
    final bodyRect = faceRect.shift(Offset(depth, depth));

    canvas.drawRRect(
      bodyRect,
      Paint()..color = const Color(0xFF3E3626),
    );
    canvas.drawRRect(
      bodyRect.shift(const Offset(1.5, 2.5)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    final facePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFFBEB), Color(0xFFF3E9C8)],
      ).createShader(Rect.fromLTWH(0, 0, faceWidth, faceHeight));
    canvas.drawRRect(faceRect, facePaint);
    canvas.drawRRect(
      faceRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const Color(0xFFCBB989),
    );

    _paintFace(canvas);
    _paintOverlay(canvas, faceRect);
  }

  void _paintFace(Canvas canvas) {
    final kind = tile.kind;
    if (kind.suit == Suit.flower || kind.suit == Suit.season) {
      paintTileArt(
          canvas, kind, Rect.fromLTWH(0, 0, faceWidth, faceHeight));
      return;
    }
    final bottom = kind.bottomGlyph;
    final topSize = bottom == null ? faceHeight * 0.52 : faceHeight * 0.42;

    final top = TextPainter(
      text: TextSpan(
        text: kind.topGlyph,
        style: TextStyle(
          fontFamily: 'NotoSansSC',
          fontSize: topSize,
          fontWeight: FontWeight.bold,
          color: kind.faceColor,
          height: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    top.paint(
      canvas,
      Offset(
        (faceWidth - top.width) / 2,
        bottom == null
            ? (faceHeight - top.height) / 2
            : faceHeight * 0.14,
      ),
    );

    if (bottom != null) {
      final bottomPainter = TextPainter(
        text: TextSpan(
          text: bottom,
          style: TextStyle(
            fontFamily: 'NotoSansSC',
            fontSize: faceHeight * 0.3,
            fontWeight: FontWeight.bold,
            color: kind.faceColor,
            height: 1.0,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      bottomPainter.paint(
        canvas,
        Offset(
          (faceWidth - bottomPainter.width) / 2,
          faceHeight * 0.56,
        ),
      );
    }
  }

  void _paintOverlay(Canvas canvas, RRect faceRect) {
    if (dimBlocked && !free && !tile.removed) {
      canvas.drawRRect(
        faceRect,
        Paint()..color = Colors.black.withValues(alpha: 0.35),
      );
    }
    if (hovered) {
      canvas.drawRRect(
        faceRect,
        Paint()..color = Colors.white.withValues(alpha: 0.25),
      );
    }
    if (selected || hinted) {
      canvas.drawRRect(
        faceRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = selected ? const Color(0xFFE9C46A) : const Color(0xFF4CC9F0),
      );
      canvas.drawRRect(
        faceRect,
        Paint()
          ..color = (selected ? const Color(0xFFE9C46A) : const Color(0xFF4CC9F0))
              .withValues(alpha: 0.18),
      );
    }
  }

  @override
  bool shouldRepaint(_TilePainter old) =>
      old.selected != selected ||
      old.free != free ||
      old.hinted != hinted ||
      old.dimBlocked != dimBlocked ||
      old.hovered != hovered ||
      old.tile.removed != tile.removed ||
      old.tile.kind != tile.kind;
}
