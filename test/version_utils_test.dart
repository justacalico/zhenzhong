import 'package:flutter_test/flutter_test.dart';
import 'package:zhenzhong/utils/version_utils.dart';

void main() {
  group('Version.parse', () {
    test('accepts plain and v-prefixed semver', () {
      expect(Version.parse('1.2.3')!.core, [1, 2, 3]);
      expect(Version.parse('v1.2.3')!.core, [1, 2, 3]);
      expect(Version.parse('V2.0.0')!.core, [2, 0, 0]);
      expect(Version.parse(' 1.2.3 ')!.core, [1, 2, 3]);
      expect(Version.parse('1.2.3+build.5')!.core, [1, 2, 3]);
      expect(Version.parse('1.2.3-rc.1')!.pre, ['rc', '1']);
    });

    test('rejects malformed input', () {
      for (final s in [
        null,
        '',
        'v',
        '1.2',
        '1.2.3.4',
        'a.b.c',
        '01.2.3',
        '1.2.x',
        '1.2.3-',
        '1.2.3-rc..1',
        '1.2.3-rc_1',
        '1.2.3-01',
      ]) {
        expect(Version.parse(s), isNull, reason: '"$s" should not parse');
      }
    });
  });

  group('Version.compareTo', () {
    test('orders by core then pre-release', () {
      expect(Version.parse('1.0.0')!.compareTo(Version.parse('1.0.0')!), 0);
      expect(Version.parse('1.0.0')!.compareTo(Version.parse('2.0.0')!) < 0,
          isTrue);
      expect(Version.parse('1.2.0')!.compareTo(Version.parse('1.10.0')!) < 0,
          isTrue);
      expect(Version.parse('1.2.4')!.compareTo(Version.parse('1.2.3')!) > 0,
          isTrue);
      expect(
          Version.parse('1.0.0-rc.1')!
                  .compareTo(Version.parse('1.0.0')!) <
              0,
          isTrue);
      expect(
          Version.parse('1.0.0')!
                  .compareTo(Version.parse('1.0.0-rc.1')!) >
              0,
          isTrue);
      expect(
          Version.parse('1.0.0-alpha')!
                  .compareTo(Version.parse('1.0.0-alpha.1')!) <
              0,
          isTrue);
      expect(
          Version.parse('1.0.0-alpha.1')!
                  .compareTo(Version.parse('1.0.0-alpha.beta')!) <
              0,
          isTrue);
      expect(
          Version.parse('1.0.0-alpha.beta')!
                  .compareTo(Version.parse('1.0.0-beta')!) <
              0,
          isTrue);
      expect(
          Version.parse('1.0.0-beta.2')!
                  .compareTo(Version.parse('1.0.0-beta.11')!) <
              0,
          isTrue);
      expect(
          Version.parse('1.0.0-rc.1')!
                  .compareTo(Version.parse('1.0.0')!) <
              0,
          isTrue);
    });
  });

  group('value semantics', () {
    test('toString round-trips', () {
      expect(Version.parse('1.2.3').toString(), '1.2.3');
      expect(Version.parse('v1.2.3-rc.1').toString(), '1.2.3-rc.1');
    });

    test('equality', () {
      expect(Version.parse('1.2.3'), Version.parse('v1.2.3'));
      expect(Version.parse('1.2.3') == Version.parse('1.2.4'), isFalse);
      expect(Version.parse('1.2.3-rc') == Version.parse('1.2.3'), isFalse);
      expect(Version.parse('1.2.3') == Object(), isFalse);
      expect(Version.parse('1.2.3').hashCode,
          Version.parse('v1.2.3').hashCode);
    });
  });
}
