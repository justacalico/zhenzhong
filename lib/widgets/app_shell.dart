import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/window_actions.dart';
import 'sidebar.dart';
import 'title_bar.dart';

bool isDesktopPlatform(TargetPlatform platform) =>
    !kIsWeb &&
    (platform == TargetPlatform.linux ||
        platform == TargetPlatform.macOS ||
        platform == TargetPlatform.windows);

class AppShell extends StatefulWidget {
  final List<NavDestination> destinations;
  final WindowActions actions;

  const AppShell({
    super.key,
    required this.destinations,
    this.actions = defaultWindowActions,
  });

  @override
  State<AppShell> createState() => AppShellState();
}

class AppShellState extends State<AppShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _index = 0;

  void select(int index) {
    setState(() => _index = index);
    final scaffold = _scaffoldKey.currentState;
    if (scaffold?.isDrawerOpen ?? false) {
      scaffold!.closeDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final desktop = isDesktopPlatform(Theme.of(context).platform);
    final l = l10n(context);
    final body = IndexedStack(
      index: _index,
      children: [
        for (final d in widget.destinations) d.buildPage(),
      ],
    );
    final sidebar = NavSidebar(
      destinations: widget.destinations,
      selectedIndex: _index,
      onSelected: select,
    );

    if (!desktop) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text(l.appTitle)),
        drawer: Drawer(
          child: SafeArea(child: sidebar),
        ),
        body: body,
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          MacTitleBar(title: l.appTitle, actions: widget.actions),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(width: 240, child: sidebar),
                const VerticalDivider(width: 1),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
