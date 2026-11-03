// coverage:ignore-file
class WindowActions {
  const WindowActions();

  Future<void> close() async {}

  Future<void> minimize() async {}

  Future<void> startDrag() async {}

  Future<void> toggleMaximize() async {}
}

const defaultWindowActions = WindowActions();
