import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'l10n/app_localizations.dart';

void main() => runApp(const LandingApp());

enum LandingTheme { system, light, dark, oled }

class LandingApp extends StatefulWidget {
  const LandingApp({super.key});
  @override
  State<LandingApp> createState() => _LandingAppState();
}

class _LandingAppState extends State<LandingApp> {
  LandingTheme _theme = LandingTheme.system;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      final i = p.getInt('theme');
      if (i != null) setState(() => _theme = LandingTheme.values[i]);
    });
  }

  void _setTheme(LandingTheme t) {
    setState(() => _theme = t);
    SharedPreferences.getInstance()
        .then((p) => p.setInt('theme', t.index));
  }

  @override
  Widget build(BuildContext context) {
    final dark = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: const Color(0xFF2D6A4F),
    );
    return MaterialApp(
      title: '震中 Zhenzhong',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true, colorSchemeSeed: const Color(0xFF2D6A4F)),
      darkTheme: _theme == LandingTheme.oled
          ? dark.copyWith(scaffoldBackgroundColor: Colors.black)
          : dark,
      themeMode: switch (_theme) {
        LandingTheme.system => ThemeMode.system,
        LandingTheme.light => ThemeMode.light,
        LandingTheme.dark || LandingTheme.oled => ThemeMode.dark,
      },
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: LandingPage(theme: _theme, onTheme: _setTheme),
    );
  }
}

class LandingPage extends StatelessWidget {
  final LandingTheme theme;
  final ValueChanged<LandingTheme> onTheme;

  const LandingPage({super.key, required this.theme, required this.onTheme});

  static const releasesApi =
      'https://gitlab.com/api/v4/projects/HttpAnimations%2Fzhenzhong/releases?per_page=5';
  static const releasesUrl =
      'https://gitlab.com/HttpAnimations/zhenzhong/-/releases';
  static const repoUrl = 'https://gitlab.com/HttpAnimations/zhenzhong';

  Future<List<dynamic>> _releases() async {
    final r = await http.get(Uri.parse(releasesApi));
    if (r.statusCode != 200) return [];
    return jsonDecode(r.body) as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.appTitle),
        actions: [
          PopupMenuButton<LandingTheme>(
            icon: const Icon(Icons.brightness_6),
            tooltip: l.theme,
            onSelected: onTheme,
            itemBuilder: (c) => [
              _themeItem(l, LandingTheme.system, l.themeSystem),
              _themeItem(l, LandingTheme.light, l.themeLight),
              _themeItem(l, LandingTheme.dark, l.themeDark),
              _themeItem(l, LandingTheme.oled, l.themeOled),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(children: [
              Image.asset('assets/icon.png', width: 96),
              const SizedBox(height: 12),
              Text(l.appTitle,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(l.tagline, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: Text(l.play),
                onPressed: () =>
                    launchUrl(Uri.parse('app/')),
              ),
            ]),
          ),
          const SizedBox(height: 32),
          Text(l.featuresTitle,
              style: Theme.of(context).textTheme.titleLarge),
          for (final f in [l.f1, l.f2, l.f3, l.f4])
            ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text(f), dense: true),
          Wrap(
            spacing: 16, runSpacing: 16, alignment: WrapAlignment.center,
            children: [
              for (final img in [
                'assets/app_desktop.png',
                'assets/app_help.png',
                'assets/app_about.png',
              ])
                Image.asset(img, width: 320),
            ],
          ),
          const SizedBox(height: 32),
          Text(l.download, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          FutureBuilder<List<dynamic>>(
            future: _releases(),
            builder: (c, s) {
              if (s.connectionState != ConnectionState.done) {
                return Text(l.loadingReleases);
              }
              final list = s.data ?? const [];
              if (list.isEmpty) return Text(l.noReleases);
              return Column(children: [
                for (final r in list)
                  ListTile(
                    leading: const Icon(Icons.download),
                    title: Text('${r['tag_name']}  ${r['name'] ?? ''}'),
                    subtitle: Text((r['released_at'] ?? '').toString().split('T').first),
                    onTap: () => launchUrl(Uri.parse(
                        '$releasesUrl/${r['tag_name']}')),
                  ),
              ]);
            },
          ),
          Wrap(spacing: 8, children: [
            FilledButton.tonalIcon(
              icon: const Icon(Icons.download),
              label: Text(l.releases),
              onPressed: () => launchUrl(Uri.parse(releasesUrl)),
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.terminal),
              label: Text(l.flatpak),
              onPressed: () =>
                  launchUrl(Uri.parse('zhenzhong.flatpakref')),
            ),
            TextButton.icon(
              icon: const Icon(Icons.code),
              label: Text(l.sourceCode),
              onPressed: () => launchUrl(Uri.parse(repoUrl)),
            ),
          ]),
        ],
      ),
    );
  }

  PopupMenuItem<LandingTheme> _themeItem(
          AppLocalizations l, LandingTheme t, String label) =>
      PopupMenuItem(value: t, child: Text(label));
}
