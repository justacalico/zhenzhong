import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsStore extends ChangeNotifier {
  static const _playedKey = 'stats_played';
  static const _wonKey = 'stats_won';
  static const _bestKey = 'stats_best_seconds';

  final SharedPreferences _prefs;

  int _played = 0;
  int _won = 0;
  int? _bestSeconds;

  StatsStore(this._prefs);

  static Future<StatsStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    final store = StatsStore(prefs);
    store._played = prefs.getInt(_playedKey) ?? 0;
    store._won = prefs.getInt(_wonKey) ?? 0;
    store._bestSeconds = prefs.getInt(_bestKey);
    return store;
  }

  int get gamesPlayed => _played;
  int get gamesWon => _won;
  int? get bestSeconds => _bestSeconds;

  Future<void> recordGame({required bool won, required int seconds}) async {
    _played++;
    if (won) {
      _won++;
      final best = _bestSeconds;
      if (best == null || seconds < best) _bestSeconds = seconds;
    }
    notifyListeners();
    await _prefs.setInt(_playedKey, _played);
    await _prefs.setInt(_wonKey, _won);
    final best = _bestSeconds;
    if (best != null) {
      await _prefs.setInt(_bestKey, best);
    }
  }
}
