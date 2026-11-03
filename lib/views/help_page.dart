import 'package:flutter/material.dart';

import '../game/board.dart';
import '../game/layout.dart';
import '../game/tile.dart';
import '../l10n/l10n.dart';
import '../widgets/tile_widget.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = l10n(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _HelpSection(title: l.helpGoalTitle, body: l.helpGoal),
        _HelpSection(title: l.helpFreeTitle, body: l.helpFree),
        _HelpSection(title: l.helpMatchTitle, body: l.helpMatch),
        _HelpSection(title: l.helpControlsTitle, body: l.helpControls),
        const SizedBox(height: 16),
        Text(
          '梅兰竹菊 · 春夏秋冬',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < _sampleKinds.length; i++)
              MahjongTileWidget(
                tile: BoardTile(
                  id: i,
                  pos: const BoardPos(0, 0, 0),
                  kind: _sampleKinds[i],
                ),
                width: 48,
                height: 62,
                depth: 5,
                free: true,
              ),
          ],
        ),
      ],
    );
  }
}

const _sampleKinds = [
  TileKind(Suit.characters, 5),
  TileKind(Suit.bamboo, 3),
  TileKind(Suit.circles, 8),
  TileKind(Suit.wind, 1),
  TileKind(Suit.dragon, 1),
  TileKind(Suit.dragon, 2),
  TileKind(Suit.dragon, 3),
  TileKind(Suit.flower, 1),
  TileKind(Suit.season, 3),
];

class _HelpSection extends StatelessWidget {
  final String title;
  final String body;

  const _HelpSection({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(body, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
