import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/window_actions.dart';

class MacTitleBar extends StatelessWidget {
  final String title;
  final WindowActions actions;

  const MacTitleBar({
    super.key,
    required this.title,
    this.actions = defaultWindowActions,
  });

  @override
  Widget build(BuildContext context) {
    final l = l10n(context);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 40,
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: (_) => actions.startDrag(),
              onDoubleTap: actions.toggleMaximize,
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              _TrafficLight(
                key: const Key('window_close'),
                color: const Color(0xFFFF5F57),
                icon: Icons.close,
                tooltip: l.windowClose,
                onPressed: actions.close,
              ),
              const SizedBox(width: 8),
              _TrafficLight(
                key: const Key('window_minimize'),
                color: const Color(0xFFFEBC2E),
                icon: Icons.remove,
                tooltip: l.windowMinimize,
                onPressed: actions.minimize,
              ),
              const SizedBox(width: 8),
              _TrafficLight(
                key: const Key('window_maximize'),
                color: const Color(0xFF28C840),
                icon: Icons.add,
                tooltip: l.windowMaximise,
                onPressed: actions.toggleMaximize,
              ),
            ],
          ),
          Center(
            child: IgnorePointer(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrafficLight extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _TrafficLight({
    super.key,
    required this.color,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  State<_TrafficLight> createState() => _TrafficLightState();
}

class _TrafficLightState extends State<_TrafficLight> {
  var _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Tooltip(
          message: widget.tooltip,
          child: Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black26, width: 0.5),
            ),
            child: _hovering
                ? Icon(widget.icon, size: 9, color: Colors.black54)
                : null,
          ),
        ),
      ),
    );
  }
}
