import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/version_checker.dart';
import '../state/stats_store.dart';
import '../state/update_store.dart';
import '../utils/link_opener.dart';
import '../utils/time_fmt.dart';

class AboutPage extends StatelessWidget {
  final UpdateStore updates;
  final StatsStore stats;
  final LinkOpener linkOpener;

  const AboutPage({
    super.key,
    required this.updates,
    required this.stats,
    required this.linkOpener,
  });

  @override
  Widget build(BuildContext context) {
    final l = l10n(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          children: [
            Image.asset('assets/icon.png', width: 64, height: 64),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.appTitle,
                    style: Theme.of(context).textTheme.headlineSmall),
                FutureBuilder<String>(
                  future: updates.installedVersion(),
                  builder: (context, snapshot) => Text(
                    l.aboutVersion(snapshot.data ?? '…'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Divider(),
        ListenableBuilder(
          listenable: updates,
          builder: (context, _) => _UpdateSection(
            updates: updates,
            linkOpener: linkOpener,
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.code),
          title: Text(l.aboutSource),
          subtitle: const Text('gitlab.com/HttpAnimations/zhenzhong'),
          onTap: () => linkOpener.open(
            Uri.parse('https://gitlab.com/HttpAnimations/zhenzhong'),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.gavel),
          title: Text(l.aboutLicence),
          onTap: () => linkOpener.open(
            Uri.parse(
                'https://gitlab.com/HttpAnimations/zhenzhong/-/blob/main/LICENSE'),
          ),
        ),
        const Divider(),
        ListenableBuilder(
          listenable: stats,
          builder: (context, _) {
            final theme = Theme.of(context);
            final best = stats.bestSeconds;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text(l.statistics,
                      style: theme.textTheme.titleMedium),
                ),
                if (stats.gamesPlayed == 0)
                  ListTile(
                    leading: const Icon(Icons.insights),
                    title: Text(l.statsNoGames),
                  )
                else ...[
                  ListTile(
                    leading: const Icon(Icons.play_circle_outline),
                    title: Text(l.statsGamesPlayed),
                    trailing: Text('${stats.gamesPlayed}'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.emoji_events_outlined),
                    title: Text(l.statsGamesWon),
                    trailing: Text('${stats.gamesWon}'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.timer_outlined),
                    title: Text(l.statsBestTime),
                    trailing: Text(
                      best == null
                          ? '-'
                          : formatDuration(Duration(seconds: best)),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _UpdateSection extends StatelessWidget {
  final UpdateStore updates;
  final LinkOpener linkOpener;

  const _UpdateSection({required this.updates, required this.linkOpener});

  @override
  Widget build(BuildContext context) {
    final l = l10n(context);
    final update = updates.update;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          key: const Key('check_updates'),
          leading: const Icon(Icons.system_update_alt),
          title: Text(l.checkForUpdates),
          trailing: updates.checking
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.chevron_right),
          onTap: updates.checking ? null : () => updates.check(),
        ),
        if (updates.checking)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(l.updateChecking),
          )
        else if (updates.failed)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l.updateFailed,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          )
        else if (update != null && update.updateAvailable) ...[
          ListTile(
            leading: const Icon(Icons.new_releases_outlined),
            title: Text(l.updateAvailable(update.latestVersion)),
            subtitle: Text(update.releaseUrl),
            onTap: () => linkOpener.open(Uri.parse(update.releaseUrl)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Wrap(
              spacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: () =>
                      linkOpener.open(Uri.parse(update.releaseUrl)),
                  child: Text(l.updateViewRelease),
                ),
                TextButton(
                  onPressed: () => linkOpener
                      .open(Uri.parse(VersionChecker.releasesUrl)),
                  child: Text(l.updateAllReleases),
                ),
              ],
            ),
          ),
        ] else if (update != null)
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: Text(l.updateUpToDate),
            subtitle: Text(VersionChecker.releasesUrl),
            onTap: () =>
                linkOpener.open(Uri.parse(VersionChecker.releasesUrl)),
          ),
      ],
    );
  }
}
