import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/l10n.dart';

class NavDestination {
  final IconData icon;
  final String Function(AppLocalizations l) label;
  final Widget Function() buildPage;

  const NavDestination({
    required this.icon,
    required this.label,
    required this.buildPage,
  });
}

class NavSidebar extends StatelessWidget {
  final List<NavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const NavSidebar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = l10n(context);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
          child: Row(
            children: [
              Image.asset('assets/icon.png', width: 28, height: 28),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  l.appTitle,
                  style: theme.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        for (var i = 0; i < destinations.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Material(
              color: Colors.transparent,
              shape: const StadiumBorder(),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                key: Key('nav_$i'),
                leading: Icon(destinations[i].icon, size: 20),
                title: Text(destinations[i].label(l)),
                dense: true,
                selected: i == selectedIndex,
                selectedTileColor: theme.colorScheme.secondaryContainer,
                onTap: () => onSelected(i),
              ),
            ),
          ),
      ],
    );
  }
}
