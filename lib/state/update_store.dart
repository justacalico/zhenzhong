import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/app_update.dart';
import '../services/version_checker.dart';

class UpdateStore extends ChangeNotifier {
  final VersionChecker _checker;
  final Future<String> Function() _versionOf;

  AppUpdate? _update;
  bool _checking = false;
  bool _failed = false;
  Future<void>? _inFlight;

  UpdateStore({VersionChecker? checker, Future<String> Function()? versionOf})
      : _checker = checker ?? VersionChecker(),
        _versionOf = versionOf ?? _packageVersion;

  static Future<String> _packageVersion() async {
    // coverage:ignore-start
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version;
    } catch (_) {
      return '0.0.0';
    }
    // coverage:ignore-end
  }

  AppUpdate? get update => _update;
  bool get checking => _checking;
  bool get failed => _failed;

  Future<String> installedVersion() => _versionOf();

  Future<void> check() {
    final running = _inFlight;
    if (running != null) return running;
    final future = _check();
    _inFlight = future;
    return future.whenComplete(() => _inFlight = null);
  }

  Future<void> _check() async {
    _checking = true;
    _failed = false;
    notifyListeners();
    try {
      final update = await _checker.check(await _versionOf());
      _update = update;
    } catch (_) {
      _failed = true;
    }
    _checking = false;
    notifyListeners();
  }
}
