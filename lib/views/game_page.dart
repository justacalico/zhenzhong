import 'dart:async';

import 'package:flutter/material.dart';

import '../game/board.dart';
import '../l10n/l10n.dart';
import '../state/stats_store.dart';
import '../utils/time_fmt.dart';
import '../widgets/board_view.dart';

class GamePage extends StatefulWidget {
  final MahjongGame game;
  final StatsStore stats;

  const GamePage({
    super.key,
    required this.game,
    required this.stats,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Set<int> _hintIds = {};
  Timer? _hintTimer;
  Timer? _clockTimer;
  var _wonDialogShown = false;
  var _stuckDialogShown = false;
  var _recordedWin = false;

  MahjongGame get game => widget.game;

  @override
  void initState() {
    super.initState();
    game.addListener(_onGameChanged);
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && !game.won) setState(() {});
    });
  }

  @override
  void dispose() {
    game.removeListener(_onGameChanged);
    _hintTimer?.cancel();
    _clockTimer?.cancel();
    super.dispose();
  }

  void _onGameChanged() {
    _hintIds.clear();
    if (!game.won) _wonDialogShown = false;
    if (game.hasMoves) _stuckDialogShown = false;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowDialog());
  }

  void _maybeShowDialog() {
    if (!mounted) return;
    final l = l10n(context);
    if (game.won && !_wonDialogShown) {
      _wonDialogShown = true;
      if (!_recordedWin) {
        _recordedWin = true;
        widget.stats.recordGame(won: true, seconds: game.elapsed.inSeconds);
      }
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          key: const Key('won_dialog'),
          title: Text(l.wonTitle),
          content: Text(l.wonBody(formatDuration(game.elapsed))),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.close),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                _newGame();
              },
              child: Text(l.playAgain),
            ),
          ],
        ),
      );
    } else if (!game.won &&
        game.tilesRemaining > 0 &&
        !game.hasMoves &&
        !_stuckDialogShown) {
      _stuckDialogShown = true;
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          key: const Key('stuck_dialog'),
          title: Text(l.stuckTitle),
          content: Text(l.stuckBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.keepPlaying),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                game.shuffle();
              },
              child: Text(l.shuffle),
            ),
          ],
        ),
      );
    }
  }

  void _newGame() {
    if (!game.won && game.pairsRemoved > 0) {
      widget.stats.recordGame(won: false, seconds: 0);
    }
    game.newDeal();
    _wonDialogShown = false;
    _stuckDialogShown = false;
    _recordedWin = false;
  }

  void _hint() {
    final move = game.hint();
    if (move == null) return;
    setState(() {
      _hintIds
        ..clear()
        ..addAll([move.a.id, move.b.id]);
    });
    _hintTimer?.cancel();
    _hintTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _hintIds.clear());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = l10n(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilledButton.icon(
                key: const Key('btn_new'),
                onPressed: _newGame,
                icon: const Icon(Icons.replay),
                label: Text(l.newGame),
              ),
              TextButton.icon(
                key: const Key('btn_hint'),
                onPressed: _hint,
                icon: const Icon(Icons.lightbulb_outline),
                label: Text(l.hint),
              ),
              TextButton.icon(
                key: const Key('btn_undo'),
                onPressed: game.history.isEmpty ? null : () => game.undo(),
                icon: const Icon(Icons.undo),
                label: Text(l.undo),
              ),
              TextButton.icon(
                key: const Key('btn_shuffle'),
                onPressed:
                    game.tilesRemaining < 2 ? null : () => game.shuffle(),
                icon: const Icon(Icons.shuffle),
                label: Text(l.shuffle),
              ),
              const SizedBox(width: 8),
              _StatChip(label: l.timeElapsed(formatDuration(game.elapsed))),
              _StatChip(label: l.tilesRemaining(game.tilesRemaining)),
              _StatChip(label: l.freePairs(game.availableMoves().length)),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: BoardView(
              game: game,
              hintIds: _hintIds,
              onTileTap: game.tap,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;

  const _StatChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
