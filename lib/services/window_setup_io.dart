// coverage:ignore-file
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

Future<void> initializeWindow() async {
  if (Platform.environment['FLUTTER_TEST'] == 'true') return;
  if (!Platform.isLinux && !Platform.isMacOS && !Platform.isWindows) {
    return;
  }

  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(1200, 800),
    minimumSize: Size(560, 400),
    center: true,
    title: '震中 Zhenzhong',
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
