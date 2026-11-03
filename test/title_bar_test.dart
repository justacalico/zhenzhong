import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zhenzhong/widgets/title_bar.dart';

import 'helpers.dart';

void main() {
  setUpAll(loadTestFonts);

  testWidgets('traffic lights call window actions', (tester) async {
    final actions = FakeWindowActions();
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: testDelegates,
      supportedLocales: testLocales,
      home: Scaffold(body: MacTitleBar(title: 'Test', actions: actions)),
    ));
    await tester.tap(find.byKey(const Key('window_close')));
    await tester.tap(find.byKey(const Key('window_minimize')));
    await tester.tap(find.byKey(const Key('window_maximize')));
    expect(actions.calls, ['close', 'minimize', 'maximize']);
  });

  testWidgets('hover reveals the glyph on traffic lights', (tester) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: testDelegates,
      supportedLocales: testLocales,
      home: Scaffold(
        body: MacTitleBar(title: 'Test', actions: FakeWindowActions()),
      ),
    ));
    expect(find.byIcon(Icons.close), findsNothing);
    final hover = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await hover.addPointer(location: Offset.zero);
    await hover.moveTo(tester.getCenter(find.byKey(const Key('window_close'))));
    await tester.pump();
    expect(find.byIcon(Icons.close), findsOneWidget);
    await hover.moveTo(Offset.zero);
    await tester.pump();
    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('double tap maximizes and drag starts a move', (tester) async {
    final actions = FakeWindowActions();
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: testDelegates,
      supportedLocales: testLocales,
      home: Scaffold(
        body: MacTitleBar(title: 'My Title', actions: actions),
      ),
    ));
    expect(find.text('My Title'), findsOneWidget);
    final bar = find.text('My Title');
    await tester.tap(bar, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(bar, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 400));
    expect(actions.calls, contains('maximize'));
    final gesture =
        await tester.startGesture(tester.getCenter(find.byType(MacTitleBar)));
    await gesture.moveBy(const Offset(40, 0));
    await tester.pump();
    await gesture.up();
    await tester.pump(const Duration(milliseconds: 400));
    expect(actions.calls, contains('drag'));
  });
}
