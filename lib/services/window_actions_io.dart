// coverage:ignore-file
import 'package:window_manager/window_manager.dart';

class WindowActions {
  const WindowActions();

  Future<void> close() => windowManager.close();

  Future<void> minimize() => windowManager.minimize();

  Future<void> startDrag() => windowManager.startDragging();

  Future<void> toggleMaximize() async {
    if (await windowManager.isMaximized()) {
      await windowManager.unmaximize();
    } else {
      await windowManager.maximize();
    }
  }
}

const defaultWindowActions = WindowActions();
