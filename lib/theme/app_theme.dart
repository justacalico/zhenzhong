import 'package:flutter/material.dart';

class AppTheme {
  static const seed = Color(0xFF2D6A4F);

  static ThemeData light() => _base(Brightness.light);

  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData oled() => dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: dark().colorScheme.copyWith(
              surface: Colors.black,
              surfaceContainerHighest: const Color(0xFF101010),
            ),
      );

  static ThemeData _base(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'NotoSans',
      fontFamilyFallback: const ['NotoSansSC'],
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
