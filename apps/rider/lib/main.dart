import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ProviderScope(child: RiderPulseApp()));
}

class RiderPulseApp extends StatelessWidget {
  const RiderPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verve Rider Pulse',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const PulseHome(),
    );
  }
}

class PulseHome extends StatelessWidget {
  const PulseHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rider Pulse')),
      body: const Center(child: Text('Verve Rider App - Dispatch, Navigation, Earnings')),
    );
  }
}
