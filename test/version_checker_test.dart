import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:zhenzhong/models/app_update.dart';
import 'package:zhenzhong/services/version_checker.dart';

http.Client fakeClient(Object Function(Uri uri) handler) =>
    MockClient((request) async {
      final result = handler(request.url);
      if (result is http.Response) return result;
      return http.Response(jsonEncode(result), 200);
    });

void main() {
  group('VersionChecker.check', () {
    test('reports an update when a newer release exists', () async {
      final checker = VersionChecker(
        client: fakeClient((uri) => [
          {'tag_name': 'v1.4.0'},
          {'tag_name': 'v1.3.0'},
        ]),
      );
      final update = await checker.check('1.3.0');
      expect(update.updateAvailable, isTrue);
      expect(update.latestVersion, '1.4.0');
      expect(
        update.releaseUrl,
        '${VersionChecker.releasesUrl}/v1.4.0',
      );
    });

    test('reports up to date on the newest version', () async {
      final checker = VersionChecker(
        client: fakeClient((uri) => [
          {'tag_name': 'v1.4.0'},
        ]),
      );
      final update = await checker.check('1.4.0');
      expect(update.updateAvailable, isFalse);
      expect(update.latestVersion, '1.4.0');
    });

    test('no releases returns a bare result', () async {
      final checker = VersionChecker(client: fakeClient((uri) => []));
      final update = await checker.check('1.0.0');
      expect(update.updateAvailable, isFalse);
      expect(update.latestVersion, isEmpty);
      expect(update.releaseUrl, VersionChecker.releasesUrl);
    });

    test('unparseable tags are skipped and highest semver wins', () async {
      final checker = VersionChecker(
        client: fakeClient((uri) => [
          {'tag_name': 'not-a-version'},
          {'tag_name': 'v2.0.0'},
          {'tag_name': 'v10.0.0'},
          {'tag_name': 42},
          'garbage',
          {'other': 'field'},
        ]),
      );
      final update = await checker.check('1.0.0');
      expect(update.latestVersion, '10.0.0');
    });

    test('unparseable current version always flags an update', () async {
      final checker = VersionChecker(
        client: fakeClient((uri) => [
          {'tag_name': 'v1.0.0'},
        ]),
      );
      final update = await checker.check('dev-build');
      expect(update.updateAvailable, isTrue);
      expect(update.latestVersion, '1.0.0');
    });

    test('paginates when a page is full', () async {
      var pages = 0;
      final checker = VersionChecker(
        client: fakeClient((uri) {
          pages++;
          if (pages == 1) {
            return [
              for (var i = 0; i < 100; i++) {'tag_name': 'v0.0.$i'},
            ];
          }
          return [
            {'tag_name': 'v9.9.9'},
          ];
        }),
      );
      final update = await checker.check('1.0.0');
      expect(pages, 2);
      expect(update.latestVersion, '9.9.9');
    });

    test('http error throws VersionCheckException', () async {
      final checker = VersionChecker(
        client: MockClient((_) async => http.Response('boom', 500)),
      );
      expect(() => checker.check('1.0.0'),
          throwsA(isA<VersionCheckException>()));
    });

    test('unexpected body shape throws', () async {
      final checker = VersionChecker(
        client: fakeClient((uri) => {'tag_name': 'v1.0.0'}),
      );
      expect(() => checker.check('1.0.0'),
          throwsA(isA<VersionCheckException>()));
    });

    test('network failure throws VersionCheckException', () async {
      final checker = VersionChecker(
        client: MockClient((_) async => throw TimeoutException('offline')),
      );
      expect(() => checker.check('1.0.0'),
          throwsA(isA<VersionCheckException>()));
    });
  });

  group('VersionChecker lifecycle', () {
    test('close releases an owned client', () {
      final checker = VersionChecker();
      checker.close();
      checker.close();
    });
  });

  group('AppUpdate', () {
    test('copyWith and equality', () {
      const a = AppUpdate(
        currentVersion: '1.0.0',
        latestVersion: '1.1.0',
        updateAvailable: true,
        releaseUrl: 'u',
      );
      expect(a.copyWith().hashCode, a.hashCode);
      expect(a.copyWith(), a);
      expect(a.copyWith(latestVersion: '2.0.0').latestVersion, '2.0.0');
      expect(a.copyWith(updateAvailable: false).updateAvailable, isFalse);
      expect(a.copyWith(releaseUrl: 'v').releaseUrl, 'v');
      expect(a.copyWith(currentVersion: '0.9').currentVersion, '0.9');
      expect(a == const AppUpdate(), isFalse);
      expect(a == Object(), isFalse);
      expect(a.copyWith() == a, isTrue);
      expect(a.copyWith(latestVersion: 'x') == a, isFalse);
    });

    test('VersionCheckException toString', () {
      expect(const VersionCheckException('oops').toString(),
          'VersionCheckException: oops');
    });
  });
}
