import 'package:flutter/material.dart';

import '../game/board.dart';
import 'tile_widget.dart';

class BoardView extends StatelessWidget {
  static const tileW = 60.0;
  static const tileH = 76.0;
  static const layerDX = -10.0;
  static const layerDY = -12.0;
  static const depth = 7.0;

  final MahjongGame game;
  final Set<int> hintIds;
  final ValueChanged<BoardTile> onTileTap;
  final bool dimBlocked;

  const BoardView({
    super.key,
    required this.game,
    required this.onTileTap,
    this.hintIds = const {},
    this.dimBlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    var maxX = 0;
    var maxY = 0;
    var maxZ = 0;
    for (final t in game.tiles) {
      if (t.pos.x > maxX) maxX = t.pos.x;
      if (t.pos.y > maxY) maxY = t.pos.y;
      if (t.pos.z > maxZ) maxZ = t.pos.z;
    }
    final boardW = (maxX + 2) * tileW / 2 + maxZ * -layerDX + depth + 24;
    final boardH = (maxY + 2) * tileH / 2 + maxZ * -layerDY + depth + 24;

    final ordered = game.tiles.where((t) => !t.removed).toList()
      ..sort((a, b) {
        final z = a.pos.z.compareTo(b.pos.z);
        if (z != 0) return z;
        final y = a.pos.y.compareTo(b.pos.y);
        if (y != 0) return y;
        return a.pos.x.compareTo(b.pos.x);
      });

    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: boardW,
          height: boardH,
          child: Stack(
            children: [
              for (final tile in ordered)
                Positioned(
                  left: 12 +
                      maxZ * -layerDX +
                      tile.pos.x * tileW / 2 +
                      tile.pos.z * layerDX,
                  top: 12 +
                      maxZ * -layerDY +
                      tile.pos.y * tileH / 2 +
                      tile.pos.z * layerDY,
                  child: MahjongTileWidget(
                    key: ValueKey(tile.id),
                    tile: tile,
                    width: tileW,
                    height: tileH,
                    depth: depth,
                    selected: game.selectedId == tile.id,
                    free: game.isFree(tile),
                    hinted: hintIds.contains(tile.id),
                    dimBlocked: dimBlocked,
                    onTap: () => onTileTap(tile),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
