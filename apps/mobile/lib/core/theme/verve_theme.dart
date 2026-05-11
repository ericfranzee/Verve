import 'package:flutter/material.dart';

class VerveTokens {
  static const Color auraTeal = Color(0xFF008080);
  static const Color nexusAmber = Color(0xFFFFBF00);
  static const Color vitalEmerald = Color(0xFF50C878);
  static const Color listeningCyan = Color(0xFF22D3EE);
  static const Color backgroundBlack = Color(0xFF000000);
}

class VerveTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: VerveTokens.backgroundBlack,
      colorScheme: ColorScheme.fromSeed(
        seedColor: VerveTokens.auraTeal,
        brightness: Brightness.dark,
        primary: VerveTokens.auraTeal,
        secondary: VerveTokens.nexusAmber,
        tertiary: VerveTokens.vitalEmerald,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: Colors.white),
        bodyLarge: TextStyle(fontFamily: 'Inter', color: Colors.white),
        bodyMedium: TextStyle(fontFamily: 'JetBrains Mono', color: Colors.white70), // For data
      ),
    );
  }
}
